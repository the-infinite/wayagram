import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/post/controller/comment.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/widgets/comment_input.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/features/post/widgets/comment.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class WayaCommentRepliesScreen extends ConsumerStatefulWidget {
  static const route = "/post/comments/replies";
  final CommentModel comment;
  final PostModel post;
  final String title;

  // Construct.
  const WayaCommentRepliesScreen({
    super.key,
    required this.comment,
    required this.post,
    this.title = "Replies",
  });

  @override
  ConsumerState<WayaCommentRepliesScreen> createState() =>
      _WayaCommentRepliesScreenState();
}

class _WayaCommentRepliesScreenState
    extends ConsumerState<WayaCommentRepliesScreen> {
  late final objectProvider =
      createCommentProvider("repl-${widget.comment.id}");
  late final notifier = ref.read(objectProvider.notifier);
  final inputController = CommentInputController.instance;
  final loadingController = ValueNotifier(false);
  final handler = WayaObservableScrollController();
  final formKey = GlobalKey<FormState>();
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inputController.setNotifier(notifier);
      _timer ??= Timer.periodic(const Duration(seconds: 5), (timer) {
        //? Fetch and update the comments every 5 seconds.
        notifier.getReplies(widget.post.id, widget.comment.id).then(
          (result) {
            //? Since it is not mounted, cancel the timer.
            if (!mounted) {
              timer.cancel();
            }
          },
        );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    try {
      _timer?.cancel();
      inputController.dispose();
      loadingController.dispose();
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? First, the wayaTheme.
    final state = ref.watch(objectProvider);

    //? Now, return the screen.
    return PopScope(
      onPopInvokedWithResult: (isPopping, result) {
        if (!isPopping) return;
        notifier.resetReplies();
      },
      child: WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: widget.title,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //? First, the comment that is being replied to
            WayaCommentWidget(
              index: 0,
              comment: widget.comment,
              post: widget.post,
              ref: ref,
              controller: inputController,
              canReply: false,
            ),

            // Some space
            Gap(20.h),

            //? The comments that are left.
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: WayaPaginatedListView(
                  nextPage: state.replyPage,
                  getPage: (_) async => await notifier.getReplies(
                      widget.post.id, widget.comment.id),
                  itemCount: state.replies.length,
                  isAtEnd: !state.replyHasNextPage,
                  handler: handler,
                  isEmpty: state.replyHasLoaded && state.replies.isEmpty,
                  whenEmpty: const SizedBox(),
                  builder: (context, index) => WayaCommentWidget(
                    index: index,
                    controller: inputController,
                    comment: state.replies[index],
                    post: widget.post,
                    ref: ref,
                  ),
                ),
              ),
            ),

            // Some more space
            Gap(5.h),

            //? For writing a comment.
            CommentInputField(
              formKey: formKey,
              loadingController: loadingController,
              post: widget.post,
              notifier: notifier,
              controller: inputController,
            ),
          ],
        ),
      ),
    );
  }
}
