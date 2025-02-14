import 'package:json_annotation/json_annotation.dart';

part 'select_account_data.g.dart';

@JsonSerializable()
class SelectAccountData {
  final String avatar;
  final String title;
  final String description;
  final String type;
  final String id;

  SelectAccountData({
    required this.avatar,
    required this.description,
    required this.title,
    required this.type,
    required this.id,
  });

  Map<String, dynamic> toJson() => _$SelectAccountDataToJson(this);

  factory SelectAccountData.fromJson(Map<String, dynamic> json) => _$SelectAccountDataFromJson(json);
}

List<SelectAccountData> selectAccountData = [
  //?
  SelectAccountData(
    avatar: "assets/icons/personal.svg",
    description: "Create your personal account to get \n started with us",
    title: "Personal Account",
    type: "PERSONAL",
    id: "1",
  ),

  //?
  SelectAccountData(
    avatar: "assets/icons/business.svg",
    description: "Create a business account for \n your business",
    title: "Business Account",
    type: "BUSINESS",
    id: "2",
  )
];
