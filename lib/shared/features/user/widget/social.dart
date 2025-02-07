import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

import 'profile_picture.dart';

class SocialUserWidget extends StatelessWidget {
  final UserDetailsModel user;

  const SocialUserWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // The user's chat profile picture.
        ChatProfilePicture(
          user: user,
          radius: 22,
          showActive: false,
        ),

        // Some space.
        const Gap(5),

        //* For the displayed content.
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* For the user's name.
              Text(
                user.fullname,
                maxLines: 1,
                style: WayaTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              //? For the user's description.
              Text(
                user.email ?? '',
                maxLines: 1,
                style: WayaTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                  color: WayaColors.greyColor500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
