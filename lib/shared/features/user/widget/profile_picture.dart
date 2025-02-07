import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class ChatProfilePicture extends StatelessWidget {
  final UserDetailsModel user;
  final double radius;
  final bool showActive;

  // This is fine.
  const ChatProfilePicture({
    super.key,
    required this.user,
    required this.radius,
    this.showActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          // First, the image itself.
          ClipPath(
            clipper: const ShapeBorderClipper(shape: CircleBorder()),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: WayaColors.greyColor200,
              backgroundImage: user.profilePicture != null ? CachedNetworkImageProvider(user.profilePicture) : null,
              child: user.profilePicture == null
                  ? Icon(
                      Icons.person,
                      color: WayaColors.greyColor600,
                    )
                  : null,
            ),
          ),

          // Second, the activity marker.
          if (showActive)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WayaColors.success,
                  border: Border.all(
                    color: WayaColors.white,
                    width: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
