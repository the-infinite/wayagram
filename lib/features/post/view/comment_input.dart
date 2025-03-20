import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class CommentInputField extends ConsumerWidget {
  final PostModel post;
  final GlobalKey<FormState> formKey;
  final ValueNotifier<bool> loadingController;

  // Construct.
  const CommentInputField({
    super.key,
    required this.formKey,
    required this.loadingController,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final notifier = ref.read(createCommentProvider.notifier);
    final pageNotifier = ref.read(createPageProvider.notifier);
    final viewModel = ref.watch(createPageProvider);
    final state = ref.watch(createCommentProvider);

    return //? For our comment input field.
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
                      borderColor:
                          formState.hasError && viewModel.content.text.isEmpty ? wayaTheme.colorScheme.error : null,
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

              //? If this is editing.
              if (state.isEditing) {
                await notifier.editComment(state.replyingTo!, viewModel.content.text);
              }

              //? Since this is sending.
              else {
                await pageNotifier.commentOnPost(post.id, viewModel.content.text, state.replyingTo);
              }

              // Clear the text in the text editing controller.
              viewModel.content.clear();
              notifier.setReplyTo(null);

              //? Then update this.
              await notifier.getCommentsStream(post.id);
            },
            height: 50,
          ),
        ),
      ],
    );
  }
}
