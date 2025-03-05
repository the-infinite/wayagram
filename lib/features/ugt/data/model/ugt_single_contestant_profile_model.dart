class SingleContestantPostsBase {
  String? message;
  bool? status;
  int? statusCode;
  Data? data;

  SingleContestantPostsBase(
      {this.message, this.status, this.statusCode, this.data});

  SingleContestantPostsBase.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<SingleContestantPosts>? docs;
  int? totalDocs;
  int? totalPages;
  int? currentPage;

  Data({this.docs, this.totalDocs, this.totalPages, this.currentPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      docs = <SingleContestantPosts>[];
      json['docs'].forEach((v) {
        docs!.add(SingleContestantPosts.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (docs != null) {
      data['docs'] = docs!.map((v) => v.toJson()).toList();
    }
    data['totalDocs'] = totalDocs;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    return data;
  }
}

class SingleContestantPosts {
  String? id;
  String? contestantProfileId;
  String? contestId;
  List<MediaContent>? mediaContent;
  String? description;
  int? likes;
  int? shares;
  bool? isDeleted;
  bool? isLiked;
  String? createdAt;
  String? updatedAt;

  SingleContestantPosts(
      {this.id,
      this.contestantProfileId,
      this.contestId,
      this.mediaContent,
      this.description,
      this.likes,
      this.shares,
      this.isLiked = false,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  SingleContestantPosts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contestantProfileId = json['contestantProfileId'];
    contestId = json['contestId'];
    if (json['mediaContent'] != null) {
      mediaContent = <MediaContent>[];
      json['mediaContent'].forEach((v) {
        mediaContent!.add(MediaContent.fromJson(v));
      });
    }
    description = json['description'];
    likes = json['likes'];
    shares = json['shares'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  SingleContestantPosts copyWith({
    String? id,
    String? contestantProfileId,
    String? contestId,
    List<MediaContent>? mediaContent,
    String? description,
    int? likes,
    int? shares,
    bool? isLiked,
    bool? isDeleted,
    String? createdAt,
    String? updatedAt,
  }) {
    return SingleContestantPosts(
      id: id ?? this.id,
      contestantProfileId: contestantProfileId ?? this.contestantProfileId,
      contestId: contestId ?? this.contestId,
      mediaContent: mediaContent ?? this.mediaContent,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      shares: shares ?? this.shares,
      isDeleted: isDeleted ?? isDeleted,
      createdAt: createdAt ?? createdAt,
      updatedAt: updatedAt ?? updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['contestantProfileId'] = contestantProfileId;
    data['contestId'] = contestId;
    if (mediaContent != null) {
      data['mediaContent'] = mediaContent!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    data['likes'] = likes;
    data['shares'] = shares;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class MediaContent {
  String? type;
  String? url;

  MediaContent({this.type, this.url});

  MediaContent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}
