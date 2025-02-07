import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

@JsonSerializable()
class UpdateProfileDto {
  final String? username;
  final String? displayName;
  final String? bio;
  final bool? isPublic;

  UpdateProfileDto({
    this.username,
    this.displayName,
    this.bio,
    this.isPublic,
  });

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) => _$UpdateProfileDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateProfileDtoToJson(this);
}
