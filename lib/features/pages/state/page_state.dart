import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/pages/data/model/get_page_member_model.dart';
import 'package:wayagram/features/pages/data/model/page_follower_model.dart';
import 'package:wayagram/features/pages/data/model/page_invitation_model.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/model/media_upload_model.dart';

import '../../../core/data/model/model.dart';
import '../../post/model/share_model.dart';

class PageState {
  final TextEditingController pageName;
  final TextEditingController pageDescription;
  final TextEditingController content;
  final List<PostImage> images;
  final List<PostModel>? fetchAllPostData;
  final List<PostModel>? getAllPost;
  final List<GetAllPostDocs>? getAllPagePost;
  final List<CommentModel>? comments;
  final List<PageFollowerDocs>? pageFollowerDocs;
  List<PageInvitationModelDocs>? pageInvitationModelDocs;
  final num? postCount;
  final String category;
  final List<Select> categories;
  final GetAllPost? allPostData;
  List<PageModel>? recommendedPages;
  List<PageModel>? allPageModelDocs;
  List<GetPageMemberDocs>? getPageMemberDocs;
  List<PostModel>? pagePopularPostDocs;
  final MediaUploadData? data;
  List<dynamic>? docs;
  final ShareModelData? shareModelData;
  final TextEditingController username;
  final String? foundUserId;
  final String roleType;
  final bool isFocused;
  final bool isLoading;
  final bool isReportingPage;
  final bool isReportingPost;

  //? If this has more posts, continue.
  bool get hasMorePosts => allPostData?.data?.hasNextPage ?? true;

  PageState({
    TextEditingController? pageName,
    TextEditingController? pageDescription,
    TextEditingController? content,
    TextEditingController? username,
    this.roleType = '',
    this.foundUserId,
    this.isFocused = false,
    this.isLoading = false,
    this.isReportingPage = false,
    this.isReportingPost = false,
    this.postCount,
    this.images = const [],
    this.fetchAllPostData = const [],
    this.comments = const [],
    this.pageFollowerDocs = const [],
    this.pagePopularPostDocs = const [],
    this.pageInvitationModelDocs = const [],
    this.getAllPost = const [],
    this.docs = const [],
    this.category = '',
    this.categories = const [],
    this.allPageModelDocs = const [],
    this.getPageMemberDocs = const [],
    this.recommendedPages = const [],
    this.getAllPagePost = const [],
    this.data,
    this.allPostData,
    this.shareModelData,
  })  : username = username ?? TextEditingController(),
        pageName = pageName ?? TextEditingController(),
        pageDescription = pageDescription ?? TextEditingController(),
        content = content ?? TextEditingController();

  PageState copyWith({
    TextEditingController? pageName,
    TextEditingController? pageDescription,
    TextEditingController? content,
    TextEditingController? username,
    String? foundUserId,
    String? roleType,
    List<PageFollowerDocs>? pageFollowerDocs,
    List<PostImage>? images,
    List<GetAllPostDocs>? getAllPagePost,
    List<PostModel>? fetchAllPostData,
    List<PageInvitationModelDocs>? pageInvitationModelDocs,
    List<PostModel>? getAllPost,
    List<PageModel>? recommendedPages,
    List<PageModel>? allPageModelDocs,
    List<GetPageMemberDocs>? getPageMemberDocs,
    List<PostModel>? pagePopularPostDocs,
    List<CommentModel>? comments,
    List<Select>? categories,
    String? category,
    List<dynamic>? docs,
    MediaUploadData? data,
    num? postCount,
    ShareModelData? shareModelData,
    GetAllPost? allPostData,
    bool? isFocused,
    bool? isLoading,
    bool? isReportingPage,
    bool? isReportingPost,
  }) {
    return PageState(
      roleType: roleType ?? this.roleType,
      username: username ?? this.username,
      getAllPagePost: getAllPagePost ?? this.getAllPagePost,
      foundUserId: foundUserId ?? this.foundUserId,
      pageName: pageName ?? this.pageName,
      pageDescription: pageDescription ?? this.pageDescription,
      content: content ?? this.content,
      images: images ?? this.images,
      data: data ?? this.data,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      pageInvitationModelDocs: pageInvitationModelDocs ?? this.pageInvitationModelDocs,
      pageFollowerDocs: pageFollowerDocs ?? this.pageFollowerDocs,
      postCount: postCount ?? this.postCount,
      recommendedPages: recommendedPages ?? this.recommendedPages,
      shareModelData: shareModelData ?? this.shareModelData,
      fetchAllPostData: fetchAllPostData ?? this.fetchAllPostData,
      getAllPost: getAllPost ?? this.getAllPost,
      allPageModelDocs: allPageModelDocs ?? this.allPageModelDocs,
      comments: comments ?? this.comments,
      pagePopularPostDocs: pagePopularPostDocs ?? this.pagePopularPostDocs,
      docs: docs ?? this.docs,
      allPostData: allPostData ?? this.allPostData,
      getPageMemberDocs: getPageMemberDocs ?? this.getPageMemberDocs,
      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
      isReportingPage: isReportingPage ?? this.isReportingPage,
      isReportingPost: isReportingPost ?? this.isReportingPost,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageName': pageName.text,
      'pageDescription': pageDescription.text,
      'content': content.text,
      'images': images.map((image) => {'image': image.image?.path}).toList(),
      'fetchAllPostData': fetchAllPostData?.map((post) => post.toJson()).toList(),
      'getAllPost': getAllPost?.map((post) => post.toJson()).toList(),
      'comments': comments?.map((comment) => comment.toJson()).toList(),
      'postCount': postCount,
      'allPostData': allPostData?.toJson(),
      'recommendedPages': recommendedPages?.map((page) => page.toJson()).toList(),
      'allPageModelDocs': allPageModelDocs?.map((page) => page.toJson()).toList(),
      'getPageMemberDocs': getPageMemberDocs?.map((member) => member.toJson()).toList(),
      'pagePopularPostDocs': pagePopularPostDocs?.map((post) => post.toJson()).toList(),
      'data': data?.toJson(),
      'docs': docs,
      'shareModelData': shareModelData?.toJson(),
      'isFocused': isFocused,
      'isLoading': isLoading,
      'isReportingPage': isReportingPage,
      'isReportingPost': isReportingPost,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class PostImage {
  final File? image;

  PostImage({this.image});

  PostImage copyWith({File? image}) {
    return PostImage(image: image ?? this.image);
  }
}

const pageReport = [
  "Spam or misleading content",
  "Inappropriate_Content",
  "Fraudulent_activity",
  "Violates_terms_and_conditions",
  "other"
];
