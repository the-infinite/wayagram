import 'package:wayagram/shared/features/quotation/model/default.dart';

class BidDashboardModel {
  final int opened;
  final int closed;
  final int won;

  // Construct.
  BidDashboardModel({
    required this.opened,
    required this.closed,
    required this.won,
  });

  /// Build the bid dashboard using JSON data.
  factory BidDashboardModel.fromJson(Map<String, dynamic> json) {
    return BidDashboardModel(
      opened: json["opened"],
      closed: json["closed"],
      won: json["won"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opened': opened,
      'closed': closed,
      'won': won,
    };
  }
}

class QuotationsState {
  final bool hasLoadedBids;
  final bool hasLoadedRequests;
  final int limit;
  final bool isUser;

  // For bids.
  final bool isLoadingBids;
  final int bidPage;
  final int bidPages;
  final int totalBids;
  final bool hasNextBid;
  final List<QuotationBidModel> bids;
  final List<BuyRequestModel> bidRequests;
  final String? bidStatus;
  final BidDashboardModel? overview;

  // For requests.
  final bool isLoadingRequests;
  final int requestPage;
  final int requestPages;
  final int totalRequests;
  final bool hasNextRequest;
  final List<BuyRequestModel> requests;
  final String? requestStatus;

  // For orders.
  final bool isLoadingOrders;
  final int orderPage;
  final int orderPages;
  final int totalOrders;
  final bool hasNextOrder;
  final List<BidOrderModel> orders;
  final String? orderStatus;

  // Construct.
  QuotationsState({
    required this.hasLoadedBids,
    required this.hasLoadedRequests,
    required this.limit,
    required this.isUser,
    required this.isLoadingBids,
    required this.bidPage,
    required this.bidPages,
    required this.totalBids,
    required this.hasNextBid,
    required this.bids,
    required this.bidRequests,
    required this.bidStatus,
    required this.isLoadingRequests,
    required this.requestPage,
    required this.requestPages,
    required this.totalRequests,
    required this.hasNextRequest,
    required this.requests,
    required this.requestStatus,
    required this.overview,
    required this.isLoadingOrders,
    required this.orderPage,
    required this.orderPages,
    required this.totalOrders,
    required this.hasNextOrder,
    required this.orders,
    required this.orderStatus,
  });

  static final self = QuotationsState(
    isUser: true,
    isLoadingBids: false,
    isLoadingRequests: false,
    hasLoadedBids: false,
    hasLoadedRequests: false,
    limit: 15,
    bidPage: 1,
    bidPages: 1,
    totalBids: 0,
    hasNextBid: false,
    bids: [],
    bidRequests: [],
    bidStatus: null,
    requestPage: 1,
    requestPages: 1,
    totalRequests: 0,
    hasNextRequest: false,
    requests: [],
    requestStatus: null,
    overview: null,
    isLoadingOrders: false,
    orderPage: 1,
    orderPages: 1,
    totalOrders: 0,
    hasNextOrder: false,
    orders: [],
    orderStatus: null,
  );

  static final others = QuotationsState(
    isUser: false,
    isLoadingBids: false,
    isLoadingRequests: false,
    hasLoadedBids: false,
    hasLoadedRequests: false,
    limit: 15,
    bidPage: 1,
    bidPages: 1,
    totalBids: 0,
    hasNextBid: false,
    bids: [],
    bidRequests: [],
    bidStatus: null,
    requestPage: 1,
    requestPages: 1,
    totalRequests: 0,
    hasNextRequest: false,
    requests: [],
    requestStatus: null,
    overview: null,
    isLoadingOrders: false,
    orderPage: 1,
    orderPages: 1,
    totalOrders: 0,
    hasNextOrder: false,
    orders: [],
    orderStatus: null,
  );

  QuotationsState copyWith({
    bool? isUser,
    bool? isLoadingBids,
    bool? isLoadingRequests,
    bool? hasLoadedBids,
    bool? hasLoadedRequests,
    int? limit,
    int? bidPage,
    int? bidPages,
    int? totalBids,
    bool? hasNextBid,
    List<QuotationBidModel>? bids,
    List<BuyRequestModel>? bidRequests,
    String? bidStatus,
    int? requestPage,
    int? requestPages,
    int? totalRequests,
    bool? hasNextRequest,
    List<BuyRequestModel>? requests,
    String? requestStatus,
    BidDashboardModel? overview,
    bool? isLoadingOrders,
    int? orderPage,
    int? orderPages,
    int? totalOrders,
    bool? hasNextOrder,
    List<BidOrderModel>? orders,
    String? orderStatus,
  }) {
    return QuotationsState(
      isLoadingBids: isLoadingBids ?? this.isLoadingBids,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      isUser: isUser ?? this.isUser,
      hasLoadedBids: hasLoadedBids ?? this.hasLoadedBids,
      hasLoadedRequests: hasLoadedRequests ?? this.hasLoadedRequests,
      limit: limit ?? this.limit,
      bidPage: bidPage ?? this.bidPage,
      bidPages: bidPages ?? this.bidPages,
      totalBids: totalBids ?? this.totalBids,
      hasNextBid: hasNextBid ?? this.hasNextBid,
      bids: bids ?? this.bids,
      bidRequests: bidRequests ?? this.bidRequests,
      bidStatus: bidStatus ?? this.bidStatus,
      requestPage: requestPage ?? this.requestPage,
      requestPages: requestPages ?? this.requestPages,
      totalRequests: totalRequests ?? this.totalRequests,
      hasNextRequest: hasNextRequest ?? this.hasNextRequest,
      requests: requests ?? this.requests,
      requestStatus: requestStatus ?? this.requestStatus,
      overview: overview ?? this.overview,
      isLoadingOrders: isLoadingOrders ?? this.isLoadingOrders,
      orderPage: orderPage ?? this.orderPage,
      orderPages: orderPages ?? this.orderPages,
      totalOrders: totalOrders ?? this.totalOrders,
      hasNextOrder: hasNextOrder ?? this.hasNextOrder,
      orders: orders ?? this.orders,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }
}
