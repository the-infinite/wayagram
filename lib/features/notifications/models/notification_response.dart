import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/notifications/models/default.dart';

//part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponseModel {
  final List<NotificationModel> notifications;
  final int total;
  final int limit;
  final int offset;

  // Constructor.
  NotificationResponseModel({
    required this.notifications,
    required this.total,
    required this.limit,
    required this.offset,
  });

  // This is fine then.
 // factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => _$NotificationResponseModelFromJson(json);

  // This is also fun.
  //Map<String, dynamic> toJson() => _$NotificationResponseModelToJson(this);
}
