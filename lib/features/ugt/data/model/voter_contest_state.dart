import 'package:wayagram/features/ugt/contest_dashboard.dart/contest_dashboard.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart'
    as contestant;
import 'package:wayagram/features/ugt/data/model/ugt_all_post_contest_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_contest_aplicant_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_single_contestant_profile_model.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

class VoterDetailState {
  final bool? isLoading;
  final bool? isActive;
  final bool? ismakePaymentLoading;
  final String createPostId;
  final int? pendingPostCount;
  final String? contestId;
  final Wallet? data;
  final List<contestant.MyContestContestantModel> myContestList;
  final List<Stage> stageList;
  final List<ApplicantContestModel> myContestApplicantList;
  final List<ApplicantContestModel> myFilteredContestApplicantList;
  final List<contestant.MyContestContestantModel> myContestListCopy;
  final List<MyFilterModel> filterList;
  final List<UgtAllPostContestModel> myPostList;
  final List<UgtAllPostContestModel> myApprovePostList;
  final List<ExternalWalletModel>? externalWallets;
  VoterDetailState({
    this.isLoading = false,
    this.isActive = true,
    this.ismakePaymentLoading = false,
    this.data,
    this.createPostId = "",
    this.pendingPostCount = 0,
    this.contestId = "",
    this.myPostList = const [],
    this.myApprovePostList = const [],
    this.myContestApplicantList = const [],
    this.myFilteredContestApplicantList = const [],
    this.stageList = const [],
    this.filterList = const[
     

    ],
    this.myContestList = const [],
    this.myContestListCopy = const [],
    this.externalWallets,
  });

  VoterDetailState copyWith({
    bool? isLoading,
    bool? isActive,
    Wallet? data,
    String? createPostId,
    int? pendingPostCount,
    String? contestId,
    List<UgtAllPostContestModel>? myPostList,
    List<UgtAllPostContestModel>? myApprovePostList,
    List<Stage>? stageList,
    List<MyFilterModel>? filterList,
    List<ApplicantContestModel>? myContestApplicantList,
    List<ApplicantContestModel>? myFilteredContestApplicantList,
    List<ExternalWalletModel>? externalWallets,
    List<contestant.MyContestContestantModel>? myContestList,
    List<contestant.MyContestContestantModel>? myContestListCopy,
  }) =>
      VoterDetailState(
        isLoading: isLoading ?? this.isLoading,
        isActive: isActive ?? this.isActive,
        data: data ?? this.data,
        myPostList: myPostList ?? this.myPostList,
        myApprovePostList: myApprovePostList ?? this.myApprovePostList,
        stageList: stageList ?? this.stageList,
        filterList: filterList ?? this.filterList,
        myContestApplicantList:
            myContestApplicantList ?? this.myContestApplicantList,
        myFilteredContestApplicantList: myFilteredContestApplicantList ??
            this.myFilteredContestApplicantList,
        createPostId: createPostId ?? this.createPostId,
        pendingPostCount: pendingPostCount ?? this.pendingPostCount,
        contestId: contestId ?? this.contestId,
        myContestList: myContestList ?? this.myContestList,
        myContestListCopy: myContestListCopy ?? this.myContestListCopy,
        externalWallets: externalWallets ?? this.externalWallets,
      );
}

class WalletFundingOptionState {
  final bool? isLoading;
  final List<WalletFundingOptionModel>? fundingOptions;
  WalletFundingOptionState({this.isLoading = false, this.fundingOptions});

  WalletFundingOptionState copyWith(
          {bool? isLoading, List<WalletFundingOptionModel>? fundingOptions}) =>
      WalletFundingOptionState(
          isLoading: isLoading ?? this.isLoading,
          fundingOptions: fundingOptions ?? this.fundingOptions);
}
