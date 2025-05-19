import 'package:json_annotation/json_annotation.dart';
part 'model.g.dart';

@JsonSerializable()
class Select {
  final String label;
  final String value;
  final String image;
  final int price;

  Select({required this.label, required this.value, this.image = '', this.price = 0});

  factory Select.fromJson(Map<String, dynamic> json) => _$SelectFromJson(json);

  Map<String, dynamic> toJson() {
    return _$SelectToJson(this);
  }
  @override
  String toString() {
    return "Select($label, $value, $image, $price)";
  }
}
