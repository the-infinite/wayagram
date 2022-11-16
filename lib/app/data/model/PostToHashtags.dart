class PostToHashtags {
  PostToHashtags({
      this.id, 
      this.hashtagId, 
      this.postId, 
      this.isDeleted, 
      this.v, 
      this.profileId, 
      this.createdAt, 
      this.updatedAt,});

  PostToHashtags.fromJson(dynamic json) {
    id = json['id'];
    hashtagId = json['HashtagId'];
    postId = json['PostId'];
    isDeleted = json['isDeleted'];
    v = json['_v'];
    profileId = json['ProfileId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? hashtagId;
  String? postId;
  bool? isDeleted;
  String? v;
  String? profileId;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['HashtagId'] = hashtagId;
    map['PostId'] = postId;
    map['isDeleted'] = isDeleted;
    map['_v'] = v;
    map['ProfileId'] = profileId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}