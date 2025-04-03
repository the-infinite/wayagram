import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';


class DisputeProfilePicture extends StatelessWidget {
  final String? picture;
  final double radius;
  final bool showActive;
  final DateTime? lastSeen;

  // This is fine.
  const DisputeProfilePicture({
    super.key,
    required this.picture,
    required this.radius,
    this.showActive = true,
    this.lastSeen,
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
              backgroundImage: picture != null ? CachedNetworkImageProvider(picture!) : null,
              child: picture == null
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
