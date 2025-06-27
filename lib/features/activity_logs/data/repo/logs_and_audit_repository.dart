import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';

import '../../../../core/service/api_service/request_model.dart';

class ActivityLogsRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.graph;
  static const walletServiceUrl = WayaServiceUri.wallet;

  Future<WayaRequestResponse> getVisitedPages(int page) {
    return get("$serviceUrl/activity-logs?limit=2&page=$page&logType=visited-pages");
  }

  Future<WayaRequestResponse> getCMSClicks(int page) {
    return get("wayagram-shop/api/v2/activity-logs?limit=10&page=$page&logType=cms-clicks");
  }

  Future<WayaRequestResponse> getUserActions(int page) {
    return get(
        "https://services.staging.wayagram.ng/wayagram-shop/api/v2/activity-logs?limit=10&page=$page&logType=user-actions");
  }

  Future<WayaRequestResponse> getUserInteractions(int page) {
    return get("$serviceUrl/activity-logs?limit=10&page=$page&logType=user-interactions");
  }

  Future<WayaRequestResponse> getSearchLogs(int page) {
    return get("wayagram-profile/api/v2/client/activity-logs?limit=90&page=$page&logType=search-logs");
  }

  Future<WayaRequestResponse> getPaymentActivity(int page) {
    return get("wayagram-wallet/api/v2/client/activity-logs?limit=10&page=$page&logType=payment-activity");
  }

  Future<WayaRequestResponse> getLoginHistory(int page) {
    return get("wayagram-profile/api/v2/client/activity-logs?limit=100&page=$page&logType=login-history");
  }

  Future<WayaRequestResponse> getAccountActivity(int page) {
    return get("wayagram-profile/api/v2/client/activity-logs?limit=10&page=$page&logType=login-history");
  }

  Future<WayaRequestResponse> getDonationLogs(int page) {
    return get("wayagram-products/api/v1/client/activity-logs?limit=100&page=$page&logType=donation");
  }


  Future<WayaRequestResponse> getPageLogs(int page) {
    return get("$serviceUrl/activity-logs?limit=100&page=$page&logType=pages");
  }

  Future<WayaRequestResponse> getGroupLogs(int page) {
    return get("$serviceUrl/activity-logs?limit=100&page=$page&logType=groups");
  }

  Future<WayaRequestResponse> getEventLogs(int page) {
    return get("$serviceUrl/activity-logs?limit=100&page=$page&logType=events");
  }

  Future<WayaRequestResponse> getSocialLogs(int page) {
    return get("$serviceUrl/activity-logs?limit=100&page=$page&logType=chat-and-socials");
  }

  Future<WayaRequestResponse> getShopLogs(int page) {
    return get("$serviceUrl/client/activity-logs?limit=100&page=$page&logType=shop");
  }

  Future<WayaRequestResponse> getPollLogs(int page) {
    return get("wayagram-products/api/v1/client/activity-logs?limit=100&page=$page&logType=polls-and-voting");
  }

  Future<WayaRequestResponse> getUgtLogs(int page) {
    return get("$serviceUrl/client/activity-logs?limit=100&page=$page&logType=ugt");
  }

  Future<WayaRequestResponse> getWalletLogs(int page) {
    return get("$walletServiceUrl/client/activity-logs?limit=100&page=$page");
  }

  Future<WayaRequestResponse> getQuotationLogs(int page) {
    return get("wayagram-shop/api/v2/activity-logs?limit=100&page=$page");
  }
}
