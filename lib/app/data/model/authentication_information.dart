import 'dart:convert';
/// createdAt : "07-07-2022 08:31:33"
/// updatedAt : "28-11-2022 05:29:28"
/// createdBy : "anonymousUser"
/// modifiedBy : "cephasarowolo@gmail.com"
/// id : 639
/// email : "cephasarowolo@gmail.com"
/// phoneNumber : "2348116074308"
/// referenceCode : ""
/// firstName : "CEPHAS"
/// surname : "AROWOLO"
/// name : "CEPHAS AROWOLO"
/// phoneVerified : true
/// emailVerified : true
/// pinCreated : true
/// provider : "local"
/// regDeviceType : "browser"
/// regDevicePlatform : "browser"
/// regDeviceIP : "197.210.227.182"
/// accountStatus : 1
/// accountNonExpired : true
/// accountNonLocked : true
/// credentialsNonExpired : true
/// firstTimeLoginDate : {"nano":994134000,"year":2022,"monthValue":7,"dayOfMonth":7,"hour":8,"minute":32,"second":14,"dayOfWeek":"THURSDAY","dayOfYear":188,"month":"JULY","chronology":{"id":"ISO","calendarType":"iso8601"}}
/// encryptedPIN : "zCAU3G1lgVKW3IVUpiwVlw=="
/// lastTimePasswordUpdated : {"nano":521463000,"year":2022,"monthValue":7,"dayOfMonth":7,"hour":8,"minute":31,"second":33,"dayOfWeek":"THURSDAY","dayOfYear":188,"month":"JULY","chronology":{"id":"ISO","calendarType":"iso8601"}}
/// passwordNeverExpires : false
/// dateOfActivation : {"nano":119740000,"year":2022,"monthValue":7,"dayOfMonth":7,"hour":8,"minute":31,"second":48,"dayOfWeek":"THURSDAY","dayOfYear":188,"month":"JULY","chronology":{"id":"ISO","calendarType":"iso8601"}}
/// merchantId : "MER_4jNZN1657182693710kxFTb"
/// active : true
/// deleted : false
/// corporate : true
/// admin : false
/// welcomed : true
/// 2fa : true
/// simulated : false
/// firstTimeLogin : false

AuthenticationInformation authenticationInformationFromJson(String str) => AuthenticationInformation.fromJson(json.decode(str));
String authenticationInformationToJson(AuthenticationInformation data) => json.encode(data.toJson());
class AuthenticationInformation {
  AuthenticationInformation({
      String? createdAt, 
      String? updatedAt, 
      String? createdBy, 
      String? modifiedBy, 
      num? id, 
      String? email, 
      String? phoneNumber, 
      String? referenceCode, 
      String? firstName, 
      String? surname, 
      String? name, 
      bool? phoneVerified, 
      bool? emailVerified, 
      bool? pinCreated, 
      String? provider, 
      String? regDeviceType, 
      String? regDevicePlatform, 
      String? regDeviceIP, 
      num? accountStatus, 
      bool? accountNonExpired, 
      bool? accountNonLocked, 
      bool? credentialsNonExpired, 
      FirstTimeLoginDate? firstTimeLoginDate, 
      String? encryptedPIN, 
      LastTimePasswordUpdated? lastTimePasswordUpdated, 
      bool? passwordNeverExpires, 
      DateOfActivation? dateOfActivation, 
      String? merchantId, 
      bool? active, 
      bool? deleted, 
      bool? corporate, 
      bool? admin, 
      bool? welcomed, 
      bool? fa, 
      bool? simulated, 
      bool? firstTimeLogin,}){
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _createdBy = createdBy;
    _modifiedBy = modifiedBy;
    _id = id;
    _email = email;
    _phoneNumber = phoneNumber;
    _referenceCode = referenceCode;
    _firstName = firstName;
    _surname = surname;
    _name = name;
    _phoneVerified = phoneVerified;
    _emailVerified = emailVerified;
    _pinCreated = pinCreated;
    _provider = provider;
    _regDeviceType = regDeviceType;
    _regDevicePlatform = regDevicePlatform;
    _regDeviceIP = regDeviceIP;
    _accountStatus = accountStatus;
    _accountNonExpired = accountNonExpired;
    _accountNonLocked = accountNonLocked;
    _credentialsNonExpired = credentialsNonExpired;
    _firstTimeLoginDate = firstTimeLoginDate;
    _encryptedPIN = encryptedPIN;
    _lastTimePasswordUpdated = lastTimePasswordUpdated;
    _passwordNeverExpires = passwordNeverExpires;
    _dateOfActivation = dateOfActivation;
    _merchantId = merchantId;
    _active = active;
    _deleted = deleted;
    _corporate = corporate;
    _admin = admin;
    _welcomed = welcomed;
    _fa = fa;
    _simulated = simulated;
    _firstTimeLogin = firstTimeLogin;
}

