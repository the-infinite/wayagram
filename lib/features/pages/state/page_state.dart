import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/pages/data/model/get_page_member_model.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/model/media_upload_model.dart';

import '../../post/model/share_model.dart';

class PageState {
  final TextEditingController pageName;
  final TextEditingController pageDescription;
  final TextEditingController content;
  final List<PostImage> images;
  final List<PostModel>? fetchAllPostData;
  final List<PostModel>? getAllPost;
  final List<Comments>? comments;
  final num? postCount;
  List<PageModel>? pagesUsersFollow;
  List<PageModel>? myPages;
  List<PageModel>? recommendedPages;
  List<PageModel>? allPageModelDocs;
  List<GetPageMemberDocs>? getPageMemberDocs;
  List<PostModel>? pagePopularPostDocs;
  final MediaUploadData? data;
  List<dynamic>? docs;
  final ShareModelData? shareModelData;

  final bool isFocused;
  final bool isLoading;
  final bool isReportingPage;
  final bool isReportingPost;

  PageState({
    TextEditingController? pageName,
    TextEditingController? pageDescription,
    TextEditingController? content,
    this.isFocused = false,
    this.isLoading = false,
    this.isReportingPage = false,
    this.isReportingPost = false,
    this.postCount,
    this.images = const [],
    this.fetchAllPostData = const [],
    this.comments = const [],
    this.pagePopularPostDocs = const [],
    this.getAllPost = const [],
    this.docs = const [],
    this.pagesUsersFollow = const [],
    this.allPageModelDocs = const [],
    this.getPageMemberDocs = const [],
    this.myPages = const [],
    this.recommendedPages = const [],
    this.data,
    this.shareModelData,
  })  : pageName = pageName ?? TextEditingController(),
        pageDescription = pageDescription ?? TextEditingController(),
        content = content ?? TextEditingController();

  PageState copyWith({
    TextEditingController? pageName,
    TextEditingController? pageDescription,
    TextEditingController? content,
    List<PostImage>? images,
    List<PostModel>? fetchAllPostData,
    List<PostModel>? getAllPost,
    List<PageModel>? pagesUsersFollow,
    List<PageModel>? myPages,
    List<PageModel>? recommendedPages,
    List<PageModel>? allPageModelDocs,
    List<GetPageMemberDocs>? getPageMemberDocs,
    List<PostModel>? pagePopularPostDocs,
    List<Comments>? comments,
    List<dynamic>? docs,
    MediaUploadData? data,
    num? postCount,
    ShareModelData? shareModelData,
    bool? isFocused,
    bool? isLoading,
    bool? isReportingPage,
    bool? isReportingPost,
  }) {
    return PageState(
        pageName: pageName ?? this.pageName,
        myPages: myPages ?? this.myPages,
        pageDescription: pageDescription ?? this.pageDescription,
        content: content ?? this.content,
        images: images ?? this.images,
        data: data ?? this.data,
        postCount: postCount ?? this.postCount,
        recommendedPages: recommendedPages ?? this.recommendedPages,
        shareModelData: shareModelData ?? this.shareModelData,
        fetchAllPostData: fetchAllPostData ?? this.fetchAllPostData,
        getAllPost: getAllPost ?? this.getAllPost,
        allPageModelDocs: allPageModelDocs ?? this.allPageModelDocs,
        comments: comments ?? this.comments,
        pagePopularPostDocs: pagePopularPostDocs ?? this.pagePopularPostDocs,
        docs: docs ?? this.docs,
        pagesUsersFollow: pagesUsersFollow ?? this.pagesUsersFollow,
        getPageMemberDocs: getPageMemberDocs ?? this.getPageMemberDocs,
        isFocused: isFocused ?? this.isFocused,
        isLoading: isLoading ?? this.isLoading,
        isReportingPage: isReportingPage ?? this.isReportingPage,
        isReportingPost: isReportingPost ?? this.isReportingPost);
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
