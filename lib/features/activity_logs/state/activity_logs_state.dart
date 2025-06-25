import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/activity_logs/data/model/account_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/cms_model.dart';
import 'package:wayagram/features/activity_logs/data/model/donation_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/group_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/login_history_model.dart';
import 'package:wayagram/features/activity_logs/data/model/page_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/payment_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/polls_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/search_log_model.dart';
import 'package:wayagram/features/activity_logs/data/model/user_actions_model.dart';
import 'package:wayagram/features/activity_logs/data/model/user_interaction_model.dart';
import 'package:wayagram/features/activity_logs/data/model/visited_pages_model.dart';

enum FilterType {
  allTime._("All Time"),
  thisWeek._("This Week"),
  thisMonth._("This Month"),
  thisYear._("This Year");

  final String name;

  const FilterType._(this.name);
}

class ActivityLogsState {
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
  List<PageDocs> shopDocs;
  List<PageDocs> shopDocs1;
  List<PageDocs> walletDocs;
  List<PageDocs> walletDocs1;
  List<PageDocs> quotationDocs;
  List<PageDocs> quotationDocs1;
  List<PollsActivityDocs> pollDocs;
  List<PollsActivityDocs> pollDocs1;
  List<PageDocs> eventDocs;
  List<PageDocs> eventDocs1;
  List<PageDocs> pageDocs;
  List<PageDocs> pageDocs1;
  List<PageDocs> socialDocs;
  List<PageDocs> socialDocs1;
  List<PageDocs> ugtDocs;
  List<PageDocs> ugtDocs1;
  List<GroupDocs> groupDocs;
  List<GroupDocs> groupDocs1;
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
    this.pollDocs = const [],
    this.pollDocs1 = const [],
    this.ugtDocs = const [],
    this.ugtDocs1 = const [],
    this.eventDocs = const [],
    this.eventDocs1 = const [],
    this.walletDocs = const [],
    this.walletDocs1 = const [],
    this.quotationDocs = const [],
    this.quotationDocs1 = const [],
    this.shopDocs = const [],
    this.shopDocs1 = const [],
    this.socialDocs = const [],
    this.socialDocs1 = const [],
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
  }) : title = title ?? TextEditingController();

  ActivityLogsState copyWith({
    TextEditingController? title,
    List<LoginHistoryDocs>? loginHistoryDocs,
    List<PageDocs>? ugtDocs,
    List<PageDocs>? ugtDocs1,
    List<PageDocs>? walletDocs,
    List<PageDocs>? walletDocs1,
    List<PageDocs>? shopDocs,
    List<PageDocs>? shopDocs1,
    List<PageDocs>? quotationDocs,
    List<PageDocs>? quotationDocs1,
    List<PollsActivityDocs>? pollDocs,
    List<PollsActivityDocs>? pollDocs1,
    List<PageDocs>? eventDocs,
    List<PageDocs>? eventDocs1,
    List<PageDocs>? socialDocs,
    List<PageDocs>? socialDocs1,
    List<CmsDocs>? cmsDocs,
    List<CmsDocs>? cmsDocs1,
    List<DonationDocs>? donationDocs,
    List<DonationDocs>? donationDocs1,
    List<PageDocs>? pageDocs,
    List<PageDocs>? pageDocs1,
    List<GroupDocs>? groupDocs,
    List<GroupDocs>? groupDocs1,
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
  }) {
    return ActivityLogsState(
      title: title ?? this.title,
      loginHistoryDocs: loginHistoryDocs ?? this.loginHistoryDocs,
      cmsDocs: cmsDocs ?? this.cmsDocs,
      cmsDocs1: cmsDocs1 ?? this.cmsDocs1,
      quotationDocs: quotationDocs ?? this.quotationDocs,
      quotationDocs1: quotationDocs1 ?? this.quotationDocs1,
      pollDocs: pollDocs ?? this.pollDocs,
      pollDocs1: pollDocs1 ?? this.pollDocs1,
      walletDocs: walletDocs ?? this.walletDocs,
      walletDocs1: walletDocs1 ?? this.walletDocs1,
      socialDocs: socialDocs ?? this.socialDocs,
      socialDocs1: socialDocs1 ?? this.socialDocs1,
      groupDocs: groupDocs ?? this.groupDocs,
      groupDocs1: groupDocs1 ?? this.groupDocs1,
      eventDocs: eventDocs ?? this.eventDocs,
      eventDocs1: eventDocs1 ?? this.eventDocs1,
      ugtDocs: ugtDocs1 ?? this.ugtDocs,
      ugtDocs1: ugtDocs1 ?? this.ugtDocs1,
      pageDocs: pageDocs ?? this.pageDocs,
      pageDocs1: pageDocs1 ?? this.pageDocs1,
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

  List<DonationDocs> filterDonationDocs(DateTime start, DateTime end) {
    Iterable<DonationDocs> result = donationDocs;

    //? First, we want to only include things that have their start date before
    result = result.where((donation) {
      final timestamp = DateTime.parse(donation.createdAt!);
      return !timestamp.isBefore(start);
    });

    //? Second, we want to only include things things that are on or before our
    //? end date.
    result = result.where((donation) {
      final timestamp = DateTime.parse(donation.createdAt!);
      return !timestamp.isAfter(end);
    });

    // Return this one.
    return result.toList();
  }
}
