import 'dart:convert';
/// id : "1cc4e226-fc91-457d-a992-552ca7955a87"
/// hashtag : "#trend"
/// isDeleted : false
/// isActive : true
/// ProfileId : null
/// _v : "RGBA"
/// createdBy : "@Arowolo"
/// createdAt : "2022-11-16T09:29:15.309Z"
/// updatedAt : "2022-11-16T09:29:15.309Z"
/// PostToHashtags : [{"id":"3e4cbdf8-e855-44f2-9457-6ee14b8e0a04","HashtagId":"1cc4e226-fc91-457d-a992-552ca7955a87","PostId":"f7b30719-b645-4ce7-95a4-177b9795d34c","isDeleted":false,"_v":"RGBA","ProfileId":"bc63e326-7619-45da-9aab-0876d5e96956","createdAt":"2022-11-16T09:29:15.318Z","updatedAt":"2022-11-16T09:29:15.318Z","Post":{"id":"f7b30719-b645-4ce7-95a4-177b9795d34c","description":"#trend Hi Everyone","type":"user","kind":null,"ProfileId":"bc63e326-7619-45da-9aab-0876d5e96956","GroupId":null,"PageId":null,"isDeleted":false,"isPoll":false,"isPromoted":false,"isPaid":false,"viewsCount":"0","likeCount":"0","unLikeCount":"0","shareCount":"0","commentCount":"0","repostCount":"0","repostedPost":false,"isRepostWithComment":false,"OriginalPostId":null,"ReposterProfileId":null,"repostCommentDesc":"","millisecCreatedAt":"1668077974086","millisecUpdatedAt":"1668077974086","_v":"RG","createdAt":"2022-11-16T09:29:15.293Z","updatedAt":"2022-11-16T09:29:15.293Z"}},{"id":"1d44da6b-4540-4499-8b50-95c6db29c5f9","HashtagId":"1cc4e226-fc91-457d-a992-552ca7955a87","PostId":"8034ab92-e3a2-4733-b1ec-233541e6a7ce","isDeleted":false,"_v":"RGBA","ProfileId":"bc63e326-7619-45da-9aab-0876d5e96956","createdAt":"2022-11-16T09:29:43.208Z","updatedAt":"2022-11-16T09:29:43.208Z","Post":{"id":"8034ab92-e3a2-4733-b1ec-233541e6a7ce","description":"#trend Welcome to wayagram","type":"user","kind":null,"ProfileId":"bc63e326-7619-45da-9aab-0876d5e96956","GroupId":null,"PageId":null,"isDeleted":false,"isPoll":false,"isPromoted":false,"isPaid":false,"viewsCount":"1","likeCount":"0","unLikeCount":"0","shareCount":"0","commentCount":"0","repostCount":"0","repostedPost":false,"isRepostWithComment":false,"OriginalPostId":null,"ReposterProfileId":null,"repostCommentDesc":"","millisecCreatedAt":"1668077974086","millisecUpdatedAt":"1668077974086","_v":"RG","createdAt":"2022-11-16T09:29:43.192Z","updatedAt":"2022-11-16T09:29:46.897Z"}}]

SearchHashtagsModel searchHashtagsModelFromJson(String str) => SearchHashtagsModel.fromJson(json.decode(str));
String searchHashtagsModelToJson(SearchHashtagsModel data) => json.encode(data.toJson());
class SearchHashtagsModel {
  SearchHashtagsModel({
      String? id, 
      String? hashtag, 
      bool? isDeleted, 
      bool? isActive, 
      dynamic profileId, 
      String? v, 
      String? createdBy, 
      String? createdAt, 
      String? updatedAt, 
      List<PostToHashtags>? postToHashtags,}){
    _id = id;
    _hashtag = hashtag;
    _isDeleted = isDeleted;
    _isActive = isActive;
    _profileId = profileId;
    _v = v;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _postToHashtags = postToHashtags;
}

