
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/post/model/fetch_all_post.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/shared/model/media_upload_model.dart';

import '../../../post/model/share_model.dart';

class PageState{
  final TextEditingController pageName;
  final TextEditingController pageDescription;
  final TextEditingController content;
  final List<PostImage> images;
  final List<Docs>? fetchAllPostData;
  final List<GetAllPostDocs>? getAllPost;
  final List<Comments>? comments;
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
      comments: comments ?? this.comments,
      docs: docs ?? this.docs,

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