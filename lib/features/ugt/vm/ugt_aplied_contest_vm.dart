import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/ugt/data/model/applied_contest_state.dart';
import 'package:wayagram/features/ugt/data/model/ugt_applied_post_model.dart';
import 'package:wayagram/features/ugt/data/repository/contest_repo.dart';

class AppliedContestNotifier extends StateNotifier<AppliedContestState> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;

  AppliedContestNotifier(this._contestRepository, this._localDataSource)
      : super(AppliedContestState());

  //int _page = 1; // Pagination tracking
  bool isLoading = false;

  // Simulate fetching paginated posts
  Future<void> fetchAppliedContest(bool isFirst) async {
    //? Added pagination to fetching applied contest

    /*  if (isFirst) {
      if (state.page != 1) {
        state = state.copyWith(page: 1);
      }
    } */
    //? If last page dont go fetch again

    if (state.isLastPage && isFirst == false) {
      return;
    }

    //? is still fetching data
    if (state.isLoading == true) {
      return;
    }

    try {
      //?start loading

      try {
        state = state.copyWith(isLoading: true);
      } catch (_) {}
      final response = await _contestRepository.fetchAppliedContest(
          _localDataSource.getUserId().toString(), isFirst ? 1 : state.page);
      state = state.copyWith(isLoading: false);
      //  List<AppliedContestModel> contestList = [];

      //?on success
      if (response.success) {
        AppliedContest responseModel = AppliedContest.fromJson(response.data);
        //  contestList = responseModel.data?.docs??[];
        //? get wether page is last page or not
        state = state.copyWith(
            isLastPage: responseModel.data?.hasNextPage == true ? false : true);
        //?to differentiate if it is first page or not

        if (isFirst) {
          state = state.copyWith(listAppliedContest: [], page: 1);

          state = state.copyWith(
              listAppliedContest: responseModel.data?.docs ?? [], page: 1);
        } else {
          state = state.copyWith(listAppliedContest: [
            ...state.listAppliedContest,
            ...responseModel.data?.docs ?? []
          ]);
        }
        //? increase the page either way
        state = state.copyWith(page: state.page + 1);
      }

      // return contestList;
    } catch (e) {
      //? stop loading
      state = state.copyWith(isLoading: false);
      debugPrint(e.toString());
    } finally {
      isLoading = false;
    }
  }

  // Simulate fetching paginated posts
  Future<AppliedContestModel?> fetchSingleAppliedContest(
      String contestId) async {
    try {
      //?start loading

      final response = await _contestRepository.fetchAppliedSingleContest(
          _localDataSource.getUserId().toString(), contestId);

      //?on success

      if (response.success) {
        AppliedContest responseModel = AppliedContest.fromJson(response.data);

        if (responseModel.data?.docs?.isNotEmpty == true) {
          return responseModel.data?.docs?.first;
        } else {
          return null;
        }
      } else {
        return null;
      }

      // return contestList;
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
    return null;
  }
}

//? My notifier
final selectedAppliedContestProvider =
    StateProvider<AppliedContestModel?>((ref) {
  return AppliedContestModel(
      id: "",
      contestId: "",
      userId: "userId",
      fullName: "fullName",
      email: "",
      phoneNumber: "phoneNumber",
      address: "address",
      state: "",
      likeCount: 0,
      shareCount: 0,
      followCount: 0,
      contestSettings: null,
      applicationData: null,
      status: "status",
      rejectionReason: "",
      createdAt: null,
      updatedAt: "",
      applicantCount: 0,
      contest: null,
      categoryName: "");
});
// Provider
final appliedContestProvider =
    StateNotifierProvider<AppliedContestNotifier, AppliedContestState>((ref) {
  return AppliedContestNotifier(ContestRepo(), WayaLocalDataSource());
});
