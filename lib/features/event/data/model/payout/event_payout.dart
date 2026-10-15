import 'package:json_annotation/json_annotation.dart';

part 'event_payout.g.dart';

@JsonSerializable()
class EventPayout {
  final String id;
  final String userId;
  final String image;
  final String title;
  final String organizerName;
  final String? description;
  final String location;
  final String locationAddress;
  final String startDate;
  final String endDate;
  final DateTime? ticketSalesStartDate;
  final DateTime? ticketSalesEndDate;
  final String startTime;
  final String endTime;
  final String payoutStatus;
  final String eventType;
  final String eventstatus;
  final String status;
  final int fee;
  final int totalRevenue;
  final int? maxCapacity;
  final int noOfAttendees;
  final String privacyOption;
  final String v;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventPayout({
    required this.id,
    required this.userId,
    required this.image,
    required this.title,
    required this.organizerName,
    this.description,
    required this.location,
    required this.locationAddress,
    required this.startDate,
    required this.endDate,
    this.ticketSalesStartDate,
    this.ticketSalesEndDate,
    required this.startTime,
    required this.endTime,
    required this.payoutStatus,
    required this.eventType,
    required this.eventstatus,
    required this.status,
    required this.fee,
    required this.totalRevenue,
    this.maxCapacity,
    required this.noOfAttendees,
    required this.privacyOption,
    required this.v,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventPayout.fromJson(Map<String, dynamic> json) =>
      _$EventPayoutFromJson(json);

  Map<String, dynamic> toJson() => _$EventPayoutToJson(this);
}
