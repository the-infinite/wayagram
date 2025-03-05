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
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
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
        docs!.add(new SingleContestantPosts.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docs != null) {
      data['docs'] = this.docs!.map((v) => v.toJson()).toList();
    }
    data['totalDocs'] = this.totalDocs;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
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
        mediaContent!.add(new MediaContent.fromJson(v));
      });
    }
    description = json['description'];
    likes = json['likes'];
    shares = json['shares'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contestantProfileId'] = this.contestantProfileId;
    data['contestId'] = this.contestId;
    if (this.mediaContent != null) {
      data['mediaContent'] = this.mediaContent!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['likes'] = this.likes;
    data['shares'] = this.shares;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}
