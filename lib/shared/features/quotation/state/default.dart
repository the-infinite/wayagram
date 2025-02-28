import 'package:wayagram/shared/features/quotation/model/default.dart';

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
  final String? bidStatus;

  // For requests.
  final bool isLoadingRequests;
  final int requestPage;
  final int requestPages;
  final int totalRequests;
  final bool hasNextRequest;
  final List<BuyRequestModel> requests;
  final String? requestStatus;

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
    required this.bidStatus,
    required this.isLoadingRequests,
    required this.requestPage,
    required this.requestPages,
    required this.totalRequests,
    required this.hasNextRequest,
    required this.requests,
    required this.requestStatus,
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
    bidStatus: null,
    requestPage: 1,
    requestPages: 1,
    totalRequests: 0,
    hasNextRequest: false,
    requests: [],
    requestStatus: null,
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
    bidStatus: null,
    requestPage: 1,
    requestPages: 1,
    totalRequests: 0,
    hasNextRequest: false,
    requests: [],
    requestStatus: null,
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
    String? bidStatus,
    int? requestPage,
    int? requestPages,
    int? totalRequests,
    bool? hasNextRequest,
    List<BuyRequestModel>? requests,
    String? requestStatus,
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
      bidStatus: bidStatus ?? this.bidStatus,
      requestPage: requestPage ?? this.requestPage,
      requestPages: requestPages ?? this.requestPages,
      totalRequests: totalRequests ?? this.totalRequests,
      hasNextRequest: hasNextRequest ?? this.hasNextRequest,
      requests: requests ?? this.requests,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }
}
