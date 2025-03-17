import 'package:json_annotation/json_annotation.dart';

part 'quotation_model.g.dart';

@JsonSerializable()
class CreateBuyerRequest {
  final String buyerId;
  final String productName;
  final String? brand;
  final String category;
  final String condition;
  final String description;
  final String quantity;
  final String bidStart;
  final String bidEnd;
  final String deliveryDetails;
  final String minDistance;
  final String maxDistance;
  final String stateOfPurchase;
  final String lga;
  final String vendorsCanSeeBidFromAnyDistance;
  final String deliveryType;
  final String? deliveryAddress;
  final String? deliveryState;
  final String? deliveryLga;
  final double maxBidAmount;
  final double bidStartingAmount;

  CreateBuyerRequest({
    required this.buyerId,
    required this.productName,
    required this.brand,
    required this.category,
    required this.condition,
    required this.description,
    required this.quantity,
    required this.bidStart,
    required this.bidEnd,
    required this.deliveryDetails,
    required this.minDistance,
    required this.maxDistance,
    required this.stateOfPurchase,
    required this.lga,
    required this.vendorsCanSeeBidFromAnyDistance,
    required this.deliveryType,
    required this.deliveryAddress,
    required this.deliveryState,
    required this.deliveryLga,
    required this.maxBidAmount,
    required this.bidStartingAmount,
  });

  factory CreateBuyerRequest.fromJson(Map<String, dynamic> json) => _$CreateBuyerRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final result = _$CreateBuyerRequestToJson(this);
    result.removeWhere((key, value) => value == null);
    return result;
  }
}
