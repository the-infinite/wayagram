class InterestsModel {
  InterestsModel({
      this.id, 
      this.title,});

  InterestsModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
  }
  String? id;
  String? title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    return map;
  }

  static List<InterestsModel> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => InterestsModel.fromJson(item)).toList();
  }
}