import 'dart:convert';
/// id : "cbce0e22-c39f-48e6-a79b-839de207db64"
/// fullName : ""
/// phoneNumber : "2349034724572"
/// active : true
/// userId : 313

SmsNotificationResponse smsNotificationResponseFromJson(String str) => SmsNotificationResponse.fromJson(json.decode(str));
String smsNotificationResponseToJson(SmsNotificationResponse data) => json.encode(data.toJson());
class SmsNotificationResponse {
  SmsNotificationResponse({
      String? id, 
      String? fullName, 
      String? phoneNumber, 
      bool? active, 
      num? userId,}){
    _id = id;
    _fullName = fullName;
    _phoneNumber = phoneNumber;
    _active = active;
    _userId = userId;
}

  SmsNotificationResponse.fromJson(dynamic json) {
    _id = json['id'];
    _fullName = json['fullName'];
    _phoneNumber = json['phoneNumber'];
    _active = json['active'];
    _userId = json['userId'];
  }
  String? _id;
  String? _fullName;
  String? _phoneNumber;
  bool? _active;
  num? _userId;
SmsNotificationResponse copyWith({  String? id,
  String? fullName,
  String? phoneNumber,
  bool? active,
  num? userId,
}) => SmsNotificationResponse(  id: id ?? _id,
  fullName: fullName ?? _fullName,
  phoneNumber: phoneNumber ?? _phoneNumber,
  active: active ?? _active,
  userId: userId ?? _userId,
);
  String? get id => _id;
  String? get fullName => _fullName;
  String? get phoneNumber => _phoneNumber;
  bool? get active => _active;
  num? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['fullName'] = _fullName;
    map['phoneNumber'] = _phoneNumber;
    map['active'] = _active;
    map['userId'] = _userId;
    return map;
  }

}