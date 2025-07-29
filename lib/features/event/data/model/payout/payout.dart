import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/event/data/model/payout/event_payout.dart';

part 'payout.g.dart';

@JsonSerializable()
class Payout {
  final String id;
  final String eventId;
  final String status;
  final String userId;
  final DateTime? settledAt;
  final int totalAmount;
  final int amountToBePaid;
  final int commission;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EventPayout eventPayouts;

  Payout({
    required this.id,
    required this.eventId,
    required this.status,
    required this.userId,
    this.settledAt,
    required this.totalAmount,
    required this.amountToBePaid,
    required this.commission,
    required this.createdAt,
    required this.updatedAt,
    required this.eventPayouts,
  });

  factory Payout.fromJson(Map<String, dynamic> json) => _$PayoutFromJson(json);
  Map<String, dynamic> toJson() => _$PayoutToJson(this);
}
