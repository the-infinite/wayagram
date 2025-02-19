import 'package:json_annotation/json_annotation.dart';

part 'register_for_contest_model.g.dart';

@JsonSerializable()
class RegisterForContestModel {
  final String id;
  final String title;
  

  final bool isRequired;
  final bool isFile;

  RegisterForContestModel({
    required this.id,
    required this.title,
    required this.isRequired,
    required this.isFile,
  });

  factory RegisterForContestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterForContestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterForContestModelToJson(this);
}
