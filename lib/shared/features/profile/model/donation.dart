import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

part 'donation.g.dart';

@JsonSerializable()
class DonationModel {
  final String id;
  final String title;
  final String description;
  final String solution;
  final String impact;
  final String organizerId;
  final List<String>? categories;
  final int? donationCount;
  final String? targetAmount;
  final bool? showRaised;
  final String? minimumDonationAmount;
  final String? amountRaised;
  final DateTime expirationDate;
  final DateTime startDate;
  final String? status;
  final String? privacy;
  final String? imageURL;
  final bool? contributorsVisible;
  final String? url;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Construct.
  DonationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.solution,
    required this.impact,
    required this.organizerId,
    required this.categories,
    required this.donationCount,
    required this.targetAmount,
    required this.showRaised,
    required this.minimumDonationAmount,
    required this.amountRaised,
    required this.expirationDate,
    required this.startDate,
    required this.status,
    required this.privacy,
    required this.imageURL,
    required this.contributorsVisible,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) => _$DonationModelFromJson(json);

  Map<String, dynamic> toJson() => _$DonationModelToJson(this);

  Future<CachedUserDataTuple?> get organizerDetails => UserResource.getUserDetails(organizerId);
}
