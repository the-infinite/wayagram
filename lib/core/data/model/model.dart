

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Select {
  final String label;
  final String value;

  Select({required this.label, required this.value});

   factory Select.fromJson(Map<String, dynamic> json) =>
      _$SelectFromJson(json);

  Map<String, dynamic> toJson() {
    return _$SelectToJson(this);
  }
}