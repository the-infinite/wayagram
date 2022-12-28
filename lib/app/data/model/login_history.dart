class LogInHistory {
  LogInHistory({
      this.id, 
      this.ip, 
      this.device, 
      this.city, 
      this.province, 
      this.country, 
      this.loginDate, 
      this.userId,});

  LogInHistory.fromJson(dynamic json) {
    id = json['id'];
    ip = json['ip'];
    device = json['device'];
    city = json['city'];
    province = json['province'];
    country = json['country'];
    loginDate = json['loginDate'];
    userId = json['userId'];
  }
  int? id;
  String? ip;
  String? device;
  String? city;
  String? province;
  String? country;
  int? loginDate;
  int? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['ip'] = ip;
    map['device'] = device;
    map['city'] = city;
    map['province'] = province;
    map['country'] = country;
    map['loginDate'] = loginDate;
    map['userId'] = userId;
    return map;
  }

  static List<LogInHistory> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => LogInHistory.fromJson(item)).toList();
  }

}