  AuthenticationInformation.fromJson(dynamic json) {
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _createdBy = json['createdBy'];
    _modifiedBy = json['modifiedBy'];
    _id = json['id'];
    _email = json['email'];
    _phoneNumber = json['phoneNumber'];
    _referenceCode = json['referenceCode'];
    _firstName = json['firstName'];
    _surname = json['surname'];
    _name = json['name'];
    _phoneVerified = json['phoneVerified'];
    _emailVerified = json['emailVerified'];
    _pinCreated = json['pinCreated'];
    _provider = json['provider'];
    _regDeviceType = json['regDeviceType'];
    _regDevicePlatform = json['regDevicePlatform'];
    _regDeviceIP = json['regDeviceIP'];
    _accountStatus = json['accountStatus'];
    _accountNonExpired = json['accountNonExpired'];
    _accountNonLocked = json['accountNonLocked'];
    _credentialsNonExpired = json['credentialsNonExpired'];
    _firstTimeLoginDate = json['firstTimeLoginDate'] != null ? FirstTimeLoginDate.fromJson(json['firstTimeLoginDate']) : null;
    _encryptedPIN = json['encryptedPIN'];
    _lastTimePasswordUpdated = json['lastTimePasswordUpdated'] != null ? LastTimePasswordUpdated.fromJson(json['lastTimePasswordUpdated']) : null;
    _passwordNeverExpires = json['passwordNeverExpires'];
    _dateOfActivation = json['dateOfActivation'] != null ? DateOfActivation.fromJson(json['dateOfActivation']) : null;
    _merchantId = json['merchantId'];
    _active = json['active'];
    _deleted = json['deleted'];
    _corporate = json['corporate'];
    _admin = json['admin'];
    _welcomed = json['welcomed'];
    _fa = json['2fa'];
    _simulated = json['simulated'];
    _firstTimeLogin = json['firstTimeLogin'];
  }
  String? _createdAt;
  String? _updatedAt;
  String? _createdBy;
  String? _modifiedBy;
  num? _id;
  String? _email;
  String? _phoneNumber;
  String? _referenceCode;
  String? _firstName;
  String? _surname;
  String? _name;
  bool? _phoneVerified;
  bool? _emailVerified;
  bool? _pinCreated;
  String? _provider;
  String? _regDeviceType;
  String? _regDevicePlatform;
  String? _regDeviceIP;
  num? _accountStatus;
  bool? _accountNonExpired;
  bool? _accountNonLocked;
  bool? _credentialsNonExpired;
  FirstTimeLoginDate? _firstTimeLoginDate;
  String? _encryptedPIN;
  LastTimePasswordUpdated? _lastTimePasswordUpdated;
  bool? _passwordNeverExpires;
  DateOfActivation? _dateOfActivation;
  String? _merchantId;
  bool? _active;
  bool? _deleted;
  bool? _corporate;
  bool? _admin;
  bool? _welcomed;
  bool? _fa;
  bool? _simulated;
  bool? _firstTimeLogin;
AuthenticationInformation copyWith({  String? createdAt,
  String? updatedAt,
  String? createdBy,
  String? modifiedBy,
  num? id,
  String? email,
  String? phoneNumber,
  String? referenceCode,
  String? firstName,
  String? surname,
  String? name,
  bool? phoneVerified,
  bool? emailVerified,
  bool? pinCreated,
  String? provider,
  String? regDeviceType,
  String? regDevicePlatform,
  String? regDeviceIP,
  num? accountStatus,
  bool? accountNonExpired,
  bool? accountNonLocked,
  bool? credentialsNonExpired,
  FirstTimeLoginDate? firstTimeLoginDate,
  String? encryptedPIN,
  LastTimePasswordUpdated? lastTimePasswordUpdated,
  bool? passwordNeverExpires,
  DateOfActivation? dateOfActivation,
  String? merchantId,
  bool? active,
  bool? deleted,
  bool? corporate,
  bool? admin,
  bool? welcomed,
  bool? fa,
  bool? simulated,
  bool? firstTimeLogin,
}) => AuthenticationInformation(  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  createdBy: createdBy ?? _createdBy,
  modifiedBy: modifiedBy ?? _modifiedBy,
  id: id ?? _id,
  email: email ?? _email,
  phoneNumber: phoneNumber ?? _phoneNumber,
  referenceCode: referenceCode ?? _referenceCode,
  firstName: firstName ?? _firstName,
  surname: surname ?? _surname,
  name: name ?? _name,
  phoneVerified: phoneVerified ?? _phoneVerified,
  emailVerified: emailVerified ?? _emailVerified,
  pinCreated: pinCreated ?? _pinCreated,
  provider: provider ?? _provider,
  regDeviceType: regDeviceType ?? _regDeviceType,
  regDevicePlatform: regDevicePlatform ?? _regDevicePlatform,
  regDeviceIP: regDeviceIP ?? _regDeviceIP,
  accountStatus: accountStatus ?? _accountStatus,
  accountNonExpired: accountNonExpired ?? _accountNonExpired,
  accountNonLocked: accountNonLocked ?? _accountNonLocked,
  credentialsNonExpired: credentialsNonExpired ?? _credentialsNonExpired,
  firstTimeLoginDate: firstTimeLoginDate ?? _firstTimeLoginDate,
  encryptedPIN: encryptedPIN ?? _encryptedPIN,
  lastTimePasswordUpdated: lastTimePasswordUpdated ?? _lastTimePasswordUpdated,
  passwordNeverExpires: passwordNeverExpires ?? _passwordNeverExpires,
  dateOfActivation: dateOfActivation ?? _dateOfActivation,
  merchantId: merchantId ?? _merchantId,
  active: active ?? _active,
  deleted: deleted ?? _deleted,
  corporate: corporate ?? _corporate,
  admin: admin ?? _admin,
  welcomed: welcomed ?? _welcomed,
  fa: fa ?? _fa,
  simulated: simulated ?? _simulated,
  firstTimeLogin: firstTimeLogin ?? _firstTimeLogin,
);
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get createdBy => _createdBy;
  String? get modifiedBy => _modifiedBy;
  num? get id => _id;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get referenceCode => _referenceCode;
  String? get firstName => _firstName;
  String? get surname => _surname;
  String? get name => _name;
  bool? get phoneVerified => _phoneVerified;
  bool? get emailVerified => _emailVerified;
  bool? get pinCreated => _pinCreated;
  String? get provider => _provider;
  String? get regDeviceType => _regDeviceType;
  String? get regDevicePlatform => _regDevicePlatform;
  String? get regDeviceIP => _regDeviceIP;
  num? get accountStatus => _accountStatus;
  bool? get accountNonExpired => _accountNonExpired;
  bool? get accountNonLocked => _accountNonLocked;
  bool? get credentialsNonExpired => _credentialsNonExpired;
  FirstTimeLoginDate? get firstTimeLoginDate => _firstTimeLoginDate;
  String? get encryptedPIN => _encryptedPIN;
  LastTimePasswordUpdated? get lastTimePasswordUpdated => _lastTimePasswordUpdated;
  bool? get passwordNeverExpires => _passwordNeverExpires;
  DateOfActivation? get dateOfActivation => _dateOfActivation;
  String? get merchantId => _merchantId;
  bool? get active => _active;
  bool? get deleted => _deleted;
  bool? get corporate => _corporate;
  bool? get admin => _admin;
  bool? get welcomed => _welcomed;
  bool? get fa => _fa;
  bool? get simulated => _simulated;
  bool? get firstTimeLogin => _firstTimeLogin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['createdBy'] = _createdBy;
    map['modifiedBy'] = _modifiedBy;
    map['id'] = _id;
    map['email'] = _email;
    map['phoneNumber'] = _phoneNumber;
    map['referenceCode'] = _referenceCode;
    map['firstName'] = _firstName;
    map['surname'] = _surname;
    map['name'] = _name;
    map['phoneVerified'] = _phoneVerified;
    map['emailVerified'] = _emailVerified;
    map['pinCreated'] = _pinCreated;
    map['provider'] = _provider;
    map['regDeviceType'] = _regDeviceType;
    map['regDevicePlatform'] = _regDevicePlatform;
    map['regDeviceIP'] = _regDeviceIP;
    map['accountStatus'] = _accountStatus;
    map['accountNonExpired'] = _accountNonExpired;
    map['accountNonLocked'] = _accountNonLocked;
    map['credentialsNonExpired'] = _credentialsNonExpired;
    if (_firstTimeLoginDate != null) {
      map['firstTimeLoginDate'] = _firstTimeLoginDate?.toJson();
    }
    map['encryptedPIN'] = _encryptedPIN;
    if (_lastTimePasswordUpdated != null) {
      map['lastTimePasswordUpdated'] = _lastTimePasswordUpdated?.toJson();
    }
    map['passwordNeverExpires'] = _passwordNeverExpires;
    if (_dateOfActivation != null) {
      map['dateOfActivation'] = _dateOfActivation?.toJson();
    }
    map['merchantId'] = _merchantId;
    map['active'] = _active;
    map['deleted'] = _deleted;
    map['corporate'] = _corporate;
    map['admin'] = _admin;
    map['welcomed'] = _welcomed;
    map['2fa'] = _fa;
    map['simulated'] = _simulated;
    map['firstTimeLogin'] = _firstTimeLogin;
    return map;
  }

}

