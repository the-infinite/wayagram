import 'package:wayagram/features/event/data/model/payout/payout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/event/data/model/payout/meta_data.dart';
part 'payout_data.g.dart';

@JsonSerializable()
class PayoutData {
  final List<Payout> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;
  final Metadata metadata;

  PayoutData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    this.nextPage,
    required this.hasPrevPage,
    this.prevPage,
    required this.pagingCounter,
    required this.metadata,
  });

  factory PayoutData.fromJson(Map<String, dynamic> json) =>
      _$PayoutDataFromJson(json);
  Map<String, dynamic> toJson() => _$PayoutDataToJson(this);
}
