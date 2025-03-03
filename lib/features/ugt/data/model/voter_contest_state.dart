import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

class VoterDetailState {
  final bool? isLoading;
  final bool? ismakePaymentLoading;
  final String createPostId;
  final String? contestId;
  final Wallet? data;
  final List<MyContestContestantModel> myContestList;
  final List<MyContestContestantModel> myContestListCopy;
  final List<ExternalWalletModel>? externalWallets;
  VoterDetailState({
    this.isLoading = false,
    this.ismakePaymentLoading = false,
    this.data,
    this.createPostId = "",
    this.contestId = "",
    
    this.myContestList = const[],
    this.myContestListCopy = const[],
    this.externalWallets,
  });

  VoterDetailState copyWith({
    bool? isLoading,
    Wallet? data,
    String? createPostId, 
    String? contestId, 
    List<ExternalWalletModel>? externalWallets,
    List<MyContestContestantModel>? myContestList,
    List<MyContestContestantModel>? myContestListCopy,
  }) =>
      VoterDetailState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        createPostId:createPostId??this.createPostId,
        contestId:contestId??this.contestId,
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
