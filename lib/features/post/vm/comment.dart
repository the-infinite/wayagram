import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/pages/data/model/feeds.dart';
import 'package:wayagram/features/pages/data/model/followers_model.dart';
import 'package:wayagram/features/pages/data/model/page_state.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/post/model/fetch_all_post.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/features/post/model/media_upload_model.dart';
import 'package:wayagram/features/post/model/saved_posts.dart';
import 'package:http/http.dart' as http;
import 'package:wayagram/features/post/state/comment.dart';

import '../../../shared/features/file/repo/default.dart';
import '../../post/model/fetch_comment.dart';


class CommentNotifier extends StateNotifier<CommentState> {

   final PageRepository _pageRepository;
  //
  // final _logger = getLogger('CommentVm');
  CommentNotifier(super.state, this._pageRepository);
  //CommentVm(this.ref, this._pageRepository) : super(CommentState()) {}

  Future<List<Comments>> getCommentsStream(String postId) async{

    try{
      //state = state.copyWith(isLoading: true);
      final response = await _pageRepository.getComment(postId);
      //state = state.copyWith(isLoading: false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        FetchComment responseModel = FetchComment.fromJson(response.data);
        //state = state.copyWith(comments: responseModel.data?.comments);
        return responseModel.data?.comments ?? [];
      }

    }catch (e){
      print(e);
    }
    //state = state.copyWith(isLoading: false);
    return [];

  }

}

final commentProvider = Provider((ref) => PageRepository());
final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createCommentProvider = StateNotifierProvider<CommentNotifier, CommentState>((ref) {
  final pageRepository = ref.watch(commentProvider);

  return CommentNotifier(CommentState.initial, pageRepository,);
});

