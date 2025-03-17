class ShopMetricsResponse {
  final String message;
  final bool status;
  final int statusCode;
  final ShopMetricsData data;

  ShopMetricsResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory ShopMetricsResponse.fromJson(Map<String, dynamic> json) {
    return ShopMetricsResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: ShopMetricsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

class ShopMetricsData {
  final SalesMetrics completedSales;
  final OrderMetrics totalOrders;
  final ProductMetrics productMetrics;

  ShopMetricsData({
    required this.completedSales,
    required this.totalOrders,
    required this.productMetrics,
  });

  factory ShopMetricsData.fromJson(Map<String, dynamic> json) {
    return ShopMetricsData(
      completedSales: SalesMetrics.fromJson(json['completedSales']),
      totalOrders: OrderMetrics.fromJson(json['totalOrders']),
      productMetrics: ProductMetrics.fromJson(json['productMetrics']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedSales': completedSales.toJson(),
      'totalOrders': totalOrders.toJson(),
      'productMetrics': productMetrics.toJson(),
    };
  }
}

class SalesMetrics {
  final SaleDetails pickup;
  final SaleDetails delivered;
  final SaleDetails both;

  SalesMetrics({
    required this.pickup,
    required this.delivered,
    required this.both,
  });

  factory SalesMetrics.fromJson(Map<String, dynamic> json) {
    return SalesMetrics(
      pickup: SaleDetails.fromJson(json['pickup']),
      delivered: SaleDetails.fromJson(json['delivered']),
      both: SaleDetails.fromJson(json['both']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup': pickup.toJson(),
      'delivered': delivered.toJson(),
      'both': both.toJson(),
    };
  }
}

class SaleDetails {
  final int count;
  final int totalAmount;

  SaleDetails({
    required this.count,
    required this.totalAmount,
  });

  factory SaleDetails.fromJson(Map<String, dynamic> json) {
    return SaleDetails(
      count: json['count'],
      totalAmount: json['totalAmount']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'totalAmount': totalAmount,
    };
  }
}

class OrderMetrics {
  final SaleDetails pending;
  final SaleDetails processing;
  final SaleDetails completed;
  final SaleDetails cancelled;

  OrderMetrics({
    required this.pending,
    required this.processing,
    required this.completed,
    required this.cancelled,
  });

  factory OrderMetrics.fromJson(Map<String, dynamic> json) {
    return OrderMetrics(
      pending: SaleDetails.fromJson(json['pending']),
      processing: SaleDetails.fromJson(json['processing']),
      completed: SaleDetails.fromJson(json['completed']),
      cancelled: SaleDetails.fromJson(json['cancelled']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending': pending.toJson(),
      'processing': processing.toJson(),
      'completed': completed.toJson(),
      'cancelled': cancelled.toJson(),
    };
  }
}

class ProductMetrics {
  final int totalProducts;
  final int approvedProducts;
  final int unapprovedProducts;

  ProductMetrics({
    required this.totalProducts,
    required this.approvedProducts,
    required this.unapprovedProducts,
  });

  factory ProductMetrics.fromJson(Map<String, dynamic> json) {
    return ProductMetrics(
      totalProducts: json['totalProducts'],
      approvedProducts: json['approvedProducts'],
      unapprovedProducts: json['unapprovedProducts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalProducts': totalProducts,
      'approvedProducts': approvedProducts,
      'unapprovedProducts': unapprovedProducts,
    };
  }
}
