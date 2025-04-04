
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/cms_model.dart';
import 'package:wayagram/features/activity_logs/data/model/donation_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/login_history_model.dart';
import 'package:wayagram/features/activity_logs/data/model/page_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/user_interaction_model.dart';
import 'package:wayagram/features/activity_logs/view/visited_page.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/data/repo/donation_repository.dart';
import 'package:wayagram/features/donation/donation_modal/donation_modal.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/create_donation_response.dart';
import 'package:wayagram/features/donation/model/kyc_model.dart';
import 'package:wayagram/features/donation/model/login_response.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/state/donation_state.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

import '../../auth/transaction_pin/vm/transaction_pin_vm.dart';
import '../data/model/account_activity_model.dart';
import '../data/model/payment_activity_model.dart';
import '../data/model/search_log_model.dart';
import '../data/model/user_actions_model.dart';
import '../data/model/visited_pages_model.dart';
import '../data/repo/logs_and_audit_repository.dart';
import '../state/activity_logs_state.dart';

class ActivityLogsVm extends StateNotifier<ActivityLogsState> {
  final Ref ref;
  final ActivityLogsRepository _activityLogsRepository;

  final _logger = getLogger('ActivityLogsVm');
  ActivityLogsVm( this._activityLogsRepository,
      this.ref,)
      : super(ActivityLogsState());

