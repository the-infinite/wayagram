import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

import 'profile_picture.dart';

class SocialUserWidget extends StatelessWidget {
  final UserDetailsModel user;

  const SocialUserWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    //? Now, send this forward.
    return FutureBuilder(
      future: UserResource.getSocialProfile(user.id!),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        //? Since this is fine.
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
                  if (profile?.username != null)
                    Text(
                      "@${profile!.username!}",
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
      },
    );
  }
}

class SocialUserSelectionWidget extends StatelessWidget {
  final UserDetailsModel user;
  final bool isSelected;
  final FutureOr<void> Function(UserDetailsModel, SocialProfileModel) onSelect;

  const SocialUserSelectionWidget({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    //? Now, send this forward.
    return FutureBuilder(
      future: UserResource.getSocialProfile(user.id!),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        //? Since this is fine.
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
                  if (profile?.username != null)
                    Text(
                      "@${profile!.username!}",
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
      },
    );
  }
}
