import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/account_model_entity.dart';

AccountModelEntity $AccountModelEntityFromJson(Map<String, dynamic> json) {
	final AccountModelEntity accountModelEntity = AccountModelEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		accountModelEntity.id = id;
	}
	final String? bankName = jsonConvert.convert<String>(json['bankName']);
	if (bankName != null) {
		accountModelEntity.bankName = bankName;
	}
	final String? bankCode = jsonConvert.convert<String>(json['bankCode']);
	if (bankCode != null) {
		accountModelEntity.bankCode = bankCode;
	}
	final String? accountNumber = jsonConvert.convert<String>(json['accountNumber']);
	if (accountNumber != null) {
		accountModelEntity.accountNumber = accountNumber;
	}
	final String? accountName = jsonConvert.convert<String>(json['accountName']);
	if (accountName != null) {
		accountModelEntity.accountName = accountName;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		accountModelEntity.userId = userId;
	}
	final bool? deleted = jsonConvert.convert<bool>(json['deleted']);
	if (deleted != null) {
		accountModelEntity.deleted = deleted;
	}
	return accountModelEntity;
}

Map<String, dynamic> $AccountModelEntityToJson(AccountModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['bankName'] = entity.bankName;
	data['bankCode'] = entity.bankCode;
	data['accountNumber'] = entity.accountNumber;
	data['accountName'] = entity.accountName;
	data['userId'] = entity.userId;
	data['deleted'] = entity.deleted;
	return data;
}