/// nano : 119740000
/// year : 2022
/// monthValue : 7
/// dayOfMonth : 7
/// hour : 8
/// minute : 31
/// second : 48
/// dayOfWeek : "THURSDAY"
/// dayOfYear : 188
/// month : "JULY"
/// chronology : {"id":"ISO","calendarType":"iso8601"}

DateOfActivation dateOfActivationFromJson(String str) => DateOfActivation.fromJson(json.decode(str));
String dateOfActivationToJson(DateOfActivation data) => json.encode(data.toJson());
class DateOfActivation {
  DateOfActivation({
      num? nano, 
      num? year, 
      num? monthValue, 
      num? dayOfMonth, 
      num? hour, 
      num? minute, 
      num? second, 
      String? dayOfWeek, 
      num? dayOfYear, 
      String? month, 
      Chronology? chronology,}){
    _nano = nano;
    _year = year;
    _monthValue = monthValue;
    _dayOfMonth = dayOfMonth;
    _hour = hour;
    _minute = minute;
    _second = second;
    _dayOfWeek = dayOfWeek;
    _dayOfYear = dayOfYear;
    _month = month;
    _chronology = chronology;
}

  DateOfActivation.fromJson(dynamic json) {
    _nano = json['nano'];
    _year = json['year'];
    _monthValue = json['monthValue'];
    _dayOfMonth = json['dayOfMonth'];
    _hour = json['hour'];
    _minute = json['minute'];
    _second = json['second'];
    _dayOfWeek = json['dayOfWeek'];
    _dayOfYear = json['dayOfYear'];
    _month = json['month'];
    _chronology = json['chronology'] != null ? Chronology.fromJson(json['chronology']) : null;
  }
  num? _nano;
  num? _year;
  num? _monthValue;
  num? _dayOfMonth;
  num? _hour;
  num? _minute;
  num? _second;
  String? _dayOfWeek;
  num? _dayOfYear;
  String? _month;
  Chronology? _chronology;
DateOfActivation copyWith({  num? nano,
  num? year,
  num? monthValue,
  num? dayOfMonth,
  num? hour,
  num? minute,
  num? second,
  String? dayOfWeek,
  num? dayOfYear,
  String? month,
  Chronology? chronology,
}) => DateOfActivation(  nano: nano ?? _nano,
  year: year ?? _year,
  monthValue: monthValue ?? _monthValue,
  dayOfMonth: dayOfMonth ?? _dayOfMonth,
  hour: hour ?? _hour,
  minute: minute ?? _minute,
  second: second ?? _second,
  dayOfWeek: dayOfWeek ?? _dayOfWeek,
  dayOfYear: dayOfYear ?? _dayOfYear,
  month: month ?? _month,
  chronology: chronology ?? _chronology,
);
  num? get nano => _nano;
  num? get year => _year;
  num? get monthValue => _monthValue;
  num? get dayOfMonth => _dayOfMonth;
  num? get hour => _hour;
  num? get minute => _minute;
  num? get second => _second;
  String? get dayOfWeek => _dayOfWeek;
  num? get dayOfYear => _dayOfYear;
  String? get month => _month;
  Chronology? get chronology => _chronology;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nano'] = _nano;
    map['year'] = _year;
    map['monthValue'] = _monthValue;
    map['dayOfMonth'] = _dayOfMonth;
    map['hour'] = _hour;
    map['minute'] = _minute;
    map['second'] = _second;
    map['dayOfWeek'] = _dayOfWeek;
    map['dayOfYear'] = _dayOfYear;
    map['month'] = _month;
    if (_chronology != null) {
      map['chronology'] = _chronology?.toJson();
    }
    return map;
  }

}

