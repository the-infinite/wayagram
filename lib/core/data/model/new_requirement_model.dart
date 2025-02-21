import 'package:json_annotation/json_annotation.dart';
part 'new_requirement_model.g.dart';

@JsonSerializable()
class NewRequirementModel {
  final int? id;
  final String? requirementType;
  final String? requirementName;
  final String? requirementOptional;
  final bool? isRequired;

  NewRequirementModel({
    this.id = 0,
    this.requirementType = "",
    this.requirementName = "",
    this.requirementOptional = "",
    this.isRequired = false,
  });

  factory NewRequirementModel.fromJson(Map<String, dynamic> json) =>
      _$NewRequirementModelFromJson(json);

  Map<String, dynamic> toJson() {
    return _$NewRequirementModelToJson(this);
  }
}
