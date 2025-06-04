import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';

class PollAndVotingRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> createPoll(dynamic data) {
    return post('$serviceUrl/client/polls', data,
        formdata: true, showErrors: true);
  }

  Future<WayaRequestResponse> requestSettlement(String pollId) {
    final payload = {
      "pollId": pollId
    };
    return post('$serviceUrl/client/polls/request/payouts', payload, showErrors: true);
  }

  Future<WayaRequestResponse> getAllRequestPayout(int page,
      [int limit = 15,]) {
    return get(
        "$serviceUrl/client/polls/all/payouts?limit=$limit&page=$page");
  }


  Future<WayaRequestResponse> castVote(
      dynamic amountPaid, String qty, String choiceId, String pollId) {
    final payload = {
      "choiceSelections": [
        {"choiceId": choiceId, "quantity": qty}
      ],
      "paymentMethod": "WALLET",
      "amountPaid": amountPaid
    };

    return post("$serviceUrl/client/polls/$pollId/votes", payload,
        showErrors: true);
  }

  Future<WayaRequestResponse> castFreeVote(
      num qty, String choiceId, String pollId) {
    final payload = {
      "choiceSelections": [
        {"choiceId": choiceId, "quantity": qty}
      ],
      "paymentMethod": "WALLET",
      //"amountPaid": amountPaid
    };

    return post("$serviceUrl/client/polls/$pollId/votes", payload,
        showErrors: true);
  }

  Future<WayaRequestResponse> deletePoll(pollId) {
    return delete("$serviceUrl/client/polls/$pollId", showErrors: true);
  }

  Future<WayaRequestResponse> getAllPolls(int page,
      [int limit = 15, String? creatorId]) {
    return get(
        "$serviceUrl/client/polls?page=$page&limit=$limit&orderBy=createdAt&orderDirection=DESC&status=active&pollStatus=ongoing");
  }

  Future<WayaRequestResponse> getAllPendingPolls(int page,String creatorId,
      [int limit = 15, ]) {
    return get(
        "$serviceUrl/client/polls?page=$page&creatorId=$creatorId&limit=$limit&orderBy=createdAt&orderDirection=DESC&status=active&pollStatus=pending");
  }

  Future<WayaRequestResponse> getMyPolls(String creatorId, int page) {
    return get(
        "$serviceUrl/client/polls?page=$page&creatorId=$creatorId&orderBy=createdAt&orderDirection=DESC&status=active");
  }

  Future<WayaRequestResponse> getActivePolls(String creatorId, int page) {
    return get(
        "$serviceUrl/client/polls?page=$page&creatorId=$creatorId&orderBy=createdAt&orderDirection=DESC&status=active&pollStatus=ongoing");
  }

  Future<WayaRequestResponse> getInActivePolls(String creatorId, int page) {
    return get(
        "$serviceUrl/client/polls?page=$page&creatorId=$creatorId&orderBy=createdAt&orderDirection=DESC&status=active&pollStatus=closed");
  }

  Future<WayaRequestResponse> getDashboardPolls(String pollId) {
    return get("$serviceUrl/client/polls/$pollId/votes");
  }

  Future<WayaRequestResponse> getDashboard(String pollId) {
    return get(
        "$serviceUrl/client/polls?orderBy=createdAt&orderDirection=DESC&id=$pollId");
  }

  Future<WayaRequestResponse> getAllPollsById(String id) {
    return get("$serviceUrl/client/polls?id=$id");
  }

  Future<WayaRequestResponse> confirmWalletPin(ConfirmWalletPin payload) {
    return post('wayagram-wallet/api/v2/client/wallet-pin/confirm-pin',
        payload.toJson());
  }

  Future<WayaRequestResponse> getAPollsByUrl(String url) {
    return get("$serviceUrl/client/polls/get-id/$url");
  }

  Future<WayaRequestResponse> getAllFeedPolls() {
    return get(
        "$serviceUrl/client/polls?limit=100&page=1&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> getSinglePollById({required String id}) {
    return get("$serviceUrl/client/polls/$id");
  }
}
