import 'package:json_annotation/json_annotation.dart';

part 'suggestion.g.dart';

@JsonSerializable()
class SuggestionModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  SuggestionModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullname => "$firstName $lastName";

  factory SuggestionModel.fromJson(Map<String, dynamic> json) => _$SuggestionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestionModelToJson(this);
}
