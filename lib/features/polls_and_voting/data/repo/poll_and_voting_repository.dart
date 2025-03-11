import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class PollAndVotingRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> createPoll(dynamic data) {
    return post('$serviceUrl/client/polls', data, formdata: true);
  }

  Future<WayaRequestResponse> castVote(dynamic amountPaid, String qty, String choiceId, String pollId) {
    final payload = {
      "choiceSelections": [
        {"choiceId": choiceId, "quantity": qty}
      ],
      "paymentMethod": "WALLET",
      "amountPaid": amountPaid
    };

    return post("$serviceUrl/client/polls/$pollId/votes", payload);
  }

  Future<WayaRequestResponse> deletePoll(pollId) {
    return delete("$serviceUrl/client/polls/$pollId");
  }

  Future<WayaRequestResponse> getAllPolls(int page, [int limit = 15, String? creatorId]) {
    return get(
        "$serviceUrl/client/polls?page=$page&limit=$limit&orderBy=createdAt&orderDirection=DESC${creatorId != null ? '&creatorId=$creatorId' : ''}");
  }

  Future<WayaRequestResponse> getMyPolls(String creatorId, int page) {
    return get("$serviceUrl/client/polls?page=$page&creatorId=$creatorId&orderBy=createdAt&orderDirection=DESC");
  }

  Future<WayaRequestResponse> getDashboardPolls(String pollId) {
    return get("$serviceUrl/client/polls/$pollId/votes");
  }

  Future<WayaRequestResponse> getDashboard(String pollId) {
    return get("$serviceUrl/client/polls?orderBy=createdAt&orderDirection=DESC&id=$pollId");
  }

  Future<WayaRequestResponse> getAllPollsById(String id) {
    return get("$serviceUrl/client/polls/$id");
  }

  Future<WayaRequestResponse> getAPollsByUrl(String url) {
    return get("$serviceUrl/client/polls/get-id/$url");
  }

  Future<WayaRequestResponse> getAllFeedPolls() {
    return get("$serviceUrl/client/polls?limit=10&page=1&orderBy=createdAt&orderDirection=DESC");
  }
}
