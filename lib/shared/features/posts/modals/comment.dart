import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/model/post_reponse_model.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/shared/features/posts/logic/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class PostCommentModal extends ConsumerStatefulWidget {
  final Post post;
  final int index;

  // Construct.
  const PostCommentModal({
    super.key,
    required this.post,
    required this.index,
  });

  @override
  ConsumerState<PostCommentModal> createState() => _PostCommentModalState();
}

class _PostCommentModalState extends ConsumerState<PostCommentModal> {
  late final commentNotifier = ref.read(createCommentProvider.notifier);
  late final pageNotifier = ref.read(createPageProvider.notifier);
  Timer? _timer;
  List<Comments>? _comments;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final result = await commentNotifier.getCommentsStream(widget.post.id);

        _timer = Timer.periodic(const Duration(seconds: 5), (_) {
          //? Fetch and update the comments every 5 seconds.
          commentNotifier.getCommentsStream(widget.post.id).then(
            (result) {
              setState(() => _comments = result);
            },
          );
        });

        //? If this is still good to go.
        if (mounted) setState(() => _comments = result);
      },
    );

    //? This is fine.
    super.initState();
  }

  @override
  void reassemble() {
    _timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final result = await commentNotifier.getCommentsStream(widget.post.id);

        _timer = Timer.periodic(const Duration(seconds: 5), (_) {
          //? Fetch and update the comments every 5 seconds.
          commentNotifier.getCommentsStream(widget.post.id).then(
            (result) {
              setState(() => _comments = result);
            },
          );
        });

        //? If this is still good to go.
        if (mounted) setState(() => _comments = result);
      },
    );
    super.reassemble();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    //? This is fine.
    return PopScope(
      onPopInvokedWithResult: (going, _) {
        if (going) _timer?.cancel();
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: 450.h,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //? First, the title.
              Text(
                'All Comments',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              //? Then we do this.
              const Gap(20),
              Expanded(
                child: _comments == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _comments!.length,
                        itemBuilder: (context, index) {
                          final comment = _comments![index];

                          //? Now, return this comment.
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //? First, the commenter
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //? The user's profile picture.
                                    ChatProfilePicture(
                                      radius: 10.r,
                                      user: comment.user!,
                                      showActive: false,
                                    ),

                                    // Space.
                                    const Gap(10),

                                    //? The user's fullname.
                                    Text(
                                      comment.user!.fullname,
                                      style: theme.textTheme.bodyBold.copyWith(
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
                                      style: theme.textTheme.bodyMedium!.copyWith(
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
                                  style: theme.textTheme.bodyMedium!.copyWith(
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

              //? For our comment input field.
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //? The user's picture.
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ChatProfilePicture(
                      radius: 20.r,
                      user: ConversationState.self,
                      showActive: false,
                    ),
                  ),

                  // Some space.
                  const Gap(10),

                  //? The textfield for our comments.
                  Expanded(
                    flex: 2,
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormField<String>(validator: (value) {
                              return null;
                            }, builder: (formState) {
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
                                        ? theme.colorScheme.error
                                        : null,
                                  ),

                                  //? If this raised an error.
                                  if (formState.hasError && viewModel.content.text.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        formState.errorText!,
                                        style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                                      ),
                                    ),
                                ],
                              );
                            }),
                            Gap(20),
                          ],
                        )),
                  ),

                  // Space.
                  const Gap(10),

                  //? This is our button for sending a comment.
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: 50,
                      child: WayaButton(
                        centerWidget: WayaAssets.images.pages.sendIc.image(
                          height: 25.h,
                        ),
                        callback: !viewModel.isLoading
                            ? () async {
                                //? If this is a-okay.
                                if (formKey.currentState!.validate()) {
                                  await pageNotifier.commentOnPost(
                                    widget.post.id,
                                    viewModel.content.text,
                                  );

                                  //? Reset this.
                                  pageNotifier.reset();

                                  //? Go backward.
                                  WayaNav.goBack();
                                }
                              }
                            : null,
                        height: 50,
                        isLoading: viewModel.isLoading,
                      ),
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
