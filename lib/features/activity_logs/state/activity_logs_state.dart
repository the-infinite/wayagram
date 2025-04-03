
import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/activity_logs/data/model/account_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/cms_model.dart';
import 'package:wayagram/features/activity_logs/data/model/donation_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/login_history_model.dart';
import 'package:wayagram/features/activity_logs/data/model/payment_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/search_log_model.dart';
import 'package:wayagram/features/activity_logs/data/model/user_actions_model.dart';
import 'package:wayagram/features/activity_logs/data/model/user_interaction_model.dart';
import 'package:wayagram/features/activity_logs/data/model/visited_pages_model.dart';

class ActivityLogsState{
  final TextEditingController title;
  List<LoginHistoryDocs> loginHistoryDocs;
  List<AccountActivityDocs> accountActivityDocs;
  List<AccountActivityDocs> accountActivityDocs1;
  List<CmsDocs> cmsDocs;
  List<CmsDocs> cmsDocs1;
  List<PaymentActivityDocs> paymentActivityDocs;
  List<PaymentActivityDocs> paymentActivityDocs1;
  List<SearchLogDocs> searchLogDocs;
  List<DonationDocs> donationDocs;
  List<DonationDocs> donationDocs1;
  List<DonationDocs> pageDocs;
  List<DonationDocs> pageDocs1;
  List<DonationDocs> groupDocs;
  List<DonationDocs> groupDocs1;
  List<SearchLogDocs> searchLogDocs1;
  List<UserActionsDocs> userActionsDocs;
  List<UserActionsDocs> userActionsDocs1;
  List<UserInteractionDocs> userInteractionDocs;
  List<UserInteractionDocs> userInteractionDocs1;
  List<VisitedPagesDocs> visitedPagesDocs;
  List<VisitedPagesDocs> visitedPagesDocs1;
  VisitedPagesModel? visitedPagesModel;

  final bool isLoading;

  ActivityLogsState({
    TextEditingController? title,

    this.isLoading = false,
    this.loginHistoryDocs = const [],
    this.cmsDocs = const [],
    this.cmsDocs1 = const [],
    this.accountActivityDocs = const [],
    this.accountActivityDocs1 = const [],
    this.paymentActivityDocs = const [],
    this.paymentActivityDocs1 = const [],
    this.pageDocs = const [],
    this.pageDocs1 = const [],
    this.groupDocs = const [],
    this.groupDocs1 = const [],
    this.donationDocs = const [],
    this.donationDocs1 = const [],
    this.searchLogDocs = const [],
    this.searchLogDocs1 = const [],
    this.userActionsDocs = const [],
    this.userActionsDocs1 = const [],
    this.userInteractionDocs = const [],
    this.userInteractionDocs1 = const [],
    this.visitedPagesDocs = const [],
    this.visitedPagesDocs1 = const [],
    this.visitedPagesModel,

  }):   title = title ?? TextEditingController();

  ActivityLogsState copyWith({
    TextEditingController? title,
    List<LoginHistoryDocs>? loginHistoryDocs,
    List<CmsDocs>? cmsDocs,
    List<CmsDocs>? cmsDocs1,
    List<DonationDocs>? donationDocs,
    List<DonationDocs>? donationDocs1,
    List<DonationDocs>? pageDocs,
    List<DonationDocs>? pageDocs1,
    List<DonationDocs>? groupDocs,
    List<DonationDocs>? groupDocs1,
    List<AccountActivityDocs>? accountActivityDocs,
    List<AccountActivityDocs>? accountActivityDocs1,
    List<PaymentActivityDocs>? paymentActivityDocs,
    List<PaymentActivityDocs>? paymentActivityDocs1,
    List<SearchLogDocs>? searchLogDocs,
    List<SearchLogDocs>? searchLogDocs1,
    List<UserActionsDocs>? userActionsDocs,
    List<UserActionsDocs>? userActionsDocs1,
    List<UserInteractionDocs>? userInteractionDocs,
    List<UserInteractionDocs>? userInteractionDocs1,
    List<VisitedPagesDocs>? visitedPagesDocs,
    List<VisitedPagesDocs>? visitedPagesDocs1,
    VisitedPagesModel? visitedPagesModel,
    bool? isLoading,


  }){
    return ActivityLogsState(
      title: title ?? this.title,
      loginHistoryDocs: loginHistoryDocs ?? this.loginHistoryDocs,
      cmsDocs: cmsDocs ?? this.cmsDocs,
      cmsDocs1: cmsDocs1 ?? this.cmsDocs1,
      donationDocs: donationDocs ?? this.donationDocs,
      donationDocs1: donationDocs1 ?? this.donationDocs1,
      accountActivityDocs: accountActivityDocs ?? this.accountActivityDocs,
      accountActivityDocs1: accountActivityDocs1 ?? this.accountActivityDocs1,
      paymentActivityDocs: paymentActivityDocs ?? this.paymentActivityDocs,
      paymentActivityDocs1: paymentActivityDocs1 ?? this.paymentActivityDocs1,
      searchLogDocs: searchLogDocs ?? this.searchLogDocs,
      searchLogDocs1: searchLogDocs1 ?? this.searchLogDocs1,
      userActionsDocs: userActionsDocs ?? this.userActionsDocs,
      userActionsDocs1: userActionsDocs1 ?? this.userActionsDocs1,
      userInteractionDocs: userInteractionDocs ?? this.userInteractionDocs,
      userInteractionDocs1: userInteractionDocs1 ?? this.userInteractionDocs1,
      visitedPagesDocs: visitedPagesDocs ?? this.visitedPagesDocs,
      visitedPagesDocs1: visitedPagesDocs1 ?? this.visitedPagesDocs1,
      visitedPagesModel: visitedPagesModel ?? this.visitedPagesModel,

    );
  }
}

