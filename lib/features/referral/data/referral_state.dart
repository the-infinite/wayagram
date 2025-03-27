import 'package:wayagram/features/referral/model/referral_count_model.dart';
import 'package:wayagram/features/referral/model/referral_model.dart';


class ReferralState {
  final int? earned;
  final int? count;
  final int page;
  final bool isLastPage;
  final bool? isLoading;
  final ReferralCountModel? referralCount;
  final ReferralCountModel? referralEarned;
  final List<ReferralModel> referralList;
 

  ReferralState({
    this.earned = 0,
    this.count = 0,
    this.page = 1,
    this.isLoading = false,
    this.isLastPage = false,
    this.referralCount,
    this.referralEarned,
    this.referralList = const [],
   
  });

  ReferralState copyWith({
      int? earned,
   int? count,
   int? page,
   bool? isLastPage,
   bool? isLoading,
   ReferralCountModel? referralCount,
   ReferralCountModel? referralEarned,
   List<ReferralModel>? referralList,
   
  }) =>
      ReferralState(
        earned: earned ?? this.earned,
        count: count ?? this.count,
        referralList: referralList ?? this.referralList,
        referralEarned: referralEarned ?? this.referralEarned,
        referralCount: referralCount ?? this.referralCount,
    
        isLoading: isLoading ?? this.isLoading,
      
        page: page ?? this.page,
        isLastPage: isLastPage ?? this.isLastPage,
      );
}
