import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';

class DonationRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> donate(String campaignId, int amount, String message) {
    final payload =
    {"amount": num.parse('$amount'),
      "isAnonymous": false,
      "message": message};
    return post("$serviceUrl/client/donations/donate/$campaignId", payload);
  }

  Future<WayaRequestResponse> getSingleDonation(String donationId) {
    return get("$serviceUrl/client/donations/$donationId");
  }

  Future<WayaRequestResponse> updateDonation(String amount, String campaignId) {
    final payload = {"minimumDonationAmount": amount};

    return patch("$serviceUrl/client/campaigns/$campaignId", payload);
  }

  Future<WayaRequestResponse> createCampaign(
      String title,
      String description,
      String solution,
      String impact,
      dynamic targetAmount,
      dynamic minimumAmount,
      String privacy,
      String expirationDate,
      String image,
      String startDate,
      String category
      ) {
    final payload = {
      "title": title,
      "description": description,
      "solution": solution,
      "impact": impact,
      "targetAmount": targetAmount,
      "minimumDonationAmount": minimumAmount,
      "privacy": privacy,
      "expirationDate": expirationDate,
      "imageURL": image,
      "startDate": startDate,
      "category": category
    };
    return post("$serviceUrl/client/campaigns", payload);
  }

  // Future<WayaRequestResponse> getAllCampaigns(int page, [int limit = 15, String? organizerId]) {
  //   return get("$serviceUrl/client/campaigns?page=$page&limit=$limit&${organizerId != null ? '&organizerId=$organizerId' : ''}");
  // }

  Future<WayaRequestResponse> getAllCampaigns(int page, [int limit = 15, String? organizerId]) {
    return get("$serviceUrl/client/campaigns?limit=$limit&page=$page&status=live&${organizerId != null ? '&organizerId=$organizerId' : ''}");
  }

  Future<WayaRequestResponse> getMyCampaigns(
    String organizerId,
  ) {
    return get("$serviceUrl/client/campaigns?organizerId=$organizerId&status=live");
  }

  Future<WayaRequestResponse> getApprovedDonation(
    String organizerId,
  ) {
    return get("$serviceUrl/client/campaigns?organizerId=$organizerId&status=approved");
  }

  Future<WayaRequestResponse> getAppliedDonation(
    String organizerId,
  ) {
    return get("$serviceUrl/client/campaigns?organizerId=$organizerId&status=pending_approval");
  }

  Future<WayaRequestResponse> getRejectedDonation(
      String organizerId,
      ) {
    return get("$serviceUrl/client/campaigns?organizerId=$organizerId&status=rejected");
  }

  Future<WayaRequestResponse> getDonationCategory(

      ) {
    return get("$serviceUrl/client/campaigns/categories?limit=10&page=1");
  }

  Future<WayaRequestResponse> getDonatedDonations(int page,
      ) {
    return get("$serviceUrl/client/campaigns/donated?page=$page");
  }

  Future<WayaRequestResponse> getSingleCampaign(String campaignId) {
    return get("$serviceUrl/client/campaigns/$campaignId");
  }

  Future<WayaRequestResponse> getMyKYC(
    String userId,
  ) {
    return get(
        "wayagram-profile/api/v2/client/kyc/get-business-kyc-by-user-id?userId=$userId",
        useBase: false);
  }

  Future<WayaRequestResponse> confirmWalletPin(ConfirmWalletPin payload) {
    return post('wayagram-wallet/api/v2/client/wallet-pin/confirm-pin', payload.toJson());
  }

  Future<WayaRequestResponse> createPin(CreateWalletPin payload) {
    return post('wayagram-wallet/api/v2/client/wallet-pin/create', payload.toJson());
  }
}
