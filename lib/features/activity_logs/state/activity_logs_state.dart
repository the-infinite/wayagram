
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:wayagram/features/activity_logs/data/model/cms_model.dart';
import 'package:wayagram/features/activity_logs/data/model/login_history_model.dart';
import 'package:wayagram/features/activity_logs/data/model/payment_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/search_log_model.dart';
import 'package:wayagram/features/activity_logs/data/model/user_actions_model.dart';
import 'package:wayagram/features/activity_logs/data/model/user_interaction_model.dart';
import 'package:wayagram/features/activity_logs/data/model/visited_pages_model.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/create_donation_response.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';

class ActivityLogsState{
  final TextEditingController title;
  List<LoginHistoryDocs> loginHistoryDocs;
  List<CmsDocs> cmsDocs;
  List<PaymentActivityDocs> paymentActivityDocs;
  List<SearchLogDocs> searchLogDocs;
  List<UserActionsDocs> userActionsDocs;
  List<UserInteractionDocs> userInteractionDocs;
  List<VisitedPagesDocs> visitedPagesDocs;
  VisitedPagesModel? visitedPagesModel;

  final bool isLoading;

  ActivityLogsState({
    TextEditingController? title,

    this.isLoading = false,
    this.loginHistoryDocs = const [],
    this.cmsDocs = const [],
    this.paymentActivityDocs = const [],
    this.searchLogDocs = const [],
    this.userActionsDocs = const [],
    this.userInteractionDocs = const [],
    this.visitedPagesDocs = const [],
    this.visitedPagesModel,

  }):   title = title ?? TextEditingController();

  ActivityLogsState copyWith({
    TextEditingController? title,
    List<LoginHistoryDocs>? loginHistoryDocs,
    List<CmsDocs>? cmsDocs,
    List<PaymentActivityDocs>? paymentActivityDocs,
    List<SearchLogDocs>? searchLogDocs,
    List<UserActionsDocs>? userActionsDocs,
    List<UserInteractionDocs>? userInteractionDocs,
    List<VisitedPagesDocs>? visitedPagesDocs,
    VisitedPagesModel? visitedPagesModel,
    bool? isLoading,


  }){
    return ActivityLogsState(
      title: title ?? this.title,
      loginHistoryDocs: loginHistoryDocs ?? this.loginHistoryDocs,
      cmsDocs: cmsDocs ?? this.cmsDocs,
      paymentActivityDocs: paymentActivityDocs ?? this.paymentActivityDocs,
      searchLogDocs: searchLogDocs ?? this.searchLogDocs,
      userActionsDocs: userActionsDocs ?? this.userActionsDocs,
      userInteractionDocs: userInteractionDocs ?? this.userInteractionDocs,
      visitedPagesDocs: visitedPagesDocs ?? this.visitedPagesDocs,
      visitedPagesModel: visitedPagesModel ?? this.visitedPagesModel,

    );
  }
}

