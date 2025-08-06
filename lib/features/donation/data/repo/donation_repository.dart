import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';

part 'donation_repository.g.dart';

class DonationRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = "wayagram-products/api/v1";
  static const walletServiceUrl = WayaServiceUri.wallet;

  DonationRepository(super.ref);

  Future<WayaRequestResponse> donate(
      String campaignId, int amount, String message) {
    final payload = {
      "amount": num.parse('$amount'),
      "isAnonymous": false,
      "message": message
    };
    return post("$serviceUrl/client/donations/donate/$campaignId", payload);
  }

  Future<WayaRequestResponse> getPayoutCommission() {
    return get("$walletServiceUrl/client/commission/commission-rates");
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
    String category,
    bool showRaised,
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
      "category": category,
      "showRaised": showRaised
    };
    return post("$serviceUrl/client/campaigns", payload);
  }

  Future<WayaRequestResponse> getAllCampaigns(int page,
      [int limit = 15, String? organizerId]) {
    return get(
        "$serviceUrl/client/campaigns?page=$page&limit=$limit&status=live");
  }

  Future<WayaRequestResponse> getMyCampaigns(
    String organizerId,
  ) {
    return get(
        "$serviceUrl/client/campaigns?organizerId=$organizerId&status=live");
  }

  Future<WayaRequestResponse> getApprovedDonation(
    String organizerId,
  ) {
    return get(
        "$serviceUrl/client/campaigns?organizerId=$organizerId&status=approved");
  }

  Future<WayaRequestResponse> getAppliedDonation(
    String organizerId,
  ) {
    return get(
        "$serviceUrl/client/campaigns?organizerId=$organizerId&status=pending_approval");
  }

  Future<WayaRequestResponse> getClosedDonation(
    String organizerId,
  ) {
    return get(
        "$serviceUrl/client/campaigns?organizerId=$organizerId&status=closed");
  }

  Future<WayaRequestResponse> getRejectedDonation(
    String organizerId,
  ) {
    return get(
        "$serviceUrl/client/campaigns?organizerId=$organizerId&status=rejected");
  }

  Future<WayaRequestResponse> getDonationCategory() {
    return get("$serviceUrl/client/campaigns/categories?limit=10&page=1");
  }

  Future<WayaRequestResponse> getDonationBasedOnCategory(String categoryName) {
    return get("$serviceUrl/client/campaigns?category=$categoryName");
  }

  Future<WayaRequestResponse> getDonatedDonations(
    int page,
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
    return post('wayagram-wallet/api/v2/client/wallet-pin/confirm-pin',
        payload.toJson());
  }

  Future<WayaRequestResponse> createPin(CreateWalletPin payload) {
    return post(
        'wayagram-wallet/api/v2/client/wallet-pin/create', payload.toJson());
  }

  Future<WayaRequestResponse> getDonationSettings() {
    return get("$serviceUrl/client/donation-settings/settings");
  }

  Future<WayaRequestResponse> updateDonationSettings(
      bool notifyFriends, bool makeDonationsPublic) {
    return patch('$serviceUrl/client/donation-settings/settings', {
      "notifyFriends": notifyFriends,
      "makeDonationsPublic": makeDonationsPublic
    });
  }
}

@riverpod
DonationRepository donationRepository(Ref ref) {
  return DonationRepository(ref);
}
