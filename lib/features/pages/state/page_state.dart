
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/pages/data/model/all_page_model.dart';
import 'package:wayagram/features/pages/data/model/get_page_member_model.dart';
import 'package:wayagram/features/post/model/fetch_all_post.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/features/post/model/media_upload_model.dart';

import '../../post/model/share_model.dart';
import '../data/model/pages_users_follow_model.dart';

class PageState{
  final TextEditingController pageName;
  final TextEditingController pageDescription;
  final TextEditingController content;
  final List<PostImage> images;
  final List<Docs>? fetchAllPostData;
  final List<GetAllPostDocs>? getAllPost;
  final List<Comments>? comments;
  List<PagesUsersFollowDocs>? pagesUsersFollow;
  List<AllPageModelDocs>? allPageModelDocs;
  List<GetPageMemberDocs>? getPageMemberDocs;
  final MediaUploadData? data;
  List<dynamic>? docs;
  final ShareModelData? shareModelData;

  final bool isFocused;
  final bool isLoading;

  PageState({
    TextEditingController? pageName,
    TextEditingController? pageDescription,
    TextEditingController? content,

    this.isFocused = false,
    this.isLoading = false,
    this.images = const [],
    this.fetchAllPostData = const [],
    this.comments = const [],
    this.getAllPost = const [],
    this.docs = const [],
    this.pagesUsersFollow = const [],
    this.allPageModelDocs = const [],
    this.getPageMemberDocs = const [],
    this.data,
    this.shareModelData,
}):  pageName = pageName ?? TextEditingController(),
     pageDescription = pageDescription ?? TextEditingController(),
     content = content ?? TextEditingController();

  PageState copyWith({
    TextEditingController? pageName,
    TextEditingController? pageDescription,
    TextEditingController? content,
    List<PostImage>? images,
    List<Docs>? fetchAllPostData,
    List<GetAllPostDocs>? getAllPost,
    List<PagesUsersFollowDocs>? pagesUsersFollow,
    List<AllPageModelDocs>? allPageModelDocs,
    List<GetPageMemberDocs>? getPageMemberDocs,
    List<Comments>? comments,
    List<dynamic>? docs,
    MediaUploadData? data,
    ShareModelData? shareModelData,

    bool? isFocused,
    bool? isLoading,
}){
    return PageState(
      pageName: pageName ?? this.pageName,
      pageDescription: pageDescription ?? this.pageDescription,
      content: content ?? this.content,
      images: images ?? this.images,
      data: data ?? this.data,
      shareModelData: shareModelData ?? this.shareModelData,
      fetchAllPostData: fetchAllPostData ?? this.fetchAllPostData,
      getAllPost: getAllPost ?? this.getAllPost,
      allPageModelDocs: allPageModelDocs ?? this.allPageModelDocs,
      comments: comments ?? this.comments,
      docs: docs ?? this.docs,
      pagesUsersFollow: pagesUsersFollow ?? this.pagesUsersFollow,
      getPageMemberDocs: getPageMemberDocs ?? this.getPageMemberDocs,

      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
    );
}
}

class PostImage {
  final File? image;

  PostImage({this.image});

  PostImage copyWith(
      {File? image}) {
    return PostImage(image: image ?? this.image);
  }
}