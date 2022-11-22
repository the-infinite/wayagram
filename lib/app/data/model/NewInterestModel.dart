class NewInterestModel {
  NewInterestModel({
      this.v, 
      this.id, 
      this.title, 
      this.description, 
      this.updatedAt, 
      this.createdAt,});

  NewInterestModel.fromJson(dynamic json) {
    v = json['_v'];
    id = json['id'];
    title = json['title'];
    description = json['description'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }
  String? v;
  String? id;
  String? title;
  String? description;
  String? updatedAt;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_v'] = v;
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['updatedAt'] = updatedAt;
    map['createdAt'] = createdAt;
    return map;
  }

  static List<NewInterestModel> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => NewInterestModel.fromJson(item)).toList();
  }
}