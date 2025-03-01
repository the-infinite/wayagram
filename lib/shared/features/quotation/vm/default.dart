import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/repo/default.dart';
import 'package:wayagram/shared/features/quotation/state/default.dart';

class QuotationsNotifier extends StateNotifier<QuotationsState> {
  final repo = QuotationRepository.instance;
  QuotationsNotifier(super.value);

  /// Helper function used to call [getBuyRequests] only if this has not yet been
  /// loaded.
  Future<List<BuyRequestModel>> getBuyRequestsIfNotLoaded() async {
    if (!state.hasLoadedRequests) {
      return getBuyRequests();
    }

    return state.requests;
  }

  /// Helper function used to get all buy requests made in the context of this
  /// particular quotations notifier. Useful when we want to get quotations from
  /// other users.
  Future<List<BuyRequestModel>> getBuyRequests() async {
    final result = <BuyRequestModel>[];

    //? Now, we are loading bro.
    state = state.copyWith(isLoadingRequests: true);

    //? This is fine.
    final response = await repo.getBuyerRequest(state.limit, state.bidPage, state.requestStatus, state.isUser);

    //? This is fine.
    if (response.success) {
      //? If the previous page had a next page, offload them onto this place.
      if (state.hasNextRequest) {
        result.addAll(state.requests);
      }

      //? The data.
      final data = response.data['data'];

      //? Parse the conversations as they are in the response object...
      final docs = (data['docs'] as List).map((doc) => BuyRequestModel.fromJson(doc)).toList();

      //? This is fine.
      result.addAll(docs);

      //? Update state.
      state = state.copyWith(
        hasLoadedRequests: true,
        requests: result,
        totalRequests: data['totalDocs'],
        requestPages: data['totalPages'],
        hasNextRequest: data['hasNextPage'],
        requestPage: int.tryParse(data['nextPage'].toString()) ?? 1,
        isLoadingRequests: false,
      );
    }

    //? Since it failed.
    else {
      state = state.copyWith(isLoadingRequests: false);
    }

    //? Return this collated result.
    return result;
  }

  /// Helper function used to retrieve all information pertaining to a single
  /// buy request. This is useful when we want to get a single buy request. Note
  /// that this would update the value of the corresponding buy request in the
  /// list of buy requests.
  Future<BuyRequestModel?> getBuyRequest(String id) async {
    final response = await repo.retrieveBuyRequest(id);

    //? This is fine.
    if (response.success) {
      //? The data.
      final data = response.data['data'];

      //? Parse the single buy request to ensure we are doing things right.
      final doc = BuyRequestModel.fromJson(data);

      //? Update the buy request in the list of buy requests.
      final index = state.requests.indexWhere((element) => element.id == id);

      //? This is fine.
      if (index != -1) {
        final previous = state.requests;
        previous[index] = doc;
        state = state.copyWith(
          requests: previous,
        );
      }

      //? Return the document.
      return doc;
    }

    //? Since it failed.
    return null;
  }

  /// Helper function used to reset the state of this quotations notifier back
  /// to square 1. This is useful when we want to reset the state of the
  /// quotations notifier in its specific context. This is aware of when this
  /// notifier was made for all users or the logged in user.
  void reset() {
    //? Reset the quotation state for the user.
    if (state.isUser) {
      state = QuotationsState.self;
    }

    //? Reset the quotation state for other users.
    else {
      state = QuotationsState.others;
    }
  }
}

final userQuotationsProvider = StateNotifierProvider<QuotationsNotifier, QuotationsState>((ref) {
  return QuotationsNotifier(QuotationsState.self);
});

final othersQuotationsProvider = StateNotifierProvider<QuotationsNotifier, QuotationsState>((ref) {
  return QuotationsNotifier(QuotationsState.others);
});
