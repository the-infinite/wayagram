import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_future_subscriber.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/general_settings/privacy_settings/widget/block_dialog.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class BlockedCard extends StatelessWidget {
  final ChatUser user;
  const BlockedCard(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
      final wayaTheme = Theme.of(context);

      //? future to get the user details before populating the UI
    return WayaFutureSubscriber(
      future: UserResource.getUserDetails(user.userId),
      suspense: (context) => const SizedBox(),
      builder: (context, user1) => SizedBox(
        height: 70.h,
        width: context.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? The user's profile picture.
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? If this is a group chat, and we know this user.
                if (user1 != null)
                  ChatProfilePicture(
                    user: user1.$1,
                    canMove: true,
                    showActive: false,
                    radius: 20.r,
                  ),

                const Gap(10),
                //? The user's name.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: wayaTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: wayaTheme.colorScheme.black,
                      ),
                    ),
                    Text(
                      user.username,
                      style: wayaTheme.textTheme.bodyMedium?.copyWith(
                        color: wayaTheme.colorScheme.greyColor500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.primary50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: wayaTheme.colorScheme.primary,
                      size: 20.0,
                    ),
                    onPressed: () {
                     //? show the block dialog to confirm unblocking the user
                      WayaUtils.showModalSheetUgt(
                        context,
                        child: BlockDialog(
                          title:
                              "Are you sure you want to unblock this wayagram user?",
                          // isLoading: isLoading,
                          userId: user.userId,
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