/// id : "ISO"
/// calendarType : "iso8601"

Chronology chronologyFromJson(String str) => Chronology.fromJson(json.decode(str));
String chronologyToJson(Chronology data) => json.encode(data.toJson());
class Chronology {
  Chronology({
      String? id, 
      String? calendarType,}){
    _id = id;
    _calendarType = calendarType;
}

  Chronology.fromJson(dynamic json) {
    _id = json['id'];
    _calendarType = json['calendarType'];
  }
  String? _id;
  String? _calendarType;
Chronology copyWith({  String? id,
  String? calendarType,
}) => Chronology(  id: id ?? _id,
  calendarType: calendarType ?? _calendarType,
);
  String? get id => _id;
  String? get calendarType => _calendarType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['calendarType'] = _calendarType;
    return map;
  }

}

/// nano : 521463000
/// year : 2022
/// monthValue : 7
/// dayOfMonth : 7
/// hour : 8
/// minute : 31
/// second : 33
/// dayOfWeek : "THURSDAY"
/// dayOfYear : 188
/// month : "JULY"
/// chronology : {"id":"ISO","calendarType":"iso8601"}

LastTimePasswordUpdated lastTimePasswordUpdatedFromJson(String str) => LastTimePasswordUpdated.fromJson(json.decode(str));
String lastTimePasswordUpdatedToJson(LastTimePasswordUpdated data) => json.encode(data.toJson());
class LastTimePasswordUpdated {
  LastTimePasswordUpdated({
      num? nano, 
      num? year, 
      num? monthValue, 
      num? dayOfMonth, 
      num? hour, 
      num? minute, 
      num? second, 
      String? dayOfWeek, 
      num? dayOfYear, 
      String? month, 
      Chronology? chronology,}){
    _nano = nano;
    _year = year;
    _monthValue = monthValue;
    _dayOfMonth = dayOfMonth;
    _hour = hour;
    _minute = minute;
    _second = second;
    _dayOfWeek = dayOfWeek;
    _dayOfYear = dayOfYear;
    _month = month;
    _chronology = chronology;
}