  SearchHashtagsModel.fromJson(dynamic json) {
    _id = json['id'];
    _hashtag = json['hashtag'];
    _isDeleted = json['isDeleted'];
    _isActive = json['isActive'];
    _profileId = json['ProfileId'];
    _v = json['_v'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['PostToHashtags'] != null) {
      _postToHashtags = [];
      json['PostToHashtags'].forEach((v) {
        _postToHashtags?.add(PostToHashtags.fromJson(v));
      });
    }
  }
  String? _id;
  String? _hashtag;
  bool? _isDeleted;
  bool? _isActive;
  dynamic _profileId;
  String? _v;
  String? _createdBy;
  String? _createdAt;
  String? _updatedAt;
  List<PostToHashtags>? _postToHashtags;
SearchHashtagsModel copyWith({  String? id,
  String? hashtag,
  bool? isDeleted,
  bool? isActive,
  dynamic profileId,
  String? v,
  String? createdBy,
  String? createdAt,
  String? updatedAt,
  List<PostToHashtags>? postToHashtags,
}) => SearchHashtagsModel(  id: id ?? _id,
  hashtag: hashtag ?? _hashtag,
  isDeleted: isDeleted ?? _isDeleted,
  isActive: isActive ?? _isActive,
  profileId: profileId ?? _profileId,
  v: v ?? _v,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  postToHashtags: postToHashtags ?? _postToHashtags,
);
  String? get id => _id;
  String? get hashtag => _hashtag;
  bool? get isDeleted => _isDeleted;
  bool? get isActive => _isActive;
  dynamic get profileId => _profileId;
  String? get v => _v;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<PostToHashtags>? get postToHashtags => _postToHashtags;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['hashtag'] = _hashtag;
    map['isDeleted'] = _isDeleted;
    map['isActive'] = _isActive;
    map['ProfileId'] = _profileId;
    map['_v'] = _v;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_postToHashtags != null) {
      map['PostToHashtags'] = _postToHashtags?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  static List<SearchHashtagsModel> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => SearchHashtagsModel.fromJson(item)).toList();
  }
}

/// id : "3e4cbdf8-e855-44f2-9457-6ee14b8e0a04"
/// HashtagId : "1cc4e226-fc91-457d-a992-552ca7955a87"
/// PostId : "f7b30719-b645-4ce7-95a4-177b9795d34c"
/// isDeleted : false
/// _v : "RGBA"
/// ProfileId : "bc63e326-7619-45da-9aab-0876d5e96956"
/// createdAt : "2022-11-16T09:29:15.318Z"
/// updatedAt : "2022-11-16T09:29:15.318Z"
/// Post : {"id":"f7b30719-b645-4ce7-95a4-177b9795d34c","description":"#trend Hi Everyone","type":"user","kind":null,"ProfileId":"bc63e326-7619-45da-9aab-0876d5e96956","GroupId":null,"PageId":null,"isDeleted":false,"isPoll":false,"isPromoted":false,"isPaid":false,"viewsCount":"0","likeCount":"0","unLikeCount":"0","shareCount":"0","commentCount":"0","repostCount":"0","repostedPost":false,"isRepostWithComment":false,"OriginalPostId":null,"ReposterProfileId":null,"repostCommentDesc":"","millisecCreatedAt":"1668077974086","millisecUpdatedAt":"1668077974086","_v":"RG","createdAt":"2022-11-16T09:29:15.293Z","updatedAt":"2022-11-16T09:29:15.293Z"}

PostToHashtags postToHashtagsFromJson(String str) => PostToHashtags.fromJson(json.decode(str));
String postToHashtagsToJson(PostToHashtags data) => json.encode(data.toJson());
class PostToHashtags {
  PostToHashtags({
      String? id, 
      String? hashtagId, 
      String? postId, 
      bool? isDeleted, 
      String? v, 
      String? profileId, 
      String? createdAt, 
      String? updatedAt, 
      Post? post,}){
    _id = id;
    _hashtagId = hashtagId;
    _postId = postId;
    _isDeleted = isDeleted;
    _v = v;
    _profileId = profileId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _post = post;
}

  PostToHashtags.fromJson(dynamic json) {
    _id = json['id'];
    _hashtagId = json['HashtagId'];
    _postId = json['PostId'];
    _isDeleted = json['isDeleted'];
    _v = json['_v'];
    _profileId = json['ProfileId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _post = json['Post'] != null ? Post.fromJson(json['Post']) : null;
  }
  String? _id;
  String? _hashtagId;
  String? _postId;
  bool? _isDeleted;
  String? _v;
  String? _profileId;
  String? _createdAt;
  String? _updatedAt;
  Post? _post;
PostToHashtags copyWith({  String? id,
  String? hashtagId,
  String? postId,
  bool? isDeleted,
  String? v,
  String? profileId,
  String? createdAt,
  String? updatedAt,
  Post? post,
}) => PostToHashtags(  id: id ?? _id,
  hashtagId: hashtagId ?? _hashtagId,
  postId: postId ?? _postId,
  isDeleted: isDeleted ?? _isDeleted,
  v: v ?? _v,
  profileId: profileId ?? _profileId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  post: post ?? _post,
);
  String? get id => _id;
  String? get hashtagId => _hashtagId;
  String? get postId => _postId;
  bool? get isDeleted => _isDeleted;
  String? get v => _v;
  String? get profileId => _profileId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Post? get post => _post;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['HashtagId'] = _hashtagId;
    map['PostId'] = _postId;
    map['isDeleted'] = _isDeleted;
    map['_v'] = _v;
    map['ProfileId'] = _profileId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_post != null) {
      map['Post'] = _post?.toJson();
    }
    return map;
  }

}

