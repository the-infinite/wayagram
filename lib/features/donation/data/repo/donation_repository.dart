
import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
class DonationRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> donate(String campaignId, dynamic amount, String message) {
    final payload = {
      "amount": amount,
      "isAnonymous": false,
      "message": message
    };
    return post("$serviceUrl/client/donations/$campaignId/donate", payload);
  }

  Future<WayaRequestResponse> getSingleDonation(String donationId) {
    return get("$serviceUrl/client/donations/$donationId");
  }

  Future<WayaRequestResponse> updateDonation(
      String amount, String campaignId) {
    final payload = { "minimumDonationAmount": amount};

    return patch("$serviceUrl/client/campaigns/$campaignId", payload);
  }

  Future<WayaRequestResponse> createCampaign(String title, String description,
      String solution, String impact, dynamic targetAmount, dynamic minimumAmount,
      String privacy, String expirationDate, String image, String startDate) {
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
      "startDate": startDate
    };
    return post("$serviceUrl/client/campaigns", payload);
  }

  Future<WayaRequestResponse> getAllCampaigns(int page) {
    return get("$serviceUrl/client/campaigns?page=$page");
  }

  // Future<WayaRequestResponse> getMyCampaigns(String organizerId, int page) {
  //   return get("$serviceUrl/client/campaigns?page=$page&organizerId=$organizerId");
  // }

  Future<WayaRequestResponse> getMyCampaigns(String organizerId,) {
    return get("$serviceUrl/client/campaigns?organizerId=$organizerId");
  }

  Future<WayaRequestResponse> getSingleCampaign(String campaignId) {
    return get("$serviceUrl/client/campaigns/$campaignId");
  }

  Future<WayaRequestResponse> confirmWalletPin(ConfirmWalletPin payload) {
    return post('wayagram-wallet/api/v2/client/wallet-pin/confirm-pin',
        payload.toJson());
  }

  Future<WayaRequestResponse> createPin(CreateWalletPin payload) {
    return post(
        'wayagram-wallet/api/v2/client/wallet-pin/create', payload.toJson());
  }


}