  LastTimePasswordUpdated.fromJson(dynamic json) {
    _nano = json['nano'];
    _year = json['year'];
    _monthValue = json['monthValue'];
    _dayOfMonth = json['dayOfMonth'];
    _hour = json['hour'];
    _minute = json['minute'];
    _second = json['second'];
    _dayOfWeek = json['dayOfWeek'];
    _dayOfYear = json['dayOfYear'];
    _month = json['month'];
    _chronology = json['chronology'] != null ? Chronology.fromJson(json['chronology']) : null;
  }
  num? _nano;
  num? _year;
  num? _monthValue;
  num? _dayOfMonth;
  num? _hour;
  num? _minute;
  num? _second;
  String? _dayOfWeek;
  num? _dayOfYear;
  String? _month;
  Chronology? _chronology;
LastTimePasswordUpdated copyWith({  num? nano,
  num? year,
  num? monthValue,
  num? dayOfMonth,
  num? hour,
  num? minute,
  num? second,
  String? dayOfWeek,
  num? dayOfYear,
  String? month,
  Chronology? chronology,
}) => LastTimePasswordUpdated(  nano: nano ?? _nano,
  year: year ?? _year,
  monthValue: monthValue ?? _monthValue,
  dayOfMonth: dayOfMonth ?? _dayOfMonth,
  hour: hour ?? _hour,
  minute: minute ?? _minute,
  second: second ?? _second,
  dayOfWeek: dayOfWeek ?? _dayOfWeek,
  dayOfYear: dayOfYear ?? _dayOfYear,
  month: month ?? _month,
  chronology: chronology ?? _chronology,
);
  num? get nano => _nano;
  num? get year => _year;
  num? get monthValue => _monthValue;
  num? get dayOfMonth => _dayOfMonth;
  num? get hour => _hour;
  num? get minute => _minute;
  num? get second => _second;
  String? get dayOfWeek => _dayOfWeek;
  num? get dayOfYear => _dayOfYear;
  String? get month => _month;
  Chronology? get chronology => _chronology;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nano'] = _nano;
    map['year'] = _year;
    map['monthValue'] = _monthValue;
    map['dayOfMonth'] = _dayOfMonth;
    map['hour'] = _hour;
    map['minute'] = _minute;
    map['second'] = _second;
    map['dayOfWeek'] = _dayOfWeek;
    map['dayOfYear'] = _dayOfYear;
    map['month'] = _month;
    if (_chronology != null) {
      map['chronology'] = _chronology?.toJson();
    }
    return map;
  }

}

