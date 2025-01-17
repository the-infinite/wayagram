
import 'package:json_annotation/json_annotation.dart';

//part 'quotation_model.g.dart';

@JsonSerializable()
class CreateBuyerRequest {
  final String buyerId;
  final String productName;
  final String brand;
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
  final String deliveryAddress;
  final String deliveryState;
  final String deliveryLga;
  final String maxBidAmount;
  final String bidStartingAmount;

  CreateBuyerRequest(
      this.buyerId,
      this.productName,
      this.brand,
      this.category,
      this.condition,
      this.description,
      this.quantity,
      this.bidStart,
      this.bidEnd,
      this.deliveryDetails,
      this.minDistance,
      this.maxDistance,
      this.stateOfPurchase,
      this.lga,
      this.vendorsCanSeeBidFromAnyDistance,
      this.deliveryType,
      this.deliveryAddress,
      this.deliveryState,
      this.deliveryLga,
      this.maxBidAmount,
      this.bidStartingAmount);

 /* factory CreateBuyerRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBuyerRequestFromJson(json);

  Map<String, dynamic> toJson() {
    return _$CreateBuyerRequestToJson(this);
  }*/
}