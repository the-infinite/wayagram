import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/view/comment_input.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/features/post/widgets/comment.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class WayaCommentRepliesScreen extends ConsumerStatefulWidget {
  static const route = "/post/comments/replies";
  final CommentModel comment;
  final PostModel post;

  // Construct.
  const WayaCommentRepliesScreen({
    super.key,
    required this.comment,
    required this.post,
  });

  @override
  ConsumerState<WayaCommentRepliesScreen> createState() => _WayaCommentRepliesScreenState();
}

class _WayaCommentRepliesScreenState extends ConsumerState<WayaCommentRepliesScreen> {
  late final notifier = ref.read(createCommentProvider.notifier);
  late final pageNotifier = ref.read(createPageProvider.notifier);
  final loadingController = ValueNotifier(false);
  final handler = WayaObservableScrollController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {},
    );

    //? This is fine.
    super.initState();
  }

  @override
  void dispose() {
    try {
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
    final state = ref.watch(createCommentProvider);

    //? Now, return the screen.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: 'Replies',
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
            canReply: false,
          ),

          // Some space
          Gap(20.h),

          //? The comments that are left.
          if (state.isLoading && !state.hasLoaded)
            Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: WayaPaginatedListView(
                  nextPage: state.page,
                  getPage: (_) async => await notifier.getCommentsStream(widget.post.id),
                  itemCount: state.comments.length,
                  isAtEnd: !state.hasNextPage,
                  handler: handler,
                  builder: (context, index) => WayaCommentWidget(
                    index: index,
                    comment: state.comments[index],
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
          ),
        ],
      ),
    );
  }
}
