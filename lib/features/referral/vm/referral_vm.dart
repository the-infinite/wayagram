import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/referral/data/referral_state.dart';
import 'package:wayagram/features/referral/data/repo/referral_repo.dart';
import 'package:wayagram/features/referral/model/referral_count_model.dart';
import 'package:wayagram/features/referral/model/referral_model.dart';
import '../../../core/data/local_data_source.dart';

class ReferralVm extends StateNotifier<ReferralState> {
  final ReferralRepo _referralRepository;
  final WayaLocalDataSource _localDataSource;
//this is ok

  ReferralVm(this._referralRepository, this._localDataSource)
      : super(ReferralState());

  Future<void> getReferralCount() async {
    final response =
        await _referralRepository.getReferralCount(getLoggedInUserId() ?? "");
    if (response.success == true) {
      ReferralCountModel responseModel =
          ReferralCountModel.fromJson(response.data);
      state = state.copyWith(count: responseModel.data);
    } else {}
  }

  Future<void> getReferralEarned() async {
    final response =
        await _referralRepository.getReferralEarned(getLoggedInUserId() ?? "");
    if (response.success == true) {
      ReferralCountModel responseModel =
          ReferralCountModel.fromJson(response.data);
      state = state.copyWith(count: responseModel.data);
    } else {}
  }

  String? getLoggedInUserId() {
    return _localDataSource.getUserId().toString();
  }

  Future<void> getAllUserReferrals(
    bool isFirst,
  ) async {
    /*  if (isFirst) {
      state = state.copyWith(page: 1);
    } */
    if (state.isLastPage && isFirst == false) {
      return;
    }
    if (state.isLoading == true) {
      return;
    }
    try {
      state = state.copyWith(isLoading: true);
      final response = await _referralRepository.getUserReferral(
          getLoggedInUserId() ?? "", isFirst ? 1 : state.page,
          startDate: state.startDate ?? "1990-12-31",
          endDate: state.endDate ?? "3021-12-31");
      state = state.copyWith(isLoading: false);
      if (response.success == true) {
        ReferralModelBase responseModel =
            ReferralModelBase.fromJson(response.data);
        state = state.copyWith(
            isLastPage: responseModel.data?.hasNextPage == true ? false : true);
        if (isFirst) {
          state = state.copyWith(
              referralList: responseModel.data?.docs ?? [], page: 1);
        } else {
          state = state.copyWith(referralList: [
            ...state.referralList,
            ...responseModel.data?.docs ?? []
          ]);
        }
        state = state.copyWith(page: state.page + 1);
        // contestList = responseModel.data?.docs ?? [];
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint(e.toString());
    } finally {}
  }
  void updateStartAndEndDate(String? startDate, String? endDate){
   state = state.copyWith(startDate: startDate, endDate: endDate);
}
}



final referralVm = StateNotifierProvider<ReferralVm, ReferralState>(
  (ref) {
    return ReferralVm(ReferralRepo(), WayaLocalDataSource());
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});
