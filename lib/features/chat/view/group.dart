import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/vm/group.dart';
import 'package:wayagram/features/chat/widget/chat_selection.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class CreateConversationGroupScreen extends ConsumerStatefulWidget {
  const CreateConversationGroupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateConversationGroupScreenState();
}

class _CreateConversationGroupScreenState extends ConsumerState<CreateConversationGroupScreen> {
  late final notifier = ref.read(createChatGroupProvider.notifier);
  late final conversationNotifier = ref.read(conversationProvider.notifier);
  late final selection = ValueNotifier<List<UserDetailsModel>>(ref.read(createChatGroupProvider).members);
  final formKey = GlobalKey<FormState>();
  final loadingController = ValueNotifier(false);
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    loadingController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    selection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Some data.
    final theme = Theme.of(context);
    final state = ref.watch(createChatGroupProvider);

    // Build the component.
    return WayaScaffold(
      title: "Create chat group",
      isScrollable: true,
      padding: EdgeInsets.all(15.h),
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IntrinsicHeight(
          child: WayaProgressiveButton(
            notifier: loadingController,
            callback: () async {
              final result = await conversationNotifier.startChat(
                ChatType.group,
                state.members.map((e) => e.id).toList(),
                nameController.text.trim(),
                descriptionController.text.trim(),
                state.image,
              );

              //? This is fine.
              if (result != null) {
                WayaNav.goBack(result: result);
              }
            },
            height: null,
            verticalPadding: 6.h,
            horizontalPadding: 12.w,
            text: 'Create',
            isDisabled: state.members.isEmpty,
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
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: notifier.selectImage,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: state.image == null
                        ? null
                        : Border.all(
                            color: theme.colorScheme.greyColor200,
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                  ),
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundColor: theme.colorScheme.greyColor200,
                    backgroundImage: state.image != null ? FileImage(state.image!) : null,
                    child: state.image == null
                        ? WayaAssets.icons.cAttachCamera.svg(
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.greyColor600,
                              BlendMode.srcIn,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),

            // Some space.
            SizedBox(height: 20.h),

            //? Section title.
            Text(
              'Group Information',
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                color: theme.colorScheme.greyColor400,
              ),
            ),

            // More space
            SizedBox(height: 10.h),

            //? The name of the group.
            WayaFormField(
              controller: nameController,
              label: "Group Name",
              hintText: "Enter group name here",
              onChanged: (value) => debounce(
                key: "save-name",
                () {
                  notifier.saveData(nameController.text.trim(), descriptionController.text.trim());
                },
              ),
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
              padding: EdgeInsets.all(15),
              onChanged: (value) => debounce(
                key: "save-name",
                () => notifier.saveData(nameController.text.trim(), descriptionController.text.trim()),
              ),
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

            //? Section title.
            Text(
              'Added Group Members',
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                color: theme.colorScheme.greyColor400,
              ),
            ),

            // This is fine.
            SizedBox(height: 10.h),

            //? Group members.
            ...List.generate(
              state.members.length,
              (index) {
                final user = state.members[index];

                //? Something for a single conversation.
                return SelectUserWidget(
                  id: user.id,
                  index: index,
                  controller: selection,
                  onSelect: (chat, isSelected) => notifier.saveUsers(selection.value),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}