/// id : "f7b30719-b645-4ce7-95a4-177b9795d34c"
/// description : "#trend Hi Everyone"
/// type : "user"
/// kind : null
/// ProfileId : "bc63e326-7619-45da-9aab-0876d5e96956"
/// GroupId : null
/// PageId : null
/// isDeleted : false
/// isPoll : false
/// isPromoted : false
/// isPaid : false
/// viewsCount : "0"
/// likeCount : "0"
/// unLikeCount : "0"
/// shareCount : "0"
/// commentCount : "0"
/// repostCount : "0"
/// repostedPost : false
/// isRepostWithComment : false
/// OriginalPostId : null
/// ReposterProfileId : null
/// repostCommentDesc : ""
/// millisecCreatedAt : "1668077974086"
/// millisecUpdatedAt : "1668077974086"
/// _v : "RG"
/// createdAt : "2022-11-16T09:29:15.293Z"
/// updatedAt : "2022-11-16T09:29:15.293Z"

Post postFromJson(String str) => Post.fromJson(json.decode(str));
String postToJson(Post data) => json.encode(data.toJson());
class Post {
  Post({
      String? id, 
      String? description, 
      String? type, 
      dynamic kind, 
      String? profileId, 
      dynamic groupId, 
      dynamic pageId, 
      bool? isDeleted, 
      bool? isPoll, 
      bool? isPromoted, 
      bool? isPaid, 
      String? viewsCount, 
      String? likeCount, 
      String? unLikeCount, 
      String? shareCount, 
      String? commentCount, 
      String? repostCount, 
      bool? repostedPost, 
      bool? isRepostWithComment, 
      dynamic originalPostId, 
      dynamic reposterProfileId, 
      String? repostCommentDesc, 
      String? millisecCreatedAt, 
      String? millisecUpdatedAt, 
      String? v, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _description = description;
    _type = type;
    _kind = kind;
    _profileId = profileId;
    _groupId = groupId;
    _pageId = pageId;
    _isDeleted = isDeleted;
    _isPoll = isPoll;
    _isPromoted = isPromoted;
    _isPaid = isPaid;
    _viewsCount = viewsCount;
    _likeCount = likeCount;
    _unLikeCount = unLikeCount;
    _shareCount = shareCount;
    _commentCount = commentCount;
    _repostCount = repostCount;
    _repostedPost = repostedPost;
    _isRepostWithComment = isRepostWithComment;
    _originalPostId = originalPostId;
    _reposterProfileId = reposterProfileId;
    _repostCommentDesc = repostCommentDesc;
    _millisecCreatedAt = millisecCreatedAt;
    _millisecUpdatedAt = millisecUpdatedAt;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Post.fromJson(dynamic json) {
    _id = json['id'];
    _description = json['description'];
    _type = json['type'];
    _kind = json['kind'];
    _profileId = json['ProfileId'];
    _groupId = json['GroupId'];
    _pageId = json['PageId'];
    _isDeleted = json['isDeleted'];
    _isPoll = json['isPoll'];
    _isPromoted = json['isPromoted'];
    _isPaid = json['isPaid'];
    _viewsCount = json['viewsCount'];
    _likeCount = json['likeCount'];
    _unLikeCount = json['unLikeCount'];
    _shareCount = json['shareCount'];
    _commentCount = json['commentCount'];
    _repostCount = json['repostCount'];
    _repostedPost = json['repostedPost'];
    _isRepostWithComment = json['isRepostWithComment'];
    _originalPostId = json['OriginalPostId'];
    _reposterProfileId = json['ReposterProfileId'];
    _repostCommentDesc = json['repostCommentDesc'];
    _millisecCreatedAt = json['millisecCreatedAt'];
    _millisecUpdatedAt = json['millisecUpdatedAt'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _description;
  String? _type;
  dynamic _kind;
  String? _profileId;
  dynamic _groupId;
  dynamic _pageId;
  bool? _isDeleted;
  bool? _isPoll;
  bool? _isPromoted;
  bool? _isPaid;
  String? _viewsCount;
  String? _likeCount;
  String? _unLikeCount;
  String? _shareCount;
  String? _commentCount;
  String? _repostCount;
  bool? _repostedPost;
  bool? _isRepostWithComment;
  dynamic _originalPostId;
  dynamic _reposterProfileId;
  String? _repostCommentDesc;
  String? _millisecCreatedAt;
  String? _millisecUpdatedAt;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
Post copyWith({  String? id,
  String? description,
  String? type,
  dynamic kind,
  String? profileId,
  dynamic groupId,
  dynamic pageId,
  bool? isDeleted,
  bool? isPoll,
  bool? isPromoted,
  bool? isPaid,
  String? viewsCount,
  String? likeCount,
  String? unLikeCount,
  String? shareCount,
  String? commentCount,
  String? repostCount,
  bool? repostedPost,
  bool? isRepostWithComment,
  dynamic originalPostId,
  dynamic reposterProfileId,
  String? repostCommentDesc,
  String? millisecCreatedAt,
  String? millisecUpdatedAt,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => Post(  id: id ?? _id,
  description: description ?? _description,
  type: type ?? _type,
  kind: kind ?? _kind,
  profileId: profileId ?? _profileId,
  groupId: groupId ?? _groupId,
  pageId: pageId ?? _pageId,
  isDeleted: isDeleted ?? _isDeleted,
  isPoll: isPoll ?? _isPoll,
  isPromoted: isPromoted ?? _isPromoted,
  isPaid: isPaid ?? _isPaid,
  viewsCount: viewsCount ?? _viewsCount,
  likeCount: likeCount ?? _likeCount,
  unLikeCount: unLikeCount ?? _unLikeCount,
  shareCount: shareCount ?? _shareCount,
  commentCount: commentCount ?? _commentCount,
  repostCount: repostCount ?? _repostCount,
  repostedPost: repostedPost ?? _repostedPost,
  isRepostWithComment: isRepostWithComment ?? _isRepostWithComment,
  originalPostId: originalPostId ?? _originalPostId,
  reposterProfileId: reposterProfileId ?? _reposterProfileId,
  repostCommentDesc: repostCommentDesc ?? _repostCommentDesc,
  millisecCreatedAt: millisecCreatedAt ?? _millisecCreatedAt,
  millisecUpdatedAt: millisecUpdatedAt ?? _millisecUpdatedAt,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get description => _description;
  String? get type => _type;
  dynamic get kind => _kind;
  String? get profileId => _profileId;
  dynamic get groupId => _groupId;
  dynamic get pageId => _pageId;
  bool? get isDeleted => _isDeleted;
  bool? get isPoll => _isPoll;
  bool? get isPromoted => _isPromoted;
  bool? get isPaid => _isPaid;
  String? get viewsCount => _viewsCount;
  String? get likeCount => _likeCount;
  String? get unLikeCount => _unLikeCount;
  String? get shareCount => _shareCount;
  String? get commentCount => _commentCount;
  String? get repostCount => _repostCount;
  bool? get repostedPost => _repostedPost;
  bool? get isRepostWithComment => _isRepostWithComment;
  dynamic get originalPostId => _originalPostId;
  dynamic get reposterProfileId => _reposterProfileId;
  String? get repostCommentDesc => _repostCommentDesc;
  String? get millisecCreatedAt => _millisecCreatedAt;
  String? get millisecUpdatedAt => _millisecUpdatedAt;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['description'] = _description;
    map['type'] = _type;
    map['kind'] = _kind;
    map['ProfileId'] = _profileId;
    map['GroupId'] = _groupId;
    map['PageId'] = _pageId;
    map['isDeleted'] = _isDeleted;
    map['isPoll'] = _isPoll;
    map['isPromoted'] = _isPromoted;
    map['isPaid'] = _isPaid;
    map['viewsCount'] = _viewsCount;
    map['likeCount'] = _likeCount;
    map['unLikeCount'] = _unLikeCount;
    map['shareCount'] = _shareCount;
    map['commentCount'] = _commentCount;
    map['repostCount'] = _repostCount;
    map['repostedPost'] = _repostedPost;
    map['isRepostWithComment'] = _isRepostWithComment;
    map['OriginalPostId'] = _originalPostId;
    map['ReposterProfileId'] = _reposterProfileId;
    map['repostCommentDesc'] = _repostCommentDesc;
    map['millisecCreatedAt'] = _millisecCreatedAt;
    map['millisecUpdatedAt'] = _millisecUpdatedAt;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}