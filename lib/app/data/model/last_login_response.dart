import 'dart:convert';
/// id : 3124
/// ip : "102.89.44.81"
/// device : "Desktop"
/// city : "Lagos"
/// province : "Lagos"
/// country : "NG"
/// loginDate : 1672144435592
/// userId : 313

LastLoginResponse lastLoginResponseFromJson(String str) => LastLoginResponse.fromJson(json.decode(str));
String lastLoginResponseToJson(LastLoginResponse data) => json.encode(data.toJson());
class LastLoginResponse {
  LastLoginResponse({
      num? id, 
      String? ip, 
      String? device, 
      String? city, 
      String? province, 
      String? country, 
      num? loginDate, 
      num? userId,}){
    _id = id;
    _ip = ip;
    _device = device;
    _city = city;
    _province = province;
    _country = country;
    _loginDate = loginDate;
    _userId = userId;
}

  LastLoginResponse.fromJson(dynamic json) {
    _id = json['id'];
    _ip = json['ip'];
    _device = json['device'];
    _city = json['city'];
    _province = json['province'];
    _country = json['country'];
    _loginDate = json['loginDate'];
    _userId = json['userId'];
  }
  num? _id;
  String? _ip;
  String? _device;
  String? _city;
  String? _province;
  String? _country;
  num? _loginDate;
  num? _userId;
LastLoginResponse copyWith({  num? id,
  String? ip,
  String? device,
  String? city,
  String? province,
  String? country,
  num? loginDate,
  num? userId,
}) => LastLoginResponse(  id: id ?? _id,
  ip: ip ?? _ip,
  device: device ?? _device,
  city: city ?? _city,
  province: province ?? _province,
  country: country ?? _country,
  loginDate: loginDate ?? _loginDate,
  userId: userId ?? _userId,
);
  num? get id => _id;
  String? get ip => _ip;
  String? get device => _device;
  String? get city => _city;
  String? get province => _province;
  String? get country => _country;
  num? get loginDate => _loginDate;
  num? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ip'] = _ip;
    map['device'] = _device;
    map['city'] = _city;
    map['province'] = _province;
    map['country'] = _country;
    map['loginDate'] = _loginDate;
    map['userId'] = _userId;
    return map;
  }

  static List<LastLoginResponse> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => LastLoginResponse.fromJson(item)).toList();
  }
}