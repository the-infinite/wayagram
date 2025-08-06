import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/data/repo/donation_repository.dart';
import 'package:wayagram/shared/features/profile/model/donation.dart';
import 'package:wayagram/shared/features/profile/state/donation.dart';

class UserDonationsNotifier extends StateNotifier<DonationsState> {
  final DonationRepository repo;
  UserDonationsNotifier(this.repo) : super(DonationsState.initial);

  Future<List<DonationModel>> getDonationsByUser(String id) async {
    final result = <DonationModel>[];

    try {
      // This is fine too.
      final response = await repo.getAllCampaigns(
          state.nextPage ?? state.page, state.limit, id);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs =
            (data['docs'] as List).map((doc) => DonationModel.fromJson(doc));

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? This is fine.
        state = state.copyWith(
          docs: result,
          totalSize: data['totalDocs'],
          totalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
          hasNextPage: data['hasNextPage'],
          page: int.tryParse(data['page'].toString()) ?? 1,
          nextPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          hasLoaded: true,
        );
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.donations,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  void reset() {
    state = DonationsState.initial;
  }
}

final userDonationsProvider =
    StateNotifierProvider.family<UserDonationsNotifier, DonationsState, String>(
        (ref, id) {
  final donation = ref.watch(donationRepositoryProvider);
  return UserDonationsNotifier(donation);
});
