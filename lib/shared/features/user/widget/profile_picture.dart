import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class ChatProfilePicture extends StatelessWidget {
  final UserDetailsModel user;
  final ChatModel? chat;
  final double radius;
  final bool showActive;
  final DateTime? lastSeen;
  final bool canMove;

  // This is fine.
  const ChatProfilePicture({
    super.key,
    required this.user,
    required this.radius,
    this.showActive = true,
    this.canMove = false,
    this.lastSeen,
    this.chat,
  });

  @override
  Widget build(BuildContext context) {
    //? The theme.
    final theme = Theme.of(context);

    //? This is the component.
    return GestureDetector(
      onTap: canMove && user.profilePicture != null
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
                backgroundImage: chat?.chatType == ChatType.group
                    ? chat?.groupImage != null
                        ? NetworkImage(chat!.groupImage!)
                        : null
                    : user.profilePicture != null
                        ? NetworkImage(user.profilePicture!)
                        : null,
                child: chat != null && chat?.groupImage == null && user.profilePicture == null
                    ? Text(
                        chat!.initials,
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
                child: Container(
                  padding: const EdgeInsets.all(7),
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
    );
  }
}
