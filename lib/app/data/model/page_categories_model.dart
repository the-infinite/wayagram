class PageCategoriesModel {
  String? id;
  String? title;
  String? description;
  String? v;
  String? createdAt;
  String? updatedAt;

  PageCategoriesModel({
      this.id, 
      this.title, 
      this.description, 
      this.v, 
      this.createdAt, 
      this.updatedAt,});

  PageCategoriesModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    v = json['_v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['_v'] = v;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

  static List<PageCategoriesModel> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => PageCategoriesModel.fromJson(item)).toList();
  }
}