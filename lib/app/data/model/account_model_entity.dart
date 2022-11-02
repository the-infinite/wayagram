import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/account_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class AccountModelEntity {
	int? id;
	String? bankName;
	String? bankCode;
	String? accountNumber;
	String? accountName;
	String? userId;
	bool? deleted;
  
  AccountModelEntity();

  factory AccountModelEntity.fromJson(Map<String, dynamic> json) => $AccountModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $AccountModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}