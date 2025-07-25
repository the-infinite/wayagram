import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class ChatProfilePicture extends StatefulWidget {
  final UserDetailsModel user;
  final ChatModel? chat;
  final double radius;
  final bool showActive;
  final DateTime? lastSeen;
  final bool canMove;
  final bool useGroup;
  final bool isEdit;

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
  State<ChatProfilePicture> createState() => _ChatProfilePictureState();
}

class _ChatProfilePictureState extends State<ChatProfilePicture> {
  late final bool isGroup;
  late final dynamic chatUser;

  @override
  void initState() {
    super.initState();
    isGroup = widget.useGroup && widget.chat?.chatType == ChatType.group;
    chatUser = widget.chat?.chatMembers
        .where((member) => member.userId == widget.user.id)
        .firstOrNull
        ?.chatUser;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //? This is the component.
    return Consumer(
      builder: (context, ref, child) => GestureDetector(
        onTap: widget.isEdit
            ? () async {
                final result = await WayaUtils.pickAndCropImage();
                final conversationNotifier =
                    ref.read(conversationProvider.notifier);

                //? If you never chose an image
                if (result == null) {
                  return;
                }

                //? If this is a group chat.
                else if (isGroup) {
                  await conversationNotifier.changeGroupProfilePicture(
                      widget.chat!.id, result);
                }

                //? For now do nothing else.
                else {}
              }
            : widget.canMove && widget.user.profilePicture != null
                ? () async {
                    final result =
                        await WayaNavigationHelper.toImageDetailsScreen(
                      null,
                      [widget.user.profilePicture!],
                    );

                    //? Do nothing.
                    if (result == null) return;
                  }
                : null,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              // First, the image itself.
              ClipPath(
                clipper: const ShapeBorderClipper(shape: CircleBorder()),
                child: CircleAvatar(
                  radius: widget.radius,
                  backgroundColor: widget.chat != null &&
                          ((isGroup && widget.chat?.groupImage == null) ||
                              (!isGroup &&
                                  (!(chatUser?.canSeeProfilePicture ?? true) ||
                                      widget.user.profilePicture == null)))
                      ? theme.colorScheme.primary50
                      : theme.colorScheme.greyColor200,
                  backgroundImage: isGroup
                      ? widget.chat?.groupImage != null
                          ? NetworkImage(widget.chat!.groupImage!)
                          : null
                      : (chatUser?.canSeeProfilePicture ?? true) &&
                              widget.user.profilePicture != null
                          ? NetworkImage(widget.user.profilePicture!)
                          : null,
                  child: widget.chat != null &&
                          ((isGroup && widget.chat?.groupImage == null) ||
                              (!isGroup &&
                                  (!(chatUser?.canSeeProfilePicture ?? true) ||
                                      widget.user.profilePicture == null)))
                      ? Text(
                          widget.chat!
                              .initials(widget.useGroup, widget.user.id),
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.customPrimary,
                            fontSize: (widget.radius * 0.75).sp,
                          ),
                        )
                      : !isGroup && widget.user.profilePicture == null
                          ? Icon(
                              Icons.person,
                              color: theme.colorScheme.greyColor600,
                            )
                          : null,
                ),
              ),

              // Second, the activity marker.
              if ((chatUser?.canSeeOnlineStatus ?? true) && widget.showActive)
                Positioned(
                  right: 4.w,
                  bottom: 0,
                  child: widget.isEdit
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
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all((widget.radius * 0.225).sp),
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
