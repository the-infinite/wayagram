import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/post/controller/comment.dart';
import 'package:wayagram/features/post/widgets/comment_input.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/features/post/widgets/comment.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class PostCommentsWidget extends ConsumerStatefulWidget {
  final String id;
  final PostModel post;

  // Construct.
  const PostCommentsWidget({
    super.key,
    required this.id,
    required this.post,
  });

  @override
  ConsumerState<PostCommentsWidget> createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends ConsumerState<PostCommentsWidget> {
  late final notifier = ref.read(createCommentProvider.notifier);
  final inputController = CommentInputController.instance;
  final loadingController = ValueNotifier(false);
  final handler = WayaObservableScrollController();
  final formKey = GlobalKey<FormState>();
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
          //? Fetch and update the comments every 5 seconds.
          notifier.getCommentsStream(widget.id).then(
            (result) {
              //? Since it is not mounted, cancel the timer.
              if (!mounted) {
                timer.cancel();
              }
            },
          );
        });
      },
    );

    //? This is fine.
    super.initState();
  }

  @override
  void dispose() {
    try {
      _timer?.cancel();
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
    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {
        if (!isPopping) return;
        notifier.reset();
      },
      child: WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: 'All Comments',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            if (state.isLoading && !state.hasLoaded)
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: WayaPaginatedListView(
                  nextPage: state.page,
                  getPage: (_) async => await notifier.getCommentsStream(widget.id),
                  itemCount: state.comments.length,
                  isAtEnd: !state.hasNextPage,
                  handler: handler,
                  builder: (context, index) => WayaCommentWidget(
                    index: index,
                    comment: state.comments[index],
                    post: widget.post,
                    ref: ref,
                    controller: inputController,
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
