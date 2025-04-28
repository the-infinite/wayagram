import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';

part 'dto.g.dart';

enum WalletServiceType {
  @JsonValue("ECOMMERCE")
  shopping._("ECOMMERCE"),

  @JsonValue("CONTEST")
  ugt._("CONTEST"),

  @JsonValue("DONATION")
  donation._("DONATION"),

  @JsonValue("EVENT")
  event._("EVENT"),

  @JsonValue("POLL & VOTE")
  poll._("POLL & VOTE");

  final String name;
  const WalletServiceType._(this.name);
}

@JsonSerializable(createFactory: false)
class WalletPaymentData {
  final String recipientId;
  final String userId;
  final double amount;
  final WalletServiceType purpose;
  final String referenceId;
  final String description;
  final Map<String, dynamic>? metadata;

  // Construct.
  WalletPaymentData._({
    required this.recipientId,
    required this.userId,
    required this.amount,
    required this.purpose,
    required this.referenceId,
    required this.description,
    required this.metadata,
  });

  factory WalletPaymentData.build({
    required String recipientId,
    required double amount,
    required WalletServiceType purpose,
    required String description,
    required Map<String, dynamic>? metadata,
  }) =>
      WalletPaymentData._(
        recipientId: recipientId,
        userId: ConversationState.self.id,
        amount: amount,
        purpose: purpose,
        referenceId: WayaValueHelper.createUid(),
        description: description,
        metadata: metadata,
      );

  Map<String, dynamic> toJson() => _$WalletPaymentDataToJson(this);
}
