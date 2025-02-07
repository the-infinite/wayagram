
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/post/model/fetch_all_post.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/features/post/model/media_upload_model.dart';

class PageState{
  final TextEditingController pageName;
  final TextEditingController pageDescription;
  final TextEditingController content;
  final List<PostImage> images;
  final List<Docs>? fetchAllPostData;
  final List<GetAllPostDocs>? getAllPost;
  final MediaUploadData? data;

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
    this.getAllPost = const [],
    this.data
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
    MediaUploadData? data,

    bool? isFocused,
    bool? isLoading,
}){
    return PageState(
      pageName: pageName ?? this.pageName,
      pageDescription: pageDescription ?? this.pageDescription,
      content: content ?? this.content,
      images: images ?? this.images,
      data: data ?? this.data,
      fetchAllPostData: fetchAllPostData ?? this.fetchAllPostData,
      getAllPost: getAllPost ?? this.getAllPost,

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