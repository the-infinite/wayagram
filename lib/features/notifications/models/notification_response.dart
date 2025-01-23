import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/shop/seller/data/model/pagination_model.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponseModel {
  final List<NotificationModel> data;
  final Pagination pagination;

  // Constructor.
  NotificationResponseModel({
    required this.data,
    required this.pagination,
  });

  // This is fine then.
  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => _$NotificationResponseModelFromJson(json);

  // This is also fun.
  Map<String, dynamic> toJson() => _$NotificationResponseModelToJson(this);
}
