import 'dart:io';

import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import '../model/create_contest.dart';

class ContestRepo extends BaseRepository {
  static const serviceUrl2 = "school-contest/api/v1";

  Future<WayaRequestResponse> getCategory() {
    return get('$serviceUrl2/category/getAll');
  }

  // Future<WayaRequestResponse> createContest(CreateContestModel payLoad){
  //
  //   return post('$serviceUrl/contests/create',payLoad.toJson());
  // }

  Future<WayaRequestResponse> createContest(payLoad) {
    return post('$serviceUrl2/contests/create', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> registerContest(payLoad) {
    return post('$serviceUrl2/application/', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> getContestForAll(int page) {
    return get('$serviceUrl2/contests/contest-for-you?page=$page');
  }

  Future<WayaRequestResponse> fetchHostedContest(String userId, int page) {
    return get(
        '$serviceUrl2/contests/hostedContests-by-profile?profileId=$userId&page=$page');
  }

    Future<WayaRequestResponse> fetchAppliedContest(String userId) {
    return get(
        '$serviceUrl2/application/$userId/appliedContest');
  }

  Future<WayaRequestResponse> likeContest(payLoad) {
    return post('$serviceUrl2/contestInteraction/like', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> shareContest(payLoad) {
    return post('$serviceUrl2/contestInteraction/share', payLoad,
        formdata: false);
  }



  /*Future<WayaRequestResponse> createContestController({
    required final String contestStatus,
    required final String profileId,
    required final String title,
    required final String category,
    required final String state,
    required final String winnerPrize,
    required final String description,
    required final String voteCountToQualify,
    required final int amount,
    required final String durationType,
    required final String numberOfDuration,
    required final String descriptionOfAwards,
    required final int amountPerVote,
    required final String type,
    required final String overallResult,
    required final String multipleStages,
    required final String publicity,
    required final String status,
    required final String howItWorks,
    required final int numberOfWeeks,
    required final String currentStage,
    required final String participationStartDate,
    required final String startDate,
    required final String endDate,
    required final String entryType,
    required List<Map<String, dynamic>> stages,
    required List<Map<String, dynamic>> formRequirements,
  }) async {
    final response = await post('$serviceUrl/contests/create', {
      "title": title,
      "profileId": profileId,
      "category": category,
      "state": state,
      "winnerPrize": winnerPrize,
      "description": description,
      "voteCountToQualify": voteCountToQualify,
      "amount": amountPerVote,
      "durationType": numberOfWeeks,
      "numberOfDuration": numberOfDuration,
      "descriptionOfAwards": description,
      "amountPerVote": amountPerVote,
      "type": type,
      "overallResult": overallResult,
      "multipleStages": multipleStages,
      "publicity": publicity,
      "status": status,
      "howItWorks": howItWorks,
      "numberOfWeeks": numberOfWeeks,
      "currentStage": currentStage,
      "participationStartDate": participationStartDate,
      "startDate": startDate,
      "endDate": endDate,
      "entryType": entryType,
      "contestSettings": {
        "stages":stages,
      },
      "formRequirements":formRequirements,
    });
    print("newSingle ${response}");
    return response;
  }*/
}
