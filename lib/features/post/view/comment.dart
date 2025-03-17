import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/shared/features/profile/logic/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class PostCommentsWidget extends ConsumerStatefulWidget {
  final String id;

  // Construct.
  const PostCommentsWidget({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<PostCommentsWidget> createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends ConsumerState<PostCommentsWidget> {
  late final notifier = ref.read(createCommentProvider.notifier);
  late final pageNotifier = ref.read(createPageProvider.notifier);
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
    final wayaTheme = Theme.of(context);
    final state = ref.watch(createCommentProvider);
    final viewModel = ref.watch(createPageProvider);

    //? Now, return the screen.
    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {
        if (!isPopping) return;
        notifier.reset();
        pageNotifier.reset();
      },
      child: WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: 'All Comments',
        body: PopScope(
          onPopInvokedWithResult: (isPopping, _) {
            if (!isPopping) return;
            notifier.reset();
          },
          child: Column(
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
                    builder: (context, index) {
                      final comment = state.comments[index];

                      //? Now, return this comment.
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //? First, the commenter
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //? The user's profile picture.
                                ChatProfilePicture(
                                  radius: 15.r,
                                  user: comment.user!,
                                  showActive: false,
                                ),

                                // Space.
                                const Gap(10),

                                //? The user's fullname.
                                Text(
                                  comment.user!.fullname,
                                  style: wayaTheme.textTheme.bodyBold.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                // Space.
                                const Gap(10),

                                //? When the user made this comment.
                                Text(
                                  '• ${formatTimeAgo('${comment.createdAt}')}',
                                  style: wayaTheme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.greyColor500,
                                  ),
                                ),
                              ],
                            ),

                            //? The contents of the comment.
                            Text(
                              '${comment.content?.capitalizeFirst}',
                              style: wayaTheme.textTheme.bodyMedium!.copyWith(
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              // Some more space
              Gap(5.h),

              //? For our comment input field.
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //? The user's picture.
                  ChatProfilePicture(
                    radius: 20.r,
                    user: ConversationState.self,
                    showActive: false,
                  ),

                  // Some space.
                  Gap(10.h),

                  //? The textfield for our comments.
                  Expanded(
                    flex: 2,
                    child: Form(
                      key: formKey,
                      child: FormField<String>(
                        validator: (value) {
                          if (viewModel.content.text.trim().isEmpty) {
                            return 'Comment content is required';
                          }

                          //? Then return null.
                          return null;
                        },
                        builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //? A text field for the comment's actual content.
                              WayaTextFormField(
                                showBorder: true,
                                keyboardType: TextInputType.text,
                                controller: viewModel.content,
                                hintText: 'Write comment here',
                                borderColor: formState.hasError && viewModel.content.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                              ),

                              //? If this raised an error.
                              if (formState.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // Space.
                  Gap(10.h),

                  //? This is our button for sending a comment.
                  SizedBox(
                    width: 50,
                    child: WayaProgressiveButton(
                      notifier: loadingController,
                      centerWidget: WayaAssets.images.pages.sendIc.image(
                        height: 25.h,
                      ),
                      callback: () async {
                        //? If this is a-okay.
                        if (!formKey.currentState!.validate()) return;
                        await pageNotifier.commentOnPost(
                          widget.id,
                          viewModel.content.text,
                        );

                        // Clear the text in the text editing controller.
                        viewModel.content.clear();

                        //? Then update this.
                        await notifier.getCommentsStream(widget.id);
                      },
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
