import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/notifications/models/default.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponseModel {
  final List<NotificationModel> docs;
  final int page;
  final int limit;
  final int? nextPage;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int totalDocs;

  // Constructor.
  NotificationResponseModel({
    required this.docs,
    required this.page,
    required this.limit,
    required this.nextPage,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.totalDocs,
  });

  // This is fine then.
  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => _$NotificationResponseModelFromJson(json);

  // This is also fun.
  Map<String, dynamic> toJson() => _$NotificationResponseModelToJson(this);
}
