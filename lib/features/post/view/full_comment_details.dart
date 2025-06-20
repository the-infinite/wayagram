import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/view/comment_replies.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class CommentDetailsScreen extends ConsumerStatefulWidget {
  static const route = "/post/comments/details";

  final String id;
  final String postId;
  final String source;

  // Construct.
  const CommentDetailsScreen({
    super.key,
    required this.id,
    required this.postId,
    required this.source,
  });

  @override
  ConsumerState<CommentDetailsScreen> createState() => _CommentDetailsScreenState();
}

class _CommentDetailsScreenState extends ConsumerState<CommentDetailsScreen> {
  late final objectProvider = createCommentProvider("repl-${widget.id}");
  late final notifier = ref.read(objectProvider.notifier);

  PostModel? _post;
  CommentModel? _comment;
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final comment = await notifier.getSingleComment(widget.postId, widget.id);
        await myPageNotifier.refreshPost(widget.postId);

        //? If this is still mounted.
        if (mounted) {
          setState(() {
            _comment = comment;
            _post = wayaPostCache.getCachedData(widget.postId);
            loading = false;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_post == null || _comment == null) {
      return WayaScaffold(
        isScrollable: false,
        title: loading ? "Loading..." : "Deleted Resource",
        body: Center(
          child: EmptyState(
            assetImage: loading ? const CircularProgressIndicator() : WayaAssets.icons.emptyState.svg(),
            message: loading ? "Please wait while we fetch this post" : "This comment or post has been deleted",
          ),
        ),
      );
    }

    //? Since we found the post AND the comments.
    return WayaCommentRepliesScreen(
      comment: _comment!,
      post: _post!,
      title: "Comment Details",
    );
  }
}
