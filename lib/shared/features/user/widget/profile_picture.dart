import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class ChatProfilePicture extends StatelessWidget {
  final UserDetailsModel user;
  final ChatModel? chat;
  final double radius;
  final bool showActive;
  final DateTime? lastSeen;
  final bool canMove;
  final bool useGroup;
  final bool isEdit;

  // This is fine.
  const ChatProfilePicture({
    super.key,
    required this.user,
    required this.radius,
    this.showActive = true,
    this.isEdit = false,
    this.canMove = false,
    this.useGroup = true,
    this.lastSeen,
    this.chat,
  });

  @override
  Widget build(BuildContext context) {
    //? The theme.
    final theme = Theme.of(context);
    final isGroup = useGroup && chat?.chatType == ChatType.group;

    //? This is the component.
    return Consumer(
      builder: (context, ref, child) => GestureDetector(
        onTap: isEdit
            ? () async {
                final result = await WayaUtils.pickAndCropImage();
                final conversationNotifier = ref.read(conversationProvider.notifier);

                //? If you never chose an image
                if (result == null) {
                  return;
                }

                //? If this is a group chat.
                else if (isGroup) {
                  await conversationNotifier.changeGroupProfilePicture(chat!.id, result);
                }

                //? For now do nothing else.
                else {}
              }
            : canMove && user.profilePicture != null
                ? () async {
                    final result = await WayaNavigationHelper.toImageDetailsScreen(
                      null,
                      [user.profilePicture!],
                    );

                    //? Do nothing.
                    if (result == null) return;
                  }
                : null,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(
            children: [
              // First, the image itself.
              ClipPath(
                clipper: const ShapeBorderClipper(shape: CircleBorder()),
                child: CircleAvatar(
                  radius: radius,
                  backgroundColor: chat != null && chat?.groupImage == null
                      ? theme.colorScheme.primary50
                      : theme.colorScheme.greyColor200,
                  backgroundImage: isGroup
                      ? chat?.groupImage != null
                          ? NetworkImage(chat!.groupImage!)
                          : null
                      : user.profilePicture != null
                          ? NetworkImage(user.profilePicture!)
                          : null,
                  child: chat != null && ((isGroup && chat?.groupImage == null) || user.profilePicture == null)
                      ? Text(
                          chat!.initials(useGroup),
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.customPrimary,
                            fontSize: (radius * 0.75).sp,
                          ),
                        )
                      : user.profilePicture == null
                          ? Icon(
                              Icons.person,
                              color: theme.colorScheme.greyColor600,
                            )
                          : null,
                ),
              ),

              // Second, the activity marker.
              if (showActive)
                Positioned(
                  right: 4.w,
                  bottom: 0,
                  child: isEdit
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.white,
                            border: Border.all(
                              color: theme.colorScheme.primary50,
                              width: 1,
                            ),
                          ),
                          child: WayaAssets.icons.mEdit.svg(
                            height: 14.sp,
                            width: 14.sp,
                            color: theme.colorScheme.primary,
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all((radius * 0.225).sp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.success,
                            border: Border.all(
                              color: theme.colorScheme.white,
                              width: 1,
                            ),
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
