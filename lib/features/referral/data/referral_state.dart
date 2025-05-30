import 'package:wayagram/features/referral/model/referral_count_model.dart';
import 'package:wayagram/features/referral/model/referral_model.dart';

class ReferralState {
  final int? earned;
  final int? count;
  final int page;
  final bool isLastPage;
  final bool? isLoading;
  final String? endDate;
  final String? startDate;
  final ReferralCountModel? referralCount;
  final ReferralCountModel? referralEarned;
  final List<ReferralModel> referralList;
  final List<ReferralModel> referralListCopy;

  ReferralState({
    this.page = 1,
    this.earned = 0,
    this.count = 0,
    this.endDate,
    this.startDate,
    this.isLoading = false,
    this.isLastPage = false,
    this.referralCount,
    this.referralEarned,
    this.referralList = const [],
    this.referralListCopy = const [],
  });

  ReferralState copyWith({
    int? earned,
    int? count,
    int? page,
    bool? isLastPage,
    bool? isLoading,
    String? startDate,
    String? endDate,
    ReferralCountModel? referralCount,
    ReferralCountModel? referralEarned,
    List<ReferralModel>? referralList,
    List<ReferralModel>? referralListCopy,
  }) =>
      ReferralState(
        earned: earned ?? this.earned,
        count: count ?? this.count,
        page: page ?? this.page,
        referralList: referralList ?? this.referralList,
        referralListCopy: referralListCopy ?? this.referralListCopy,
        referralEarned: referralEarned ?? this.referralEarned,
        referralCount: referralCount ?? this.referralCount,
        isLoading: isLoading ?? this.isLoading,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        isLastPage: isLastPage ?? this.isLastPage,
      );
}
