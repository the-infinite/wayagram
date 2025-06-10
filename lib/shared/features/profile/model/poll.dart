import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

part 'poll.g.dart';

@JsonSerializable()
class PollChoice {
  final String id;
  final String pollId;
  final String text;
  final String? description;
  final String? imageUrl;
  final int order;
  final int? voteCount;
  final int? uniqueVoters;
  final double? votePercentage;
  final double? uniqueVotersPercentage;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Construct.
  PollChoice({
    required this.id,
    required this.pollId,
    required this.text,
    required this.description,
    required this.imageUrl,
    required this.order,
    required this.voteCount,
    required this.uniqueVoters,
    required this.votePercentage,
    required this.uniqueVotersPercentage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PollChoice.fromJson(Map<String, dynamic> json) => _$PollChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$PollChoiceToJson(this);
}

@JsonSerializable()
class PollModel {
  final String id;
  final String creatorId;
  final int voteCount;
  final bool? isPaid;
  final bool? isSettled;
  final String question;
  final String? url;
  final int? maxVotesPerUser;
  final String pollType;
  final String? feePerVote;
  final List<PollChoice>? choices;
  final UserDetailsModel? userData;
  final List<dynamic>? categories;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime endDate;

  PollModel({
    required this.id,
    required this.creatorId,
    required this.voteCount,
    required this.isPaid,
    required this.isSettled,
    required this.question,
    required this.url,
    required this.maxVotesPerUser,
    required this.pollType,
    required this.feePerVote,
    required this.choices,
    required this.userData,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    required this.endDate,
  });

  int get engagementCount => voteCount;
  double? get earnings => feePerVote == null ? null : (double.tryParse(feePerVote.toString().replaceAll(",", "").replaceAll(".00", "")) ?? 0) * voteCount;

  factory PollModel.fromJson(Map<String, dynamic> json) => _$PollModelFromJson(json);

  Map<String, dynamic> toJson() => _$PollModelToJson(this);
}
