import 'package:flutter/material.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';

class CommentInputController extends ValueNotifier<int> {
  final content = TextEditingController();
  bool isEditing = false;
  String? postId;
  CommentModel? replyingTo;
  String? parentId;
  CommentInputController._() : super(0);

  static final instance = CommentInputController._();

  void setPost(String postId) {
    this.postId = postId;
    refresh();
  }

  void setReplyTo(CommentModel? replyTo, [bool isEditing = false]) {
    replyingTo = replyTo;
    this.isEditing = isEditing;
    if (isEditing) {
      content.text = replyTo?.content ?? "";
    }
    refresh();
  }

  void setParentId(String id) {
    parentId = id;
    refresh();
  }

  void refresh() {
    value = value + 1;
  }

  void reset() {
    content.clear();
    isEditing = false;
    postId = null;
    replyingTo = null;
    parentId = null;
    refresh();
  }
}
