import 'PostToHashtags.dart';

class TrendingHashtagsModel {
  TrendingHashtagsModel({
      this.id, 
      this.hashtag, 
      this.isDeleted, 
      this.isActive, 
      this.profileId, 
      this.v, 
      this.createdBy, 
      this.createdAt, 
      this.updatedAt, 
      this.postToHashtags, 
      this.frequency,});

  TrendingHashtagsModel.fromJson(dynamic json) {
    id = json['id'];
    hashtag = json['hashtag'];
    isDeleted = json['isDeleted'];
    isActive = json['isActive'];
    profileId = json['ProfileId'];
    v = json['_v'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['PostToHashtags'] != null) {
      postToHashtags = [];
      json['PostToHashtags'].forEach((v) {
        postToHashtags?.add(PostToHashtags.fromJson(v));
      });
    }
    frequency = json['frequency'];
  }
  String? id;
  String? hashtag;
  bool? isDeleted;
  bool? isActive;
  dynamic profileId;
  String? v;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  List<PostToHashtags>? postToHashtags;
  int? frequency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['hashtag'] = hashtag;
    map['isDeleted'] = isDeleted;
    map['isActive'] = isActive;
    map['ProfileId'] = profileId;
    map['_v'] = v;
    map['createdBy'] = createdBy;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (postToHashtags != null) {
      map['PostToHashtags'] = postToHashtags?.map((v) => v.toJson()).toList();
    }
    map['frequency'] = frequency;
    return map;
  }

  static List<TrendingHashtagsModel> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => TrendingHashtagsModel.fromJson(item)).toList();
  }

}