  Future<PaginatedResult<AccountActivityDocs>?> getAccountActivity({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getAccountActivity(page);
      List<AccountActivityDocs>? fetchLoginHistoryDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        AccountActivityModel responseModel = AccountActivityModel.fromJson(response.data);
        fetchLoginHistoryDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(accountActivityDocs: fetchLoginHistoryDocs);
        state = state.copyWith(accountActivityDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchLoginHistoryDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<DonationDocs>?> getDonationLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getDonationLogs(page);
      List<DonationDocs>? fetchDonationDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        DonationActivityModel responseModel = DonationActivityModel.fromJson(response.data);
        fetchDonationDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(donationDocs: fetchDonationDocs);
        state = state.copyWith(donationDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchDonationDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PageDocs>?> getPageLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getPageLogs(page);
      List<PageDocs>? fetchPageDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PageActivityModel responseModel = PageActivityModel.fromJson(response.data);
        fetchPageDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(pageDocs: fetchPageDocs);
        state = state.copyWith(pageDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchPageDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<DonationDocs>?> getGroupLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getGroupLogs(page);
      List<DonationDocs>? fetchGroupDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        DonationActivityModel responseModel = DonationActivityModel.fromJson(response.data);
        fetchGroupDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(groupDocs: fetchGroupDocs);
        state = state.copyWith(groupDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchGroupDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PageDocs>?> getSocialLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getSocialLogs(page);
      List<PageDocs>? fetchSocialDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PageActivityModel responseModel = PageActivityModel.fromJson(response.data);
        fetchSocialDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(socialDocs: fetchSocialDocs);
        state = state.copyWith(socialDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchSocialDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PageDocs>?> getUgtLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getUgtLogs(page);
      List<PageDocs>? fetchUgtDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PageActivityModel responseModel = PageActivityModel.fromJson(response.data);
        fetchUgtDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(ugtDocs: fetchUgtDocs);
        state = state.copyWith(ugtDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchUgtDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PageDocs>?> getEventLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getEventLogs(page);
      List<PageDocs>? fetchEventDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PageActivityModel responseModel = PageActivityModel.fromJson(response.data);
        fetchEventDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(ugtDocs: fetchEventDocs);
        state = state.copyWith(ugtDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchEventDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PageDocs>?> getShopLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getShopLogs(page);
      List<PageDocs>? fetchShopDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PageActivityModel responseModel = PageActivityModel.fromJson(response.data);
        fetchShopDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(ugtDocs: fetchShopDocs);
        state = state.copyWith(ugtDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchShopDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PageDocs>?> getPollLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getPollLogs(page);
      List<PageDocs>? fetchPollDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PageActivityModel responseModel = PageActivityModel.fromJson(response.data);
        fetchPollDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(pollDocs: fetchPollDocs);
        state = state.copyWith(pollDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchPollDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PageDocs>?> getWalletLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getWalletLogs(page);
      List<PageDocs>? fetchWalletDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PageActivityModel responseModel = PageActivityModel.fromJson(response.data);
        fetchWalletDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(walletDocs: fetchWalletDocs);
        state = state.copyWith(walletDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchWalletDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PageDocs>?> getQuotationLogs({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getQuotationLogs(page);
      List<PageDocs>? fetchQuotationDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PageActivityModel responseModel = PageActivityModel.fromJson(response.data);
        fetchQuotationDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(quotationDocs: fetchQuotationDocs);
        state = state.copyWith(quotationDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchQuotationDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<VisitedPagesDocs>?>  getVisitedPages({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getVisitedPages(page);
      List<VisitedPagesDocs>? fetchVisitedPagesDocs = [];

      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        VisitedPagesModel responseModel = VisitedPagesModel.fromJson(response.data);
        fetchVisitedPagesDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(visitedPagesDocs: fetchVisitedPagesDocs);
        state = state.copyWith(visitedPagesDocs: responseModel.data?.docs,
        visitedPagesDocs1: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchVisitedPagesDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<CmsDocs>?> getCmsClicks({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getCMSClicks(page);
      List<CmsDocs>? fetchCmsDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        CmsModel responseModel = CmsModel.fromJson(response.data);
        fetchCmsDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(cmsDocs: fetchCmsDocs);
        state = state.copyWith(cmsDocs: responseModel.data?.docs,
        cmsDocs1: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchCmsDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<UserActionsDocs>?> getUserAction({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getUserActions(page);
      List<UserActionsDocs>? fetchUserActionDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        UserActionsModel responseModel = UserActionsModel.fromJson(response.data);
        fetchUserActionDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(userActionsDocs: fetchUserActionDocs);
        state = state.copyWith(userActionsDocs: responseModel.data?.docs,
        userActionsDocs1: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchUserActionDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<PaymentActivityDocs>?> getPaymentActivity({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getPaymentActivity(page);
      List<PaymentActivityDocs>? fetchPaymentActivityDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PaymentActivityModel responseModel = PaymentActivityModel.fromJson(response.data);
        fetchPaymentActivityDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(paymentActivityDocs: fetchPaymentActivityDocs);
        state = state.copyWith(paymentActivityDocs: responseModel.data?.docs,
        paymentActivityDocs1: responseModel.data?.docs,);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items: fetchPaymentActivityDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<UserInteractionDocs>?> getUserInteraction({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getUserInteractions(page);
      List<UserInteractionDocs>? fetchUserInteractionDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        UserInteractionModel responseModel = UserInteractionModel.fromJson(response.data);
        fetchUserInteractionDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(userInteractionDocs: fetchUserInteractionDocs);
        state = state.copyWith(userInteractionDocs: responseModel.data?.docs,
        userInteractionDocs1: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items: fetchUserInteractionDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<PaginatedResult<SearchLogDocs>?> getSearchLog({required int page}) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _activityLogsRepository.getSearchLogs(page);
      List<SearchLogDocs>? fetchSearchLogsDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        SearchLogModel responseModel = SearchLogModel.fromJson(response.data);
        fetchSearchLogsDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(searchLogDocs: fetchSearchLogsDocs);
        state = state.copyWith(searchLogDocs: responseModel.data?.docs,
        searchLogDocs1: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items: fetchSearchLogsDocs!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }



}

final activityLogsVmProvider =
StateNotifierProvider<ActivityLogsVm, ActivityLogsState>((ref) {
  return ActivityLogsVm( ActivityLogsRepository(), ref);
});
