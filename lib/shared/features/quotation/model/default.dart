import 'package:get/get_utils/get_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

enum BuyRequestStatus {
  @JsonValue('not-started')
  notStarted,

  @JsonValue('active')
  active,

  @JsonValue('cancelled')
  cancelled,

  @JsonValue('closed')
  closed,
}

enum BuyRequestDeliveryType {
  @JsonValue('pickup')
  pickup,

  @JsonValue('delivery')
  delivery,
}

enum BidActionType {
  @JsonValue("countered")
  negotiate,

  @JsonValue("accepted")
  accept,

  @JsonValue("rejected")
  reject,

  @JsonValue("pending")
  noop,
}

enum BidActionAuthor {
  buyer,
  vendor,
}

@JsonSerializable()
class BuyRequestModel {
  final String id;
  final String buyerId;
  final String productName;
  final String brand;
  final String category;
  final String condition;
  final String description;
  final int quantity;
  final DateTime bidStart;
  final DateTime bidEnd;
  final String deliveryDetails;
  final int minDistance;
  final int maxDistance;
  final String stateOfPurchase;
  final String lga;
  final bool vendorsCanSeeBidFromAnyDistance;
  final BuyRequestDeliveryType deliveryType;
  final String? deliveryAddress;
  final String? deliveryState;
  final String? deliveryLga;
  final double maxBidAmount;
  final double bidStartingAmount;
  final BuyRequestStatus status;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuotationBidModel>? bids;

  BuyRequestModel({
    required this.id,
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
    required this.maxBidAmount,
    required this.bidStartingAmount,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryAddress,
    this.deliveryState,
    this.deliveryLga,
    this.bids,
  });

  String get fullname => '${brand.isNotEmpty ? '${brand.capitalize} ' : ''}${productName.capitalize}';

  factory BuyRequestModel.fromJson(Map<String, dynamic> json) => _$BuyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuyRequestModelToJson(this);

  BuyRequestModel copyWith({
    String? id,
    String? buyerId,
    String? productName,
    String? brand,
    String? category,
    String? condition,
    String? description,
    int? quantity,
    DateTime? bidStart,
    DateTime? bidEnd,
    String? deliveryDetails,
    int? minDistance,
    int? maxDistance,
    String? stateOfPurchase,
    String? lga,
    bool? vendorsCanSeeBidFromAnyDistance,
    BuyRequestDeliveryType? deliveryType,
    String? deliveryAddress,
    String? deliveryState,
    String? deliveryLga,
    double? maxBidAmount,
    double? bidStartingAmount,
    BuyRequestStatus? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BuyRequestModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      bidStart: bidStart ?? this.bidStart,
      bidEnd: bidEnd ?? this.bidEnd,
      deliveryDetails: deliveryDetails ?? this.deliveryDetails,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      stateOfPurchase: stateOfPurchase ?? this.stateOfPurchase,
      lga: lga ?? this.lga,
      vendorsCanSeeBidFromAnyDistance: vendorsCanSeeBidFromAnyDistance ?? this.vendorsCanSeeBidFromAnyDistance,
      deliveryType: deliveryType ?? this.deliveryType,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryState: deliveryState ?? this.deliveryState,
      deliveryLga: deliveryLga ?? this.deliveryLga,
      maxBidAmount: maxBidAmount ?? this.maxBidAmount,
      bidStartingAmount: bidStartingAmount ?? this.bidStartingAmount,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class QuotationBidModel {
  final String id;
  final bool? isFinal;
  final BidActionType status;
  final BidActionAuthor lastCounterSentBy;
  final bool? isDeleted;
  final String requestId;
  final String vendorId;
  final String bidAmount;
  final String shopId;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String? counterAmount;

  QuotationBidModel({
    required this.id,
    required this.isFinal,
    required this.status,
    required this.lastCounterSentBy,
    required this.isDeleted,
    required this.requestId,
    required this.vendorId,
    required this.bidAmount,
    required this.shopId,
    required this.updatedAt,
    required this.createdAt,
    this.counterAmount,
  });

  factory QuotationBidModel.fromJson(Map<String, dynamic> json) => _$QuotationBidModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuotationBidModelToJson(this);
}

@JsonSerializable(createFactory: false)
class BidActionModel {
  final BidActionType action;
  final BidActionAuthor lastCounterSentBy;
  final String bidId;
  final String? counterAmount;

  /// Helper constructor used to create the bid action model for requests that
  /// are supposed to be used to accept a bid.
  const BidActionModel.accept({
    required this.bidId,
    required this.lastCounterSentBy,
    this.action = BidActionType.accept,
    this.counterAmount,
  });

  /// Helper constructor used to create the bid action model for rejecting bids
  /// by the buyer.
  const BidActionModel.reject({
    required this.bidId,
    required this.lastCounterSentBy,
    this.action = BidActionType.reject,
    this.counterAmount,
  });

  /// Helper constructor used to create the bid action that is used for initiating
  /// a negotiation. It can be done by either the buyer or the seller. All is fair
  /// in purchase and bargaining.
  const BidActionModel.negotiate({
    required this.bidId,
    required this.lastCounterSentBy,
    required this.counterAmount,
    this.action = BidActionType.negotiate,
  });

  Map<String, dynamic> toJson() {
    final result = _$BidActionModelToJson(this);
    result.removeWhere((key, value) => value == null);
    return result;
  }
}
