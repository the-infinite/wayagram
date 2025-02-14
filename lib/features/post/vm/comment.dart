import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/state/comment.dart';


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

