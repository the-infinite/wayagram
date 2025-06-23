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

enum QuotationOrderStatus {
  @JsonValue('in-progress')
  inProgress._('in-progress'),

  @JsonValue('delivered')
  completed._('delivered'),

  @JsonValue('cancelled')
  failed._('cancelled');

  final String value;
  const QuotationOrderStatus._(this.value);
}

enum QuotationDeliveryStatus {
  pending._('pending'),
  processing._('processing'),

  @JsonValue('ready-for-dispatch')
  readyForDispatch._('ready-for-dispatch'),

  @JsonValue('in-transit')
  inTransit._('in-transit'),

  @JsonValue('out-for-delivery')
  outForDelivery._('out-for-delivery'),

  delivered._('delivered');

  final String value;
  const QuotationDeliveryStatus._(this.value);
}

enum QuotationPickupStatus {
  pending._('pending'),

  @JsonValue('ready-for-pickup')
  ready._('ready-for-pickup'),

  @JsonValue('pickup-scheduled')
  scheduled._('pickup-scheduled'),

  @JsonValue('pickup-completed')
  collected._('pickup-completed');

  final String value;
  const QuotationPickupStatus._(this.value);
}

@JsonSerializable()
class BuyRequestModel {
  final String id;
  final String buyerId;
  final String productName;
  final String? brand;
  final String category;
  final String condition;
  final String description;
  final int quantity;
  final DateTime bidStart;
  final DateTime bidEnd;
  final String deliveryDetails;
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

  QuotationBidModel? get acceptedBid => bids?.where((bid) => bid.status == BidActionType.accept).firstOrNull;

  bool get hasAcceptedBid => acceptedBid != null;

  String get fullname => '${brand?.isNotEmpty ?? false ? '${brand!.capitalize} ' : ''}${productName.capitalize}';

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

  double get amount => double.tryParse(bidAmount.replaceAll(",", "")) ?? 0.0;

  double? get counterValue => double.tryParse(counterAmount.toString().replaceAll(",", ""));

  double get usedAmount => counterValue ?? amount;

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

  const BidActionModel._({
    required this.bidId,
    required this.lastCounterSentBy,
    required this.action,
    required this.counterAmount,
  });

  /// Helper constructor used to create the bid action model for requests that
  /// are supposed to be used to accept a bid.
  factory BidActionModel.accept({
    required String bidId,
    required BidActionAuthor lastCounterSentBy,
  }) =>
      BidActionModel._(
        bidId: bidId,
        lastCounterSentBy: lastCounterSentBy,
        action: BidActionType.accept,
        counterAmount: null,
      );

  /// Helper constructor used to create the bid action model for rejecting bids
  /// by the buyer.
  factory BidActionModel.reject({
    required String bidId,
    required BidActionAuthor lastCounterSentBy,
  }) =>
      BidActionModel._(
        bidId: bidId,
        lastCounterSentBy: lastCounterSentBy,
        action: BidActionType.reject,
        counterAmount: null,
      );

  /// Helper constructor used to create the bid action that is used for initiating
  /// a negotiation. It can be done by either the buyer or the seller. All is fair
  /// in purchase and bargaining.
  factory BidActionModel.negotiate({
    required String bidId,
    required BidActionAuthor lastCounterSentBy,
    required String counterAmount,
  }) =>
      BidActionModel._(
        bidId: bidId,
        lastCounterSentBy: lastCounterSentBy,
        action: BidActionType.negotiate,
        counterAmount: counterAmount,
      );

  Map<String, dynamic> toJson() {
    final result = _$BidActionModelToJson(this);
    result.removeWhere((key, value) => value == null);
    return result;
  }
}

@JsonSerializable()
class BidOrderModel {
  final String id;
  final String buyerId;
  final String vendorId;
  final String shopId;
  final String bidId;
  final String requestId;
  final QuotationOrderStatus orderStatus;
  final String totalAmount;
  final String deliveryAddress;
  final bool isPaid;
  final String? token;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Construct.
  BidOrderModel({
    required this.id,
    required this.buyerId,
    required this.vendorId,
    required this.shopId,
    required this.bidId,
    required this.requestId,
    required this.orderStatus,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.isPaid,
    required this.token,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  double get amount => double.tryParse(totalAmount.replaceAll(",", "")) ?? 0.0;

  factory BidOrderModel.fromJson(Map<String, dynamic> json) => _$BidOrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$BidOrderModelToJson(this);
}