/// nano : 994134000
/// year : 2022
/// monthValue : 7
/// dayOfMonth : 7
/// hour : 8
/// minute : 32
/// second : 14
/// dayOfWeek : "THURSDAY"
/// dayOfYear : 188
/// month : "JULY"
/// chronology : {"id":"ISO","calendarType":"iso8601"}

FirstTimeLoginDate firstTimeLoginDateFromJson(String str) => FirstTimeLoginDate.fromJson(json.decode(str));
String firstTimeLoginDateToJson(FirstTimeLoginDate data) => json.encode(data.toJson());
class FirstTimeLoginDate {
  FirstTimeLoginDate({
      num? nano, 
      num? year, 
      num? monthValue, 
      num? dayOfMonth, 
      num? hour, 
      num? minute, 
      num? second, 
      String? dayOfWeek, 
      num? dayOfYear, 
      String? month, 
      Chronology? chronology,}){
    _nano = nano;
    _year = year;
    _monthValue = monthValue;
    _dayOfMonth = dayOfMonth;
    _hour = hour;
    _minute = minute;
    _second = second;
    _dayOfWeek = dayOfWeek;
    _dayOfYear = dayOfYear;
    _month = month;
    _chronology = chronology;
}

  FirstTimeLoginDate.fromJson(dynamic json) {
    _nano = json['nano'];
    _year = json['year'];
    _monthValue = json['monthValue'];
    _dayOfMonth = json['dayOfMonth'];
    _hour = json['hour'];
    _minute = json['minute'];
    _second = json['second'];
    _dayOfWeek = json['dayOfWeek'];
    _dayOfYear = json['dayOfYear'];
    _month = json['month'];
    _chronology = json['chronology'] != null ? Chronology.fromJson(json['chronology']) : null;
  }
  num? _nano;
  num? _year;
  num? _monthValue;
  num? _dayOfMonth;
  num? _hour;
  num? _minute;
  num? _second;
  String? _dayOfWeek;
  num? _dayOfYear;
  String? _month;
  Chronology? _chronology;
FirstTimeLoginDate copyWith({  num? nano,
  num? year,
  num? monthValue,
  num? dayOfMonth,
  num? hour,
  num? minute,
  num? second,
  String? dayOfWeek,
  num? dayOfYear,
  String? month,
  Chronology? chronology,
}) => FirstTimeLoginDate(  nano: nano ?? _nano,
  year: year ?? _year,
  monthValue: monthValue ?? _monthValue,
  dayOfMonth: dayOfMonth ?? _dayOfMonth,
  hour: hour ?? _hour,
  minute: minute ?? _minute,
  second: second ?? _second,
  dayOfWeek: dayOfWeek ?? _dayOfWeek,
  dayOfYear: dayOfYear ?? _dayOfYear,
  month: month ?? _month,
  chronology: chronology ?? _chronology,
);
  num? get nano => _nano;
  num? get year => _year;
  num? get monthValue => _monthValue;
  num? get dayOfMonth => _dayOfMonth;
  num? get hour => _hour;
  num? get minute => _minute;
  num? get second => _second;
  String? get dayOfWeek => _dayOfWeek;
  num? get dayOfYear => _dayOfYear;
  String? get month => _month;
  Chronology? get chronology => _chronology;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nano'] = _nano;
    map['year'] = _year;
    map['monthValue'] = _monthValue;
    map['dayOfMonth'] = _dayOfMonth;
    map['hour'] = _hour;
    map['minute'] = _minute;
    map['second'] = _second;
    map['dayOfWeek'] = _dayOfWeek;
    map['dayOfYear'] = _dayOfYear;
    map['month'] = _month;
    if (_chronology != null) {
      map['chronology'] = _chronology?.toJson();
    }
    return map;
  }
}