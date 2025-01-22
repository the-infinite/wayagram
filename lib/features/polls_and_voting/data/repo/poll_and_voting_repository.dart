
import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/polls_and_voting/data/model/create_poll_model.dart';

class PollAndVotingRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> createPoll(dynamic data) {
    return post('$serviceUrl/client/polls', data, formdata: true);
  }

  Future<WayaRequestResponse> castVote(dynamic amountPaid, String qty, String choiceId) {
    final payload = {
      "choiceSelections": [
        {
          "choiceId": choiceId,
          "quantity": qty
        }
      ],
      "paymentMethod": "WALLET",
      "amountPaid": amountPaid
    };

    return post("$serviceUrl/client/polls/$choiceId/vote", payload);
  }

  Future<WayaRequestResponse> getAllPolls() {
    return get("$serviceUrl/client/polls");
  }

  Future<WayaRequestResponse> getMyPolls(String creatorId) {
    return get("$serviceUrl/client/polls/?creatorId=$creatorId");
  }

  Future<WayaRequestResponse> getDashboardPolls(String pollId) {
    return get("$serviceUrl/client/polls/$pollId/votes");
  }

  Future<WayaRequestResponse> getAllPollsById({required String id}) {
    return get("$serviceUrl/client/polls/$id");
  }



}