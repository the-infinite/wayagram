import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/repo/default.dart';
import 'package:wayagram/shared/features/quotation/state/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class QuotationsNotifier extends StateNotifier<QuotationsState> {
  final repo = QuotationRepository.instance;
  QuotationsNotifier(super.value);

  /// Helper function used to call [getBuyRequests] only if this has not yet been
  /// loaded.
  Future<List<BuyRequestModel>> getBuyRequestsIfNotLoaded() async {
    if (!state.hasLoadedRequests) {
      await ShopResource.configureShop(ConversationState.self.id);
      return getBuyRequests();
    }

    return state.requests;
  }

  /// Helper function used to get all buy requests made in the context of this
  /// particular quotations notifier. Useful when we want to get quotations from
  /// other users.
  Future<List<BuyRequestModel>> getBuyRequests() async {
    final result = <BuyRequestModel>[];

    //? This is fine.
    if (state.isLoadingRequests) {
      return state.requests;
    }

    try {
      //? Now, we are loading bro.
      state = state.copyWith(isLoadingRequests: true);

      //? This is fine.
      final response = !state.isUser && ConversationState.self.accountType == UserAccountType.business
          ? await repo.getAllAvailableQuotation(state.limit, state.requestPage)
          : await repo.getBuyerRequest(state.limit, state.requestPage, state.requestStatus, state.isUser);

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
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
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
    try {
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
            requests: [...previous],
          );
        }

        //? Return the document.
        return doc;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return null;
  }

  /// Helper function used to cancel a single buy request.
  Future<bool> cancelRequest(String id) async {
    try {
      final response = await repo.updateCancelRequest(id: id);

      //? If it was fine...
      if (response.success) {
        final found = state.requests.indexWhere((request) => request.id == id);

        //? If this is in this place.
        if (found != -1) {
          final current = state.requests[found];
          final copy = state.requests;

          // This is fine.
          copy[found] = current.copyWith(
            status: BuyRequestStatus.cancelled,
          );

          //? This is fine.
          state = state.copyWith(
            requests: copy,
          );
        }
      }

      //? Return this value if it was fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return false;
  }

  /// Helper function used to send a bid action request to the server. We use it
  /// to simplify some processes.
  Future<bool> sendBidAction(BidActionModel data) async {
    try {
      final response = await repo.sendBidAction(data);

      // This is fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to place a bid so that we can enter a quote auction.
  Future<QuotationBidModel?> sendBid(String requestId, double amount, String shopId) async {
    try {
      final response = await repo.placeBid(
        requestId: requestId,
        amount: amount,
        shopId: shopId,
        vendorId: ConversationState.self.id,
      );

      //? This is fine.
      if (response.success) {
        //? The data.
        final data = response.data['data'];

        //? Parse the single buy request to ensure we are doing things right.
        final doc = QuotationBidModel.fromJson(data);

        //? STylishly sneak this bid into the list of bids on screen.
        state = state.copyWith(
          bids: [
            doc,
            ...state.bids,
          ],
        );

        //? Return the document.
        return doc;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return null;
  }

  /// Helper function used to get all bids from the server that a given user has
  /// made since origin and time past.
  Future<List<QuotationBidModel>> getBids(String shopId) async {
    final result = <QuotationBidModel>[];
    final requests = <BuyRequestModel>[];

    try {
      //? Now, we are loading bro.
      state = state.copyWith(isLoadingRequests: true);

      //? This is fine.
      final response = await repo.getVendorQuotation(shopId, state.limit, state.bidPage);

      //? This is fine.
      if (response.success) {
        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextRequest) {
          result.addAll(state.bids);
          requests.addAll(state.bidRequests);
        }

        //? The data.
        final data = response.data['data'];

        //? Parse the buy requests first so we can extrapolate what we need.
        final docs = (data['docs'] as List).map((doc) => BuyRequestModel.fromJson(doc)).toList();

        //? Next, we can parse and add the bids to this place that they might be
        //? worth generating and using.
        for (final quote in docs) {
          result.addAll(quote.bids?.where((bid) => bid.vendorId == ConversationState.self.id) ?? []);
        }

        //? Then add all the quotes (buy requests)
        requests.addAll(docs);

        //? Update state.
        state = state.copyWith(
          hasLoadedBids: true,
          bids: result,
          bidRequests: requests,
          totalBids: data['totalDocs'],
          bidPages: data['totalPages'],
          hasNextBid: data['hasNextPage'],
          bidPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          isLoadingBids: false,
        );
      }

      //? Since it failed.
      else {
        state = state.copyWith(isLoadingBids: false);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return our compounded result.
    return result;
  }

  /// Helper function used to get the overview/summary of the bids the user
  /// has made with his or her account.
  Future<BidDashboardModel?> getBidsOverview(String shopId) async {
    try {
      final response = await repo.getBidDashboard(shopId: shopId);

      //? This is fine.
      if (response.success) {
        //? The data.
        final data = response.data['data'];

        //? Parse the single buy request to ensure we are doing things right.
        final doc = BidDashboardModel.fromJson(data);

        //? Update the bid dashboard state with this.
        state = state.copyWith(
          overview: doc,
        );

        //? Return the document.
        return doc;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return null;
  }

  /// Helper function used to get the details of a single quotation order probably
  /// in order to update the seller and buyer in "real-time."
  Future<BidOrderModel?> getOrderDetails(String id) async {
    try {
      final response = await repo.retrieveOrder(id);

      //? This is fine.
      if (response.success) {
        //? The data.
        final data = response.data['data'];

        //? Parse the single buy request to ensure we are doing things right.
        final doc = BidOrderModel.fromJson(data);

        //? Return the document.
        return doc;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return null;
  }

  /// Helper function used to update the status of a single order. This is useful
  /// when we want to update the status of a single order in the system.
  Future<bool> updateOrderStatus(String id, QuotationOrderStatus status) async {
    try {
      final response = await repo.updateOrderStatus(id, status.value);

      //? This is fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return false;
  }

  /// Helper function used to update the delivery status of a single order. This is
  ///  useful when we want to update the status of a single order in the system.
  Future<bool> updateDeliveryStatus(String id, QuotationDeliveryStatus status) async {
    try {
      final response = await repo.updateDeliveryStatus(id, status.value);

      //? This is fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return false;
  }

  /// Helper function used to update the pickup status of a single order. This is
  ///  useful when we want to update the status of a single order in the system.
  Future<bool> updatePickupStatus(String id, QuotationPickupStatus status) async {
    try {
      final response = await repo.updatePickupStatus(id, status.value);

      //? This is fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return false;
  }

  /// Helper function used to extend the time of a bid. This is useful when we
  /// want to extend the time of a bid in the system.
  Future<bool> extendBidTime(String id, String time) async {
    try {
      final response = await repo.extendBidTime(id: id, time: time);

      //? When this was fine, update the buy request in question.
      if (response.success) {
        await getBuyRequest(id);
      }

      //? This is fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return false;
  }

  /// Helper function used to update the amount of a single request. This is useful
  /// when we want to update the amount of a single request in the system.
  Future<bool> updateRequestAmount(String id, double amount) async {
    try {
      final response = await repo.updateRequestAmount(id: id, amount: amount.toStringAsFixed(2));

      //? When this was fine, update the buy request in question.
      if (response.success) {
        await getBuyRequest(id);
      }

      //? This is fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return false;
  }

  /// Helper function used to complete an order. This is useful when we want to
  /// complete an order in the system.
  Future<bool> completeOrder(String id, String token) async {
    try {
      final response = await repo.completeOrder(orderId: id, token: token);

      //? This is fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.quotations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Since it failed.
    return false;
  }

  /// Helper function used to search the list of quotes that this store has bid
  /// on in an attempt to find the corresponding quote to a single bid. That
  /// way, on the front-end, we do not drive ourselves somewhat insane and the
  /// server-side needs write no additional code.
  ///
  /// Nice, right?
  BuyRequestModel? getBidQuote(String id) {
    return state.bidRequests.where((quote) => quote.id == id).firstOrNull;
  }

  /// Helper function that is used to get the value of a single bid using its
  /// ID.
  QuotationBidModel? getBid(String id) {
    return state.bids.where((bid) => bid.id == id).firstOrNull;
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
