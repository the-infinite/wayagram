import 'package:json_annotation/json_annotation.dart';

part 'contest_vote_model.g.dart';

@JsonSerializable()
class ContestVoteModel {
  final String? contestId;
  final String? contestantId;
  final String? hostUserId;
  final String? amount;
  final String? numberOfVotes;
  final String? profileId;
  final String? type;

  ContestVoteModel({
    this.contestId,
    this.contestantId,
    this.hostUserId,
    this.amount,
    this.numberOfVotes,
    this.profileId,
    this.type,
  });

  factory ContestVoteModel.fromJson(Map<String, dynamic> json) =>
      _$ContestVoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContestVoteModelToJson(this);
}
