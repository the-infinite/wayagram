import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/post/controller/comment.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/features/post/widgets/comment_reply_to.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class CommentInputField extends ConsumerWidget {
  final PostModel post;
  final GlobalKey<FormState> formKey;
  final ValueNotifier<bool> loadingController;
  final CommentNotifier notifier;
  final CommentInputController controller;

  // Construct.
  const CommentInputField({
    super.key,
    required this.formKey,
    required this.loadingController,
    required this.post,
    required this.notifier,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final replyTo = controller.replyingTo;

    //? For our comment input field.
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, redraws, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 10.h,
        children: [
          //? This is fine too.
          if (replyTo != null) ...[
            CommentReplyToWidget(
              comment: replyTo,
              ref: ref,
              controller: controller,
            ),
          ],

          //? This is fine.
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
                      if (controller.content.text.trim().isEmpty) {
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
                            keyboardType: TextInputType.multiline,
                            controller: controller.content,
                            hintText: 'Write comment here',
                            borderColor: formState.hasError
                                ? wayaTheme.colorScheme.error
                                : null,
                          ),

                          //? If this raised an error.
                          if (formState.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12),
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

                    //? If this is editing.
                    if (controller.isEditing) {
                      await notifier.editComment(post.id,
                          controller.replyingTo!.id, controller.content.text);
                    }

                    //? Since this is sending.
                    else {
                      await notifier.createComment(post.id,
                          controller.content.text, controller.replyingTo?.id);
                    }

                    // Clear the text in the text editing controller.
                    controller.reset();

                    //? Then update this.
                    await notifier.getCommentsStream(post.id);
                  },
                  height: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
