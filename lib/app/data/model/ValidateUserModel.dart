import 'dart:convert';
/// id : "121"
/// email : "taiwodavid19@gmail.com"
/// phoneNumber : "2348111116818"
/// referenceCode : "HzlJNc7ldXirNyuB"
/// firstName : "DARE"
/// surname : "DARE"
/// phoneVerified : true
/// emailVerified : true
/// admin : false
/// pinCreated : true
/// roles : ["ROLE_USER_MERCHANT","ROLE_USER_OWNER"]
/// permits : ["APP_AGENT","CAN_MANAGE_KYC_CONFIGURATION","CAN_MANAGE_KYC"]
/// transactionLimit : "500000.00"
/// merchantId : "MER_h1cci1646118825168Nrcpn"
/// userLocation : "Lagos"
/// corporate : true

ValidateUserModel validateUserModelFromJson(String str) => ValidateUserModel.fromJson(json.decode(str));
String validateUserModelToJson(ValidateUserModel data) => json.encode(data.toJson());
class ValidateUserModel {
  ValidateUserModel({
      String? id, 
      String? email, 
      String? phoneNumber, 
      String? referenceCode, 
      String? firstName, 
      String? surname, 
      bool? phoneVerified, 
      bool? emailVerified, 
      bool? admin, 
      bool? pinCreated, 
      List<String>? roles, 
      List<String>? permits, 
      String? transactionLimit, 
      String? merchantId, 
      String? userLocation, 
      bool? corporate,}){
    _id = id;
    _email = email;
    _phoneNumber = phoneNumber;
    _referenceCode = referenceCode;
    _firstName = firstName;
    _surname = surname;
    _phoneVerified = phoneVerified;
    _emailVerified = emailVerified;
    _admin = admin;
    _pinCreated = pinCreated;
    _roles = roles;
    _permits = permits;
    _transactionLimit = transactionLimit;
    _merchantId = merchantId;
    _userLocation = userLocation;
    _corporate = corporate;
}

  ValidateUserModel.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _phoneNumber = json['phoneNumber'];
    _referenceCode = json['referenceCode'];
    _firstName = json['firstName'];
    _surname = json['surname'];
    _phoneVerified = json['phoneVerified'];
    _emailVerified = json['emailVerified'];
    _admin = json['admin'];
    _pinCreated = json['pinCreated'];
    _roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    _permits = json['permits'] != null ? json['permits'].cast<String>() : [];
    _transactionLimit = json['transactionLimit'];
    _merchantId = json['merchantId'];
    _userLocation = json['userLocation'];
    _corporate = json['corporate'];
  }
  String? _id;
  String? _email;
  String? _phoneNumber;
  String? _referenceCode;
  String? _firstName;
  String? _surname;
  bool? _phoneVerified;
  bool? _emailVerified;
  bool? _admin;
  bool? _pinCreated;
  List<String>? _roles;
  List<String>? _permits;
  String? _transactionLimit;
  String? _merchantId;
  String? _userLocation;
  bool? _corporate;
ValidateUserModel copyWith({  String? id,
  String? email,
  String? phoneNumber,
  String? referenceCode,
  String? firstName,
  String? surname,
  bool? phoneVerified,
  bool? emailVerified,
  bool? admin,
  bool? pinCreated,
  List<String>? roles,
  List<String>? permits,
  String? transactionLimit,
  String? merchantId,
  String? userLocation,
  bool? corporate,
}) => ValidateUserModel(  id: id ?? _id,
  email: email ?? _email,
  phoneNumber: phoneNumber ?? _phoneNumber,
  referenceCode: referenceCode ?? _referenceCode,
  firstName: firstName ?? _firstName,
  surname: surname ?? _surname,
  phoneVerified: phoneVerified ?? _phoneVerified,
  emailVerified: emailVerified ?? _emailVerified,
  admin: admin ?? _admin,
  pinCreated: pinCreated ?? _pinCreated,
  roles: roles ?? _roles,
  permits: permits ?? _permits,
  transactionLimit: transactionLimit ?? _transactionLimit,
  merchantId: merchantId ?? _merchantId,
  userLocation: userLocation ?? _userLocation,
  corporate: corporate ?? _corporate,
);
  String? get id => _id;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get referenceCode => _referenceCode;
  String? get firstName => _firstName;
  String? get surname => _surname;
  bool? get phoneVerified => _phoneVerified;
  bool? get emailVerified => _emailVerified;
  bool? get admin => _admin;
  bool? get pinCreated => _pinCreated;
  List<String>? get roles => _roles;
  List<String>? get permits => _permits;
  String? get transactionLimit => _transactionLimit;
  String? get merchantId => _merchantId;
  String? get userLocation => _userLocation;
  bool? get corporate => _corporate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['phoneNumber'] = _phoneNumber;
    map['referenceCode'] = _referenceCode;
    map['firstName'] = _firstName;
    map['surname'] = _surname;
    map['phoneVerified'] = _phoneVerified;
    map['emailVerified'] = _emailVerified;
    map['admin'] = _admin;
    map['pinCreated'] = _pinCreated;
    map['roles'] = _roles;
    map['permits'] = _permits;
    map['transactionLimit'] = _transactionLimit;
    map['merchantId'] = _merchantId;
    map['userLocation'] = _userLocation;
    map['corporate'] = _corporate;
    return map;
  }

}