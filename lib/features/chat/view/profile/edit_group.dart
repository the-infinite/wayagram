import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class EditChatGroupScreen extends ConsumerStatefulWidget {
  static const route = "/conversation/chat/profile/group/edit";
  final String groupId;
  final String chatId;

  // Construct.
  const EditChatGroupScreen({
    super.key,
    required this.groupId,
    required this.chatId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditGroupScreenState();
}

class _EditGroupScreenState extends ConsumerState<EditChatGroupScreen> {
  late final notifier = ref.read(conversationProvider.notifier);
  late final ChatModel chat;
  late final TextEditingController descriptionController;
  late final TextEditingController nameController;
  final formKey = GlobalKey<FormState>();
  final loadingController = ValueNotifier(false);

  @override
  void initState() {
    chat = notifier.getChat(widget.chatId)!;
    nameController = TextEditingController(text: chat.name);
    descriptionController = TextEditingController(text: chat.description);
    super.initState();
  }

  @override
  void dispose() {
    loadingController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Some data.
    final theme = Theme.of(context);

    // Build the component.
    return WayaScaffold(
      title: "Edit Group Info",
      isScrollable: true,
      padding: EdgeInsets.all(15.h),
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IntrinsicHeight(
          child: WayaProgressiveButton(
            notifier: loadingController,
            callback: () async {
              //? This is fine.
              if (!(formKey.currentState?.validate() ?? false)) {
                return;
              }

              //? Now, validate this.
              final result = await notifier.updateGroupInfo(
                widget.chatId,
                nameController.text,
                //descriptionController.text,
              );

              //? This is fine.
              if (result) {
                WayaNav.goBack(result: result);
              }
            },
            height: null,
            verticalPadding: 6.h,
            horizontalPadding: 12.w,
            text: 'Save',
            textStyle: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.white,
            ),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //? First, the picture.
            Align(
              alignment: Alignment.center,
              child: ChatProfilePicture(
                user: chat.other.userData!,
                radius: 40.r,
                showActive: true,
                isEdit: true,
                chat: chat,
              ),
            ),

            // Some space.
            SizedBox(height: 20.h),

            //? The name of the group.
            WayaFormField(
              controller: nameController,
              label: "Group Name",
              hintText: "Enter group name here",
              validator: (value) {
                if (nameController.text.trim().isEmpty) {
                  return "You are required to write the name for this group chat.";
                }

                //? This is fine.
                return null;
              },
            ),

            // More space
            SizedBox(height: 20.h),

            //? The description of the group.
            WayaFormField(
              controller: descriptionController,
              label: "Group Bio",
              hintText: "Describe the group here",
              line: 5,
              keyboardType: TextInputType.multiline,
              padding: const EdgeInsets.all(15),
              validator: (value) {
                if (descriptionController.text.trim().isEmpty) {
                  return "You are required to write a bio for this group chat.";
                }

                //? This is fine.
                return null;
              },
            ),

            // This is fine.
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
