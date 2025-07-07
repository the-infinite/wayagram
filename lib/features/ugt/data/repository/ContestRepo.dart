import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/waya_constants.dart';

class ContestRepo extends BaseRepository {
  static const serviceUrl2 = WayaServiceUri.contest;

  Future<WayaRequestResponse> getCategory() {
    return get('$serviceUrl2/category/getAll');
  }

  // Future<WayaRequestResponse> createContest(CreateContestModel payLoad){
  //
  //   return post('$serviceUrl/contests/create',payLoad.toJson());
  // }
  Future<WayaRequestResponse> requestPayout(String contestId) {
    return post('$serviceUrl2/contest-payout', {"contestId": contestId},
        formdata: false);
  }

  Future<WayaRequestResponse> fetchTransactionHistory(String contestId) {
    return get(
        '$serviceUrl2/contest-payout/get-transactions?contestId=$contestId');
  }

  Future<WayaRequestResponse> fetchPayoutHistory(String contestId) {
    return get('$serviceUrl2/contest-payout/get-payouts?contestId=$contestId');
  }

  Future<WayaRequestResponse> createContest(payLoad) {
    return post('$serviceUrl2/contests/create', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> editContest(String contestId, payLoad) {
    return patch('$serviceUrl2/contests/edit-contest/$contestId', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> registerContest(payLoad) {
    return post('$serviceUrl2/application/', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> getContestForYou(int page, String? filter) {
    if (filter == "All States") {
      return get('$serviceUrl2/contests/contest-for-you?page=$page');
    }
    if (filter != null) {
      return get(
          '$serviceUrl2/contests/contest-for-you?page=$page&state=$filter');
    } else {
      return get('$serviceUrl2/contests/contest-for-you?page=$page');
    }
  }

  Future<WayaRequestResponse> fetchHostedContest(String userId, int page) {
    return get(
        '$serviceUrl2/contests/hostedContests-by-profile?profileId=$userId&page=$page');
  }

  Future<WayaRequestResponse> fetchAppliedContest(String userId, int page) {
    return get('$serviceUrl2/application/$userId/appliedContest?page=$page');
  }

  Future<WayaRequestResponse> fetchAppliedSingleContest(
      String userId, String contestId) {
    return get(
        '$serviceUrl2/application/$userId/appliedContest?contestId=$contestId');
  }

  Future<WayaRequestResponse> fetchFollowedVoteContest(String userId) {
    return get('$serviceUrl2/contests/contest-follow-vote/$userId');
  }

  Future<WayaRequestResponse> getContestantProfileVoteDetails(String userId) {
    return get('$serviceUrl2/profile/votes/$userId');
  }

  Future<WayaRequestResponse> likeContest(payLoad) {
    return post('$serviceUrl2/contestInteraction/like', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> followContest(payLoad) {
    return post('$serviceUrl2/contestInteraction/follow', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> shareContest(payLoad) {
    return post('$serviceUrl2/contestInteraction/share', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> createProfile(payLoad) {
    return post('$serviceUrl2/profile/create', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> editProfile(String id, payLoad) {
    return put('$serviceUrl2/profile/profiles/$id', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> createContestPost(payLoad) {
    return post('$serviceUrl2/gallery/upload', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> voteContestant(payLoad) {
    return post('$serviceUrl2/vote', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> fetchSingleContestantGallery(
      String contestantProfileId) {
    return get('$serviceUrl2/gallery/$contestantProfileId/gallery');
  }

  Future<WayaRequestResponse> fetchAllContestGallery(
      String contestId, bool approved) {
    return get('$serviceUrl2/gallery/$contestId?hostApproved=$approved');
  }

  Future<WayaRequestResponse> approveDisapprovePost(String galleryId) {
    return patch('$serviceUrl2/gallery/$galleryId/approval', {});
  }

  Future<WayaRequestResponse> fetchAllContestApplicant(String contestId) {
    return get('$serviceUrl2/application/applicants/$contestId');
  }

  Future<WayaRequestResponse> fetchVoterList(String contestantId, int page) {
    return get(
        '$serviceUrl2/vote/contestants-voters/?contestantId=$contestantId&status=SUCCESS&page=$page');
  }

  Future<WayaRequestResponse> acceptRejectContestants(
      String contestId, Map<String, dynamic> payLoad) {
    return patch('$serviceUrl2/application/$contestId/status', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> payForPaidContest(payLoad) {
    return post('$serviceUrl2/profile/pay-for-contest', payLoad,
        formdata: false);
  }

/*   Future<WayaRequestResponse> payForPaidStageContest(payLoad) {
    return post('$serviceUrl2/profile/pay-for-contest', payLoad,
        formdata: false);
  } */

  Future<WayaRequestResponse> startStage(payLoad) {
    return patch('$serviceUrl2/contests/start-stage', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> qualifyDisqualify(payLoad) {
    return put('$serviceUrl2/profile/status', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> acceptFreeStageContest(payLoad) {
    return patch('$serviceUrl2/profile/accept-stage', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> acceptPaidStageContest(payLoad) {
    return post('$serviceUrl2/profile/pay-for-satge', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> fetchAllTotalEarningContest(
      String contestId, String filter) {
    return get(
        '$serviceUrl2/statistics/transaction?filter=$filter&contestId=$contestId');
  }

  Future<WayaRequestResponse> fetchAllTotalContest(String contestId) {
    return get(
        '$serviceUrl2/statistics/contestant-profiles?contestId=$contestId');
  }

  Future<WayaRequestResponse> fetchVoteStatsContest(String contestId) {
    return get('$serviceUrl2/statistics/votes-stats?contestId=$contestId');
  }

  Future<WayaRequestResponse> deletePost(String postId) {
    return delete('$serviceUrl2/gallery/$postId/delete');
  }

  Future<WayaRequestResponse> fetchSingleContestantDetails(
      String contestId, String contestantProfileId) {
    return get(
        '$serviceUrl2/profile/votes/$contestId?profileId=$contestantProfileId');
  }

  Future<WayaRequestResponse> fetchSingleContest(String contestId) {
    return get('$serviceUrl2/contests/web/contest-for-you?id=$contestId');
    //  return get('$serviceUrl2/admin/contests/?id=$contestId');
  }
}
