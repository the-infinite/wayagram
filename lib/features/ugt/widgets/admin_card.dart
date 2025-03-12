import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class AdminCard extends StatelessWidget {
  final String imageUrl;
  final String rank;
  final String name;
  final String votes;
  final double? radius;
  final bool? isCenter;

  const AdminCard({
    super.key,
    required this.imageUrl,
    required this.rank,
    required this.name,
    required this.votes,
    this.isCenter = false,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Circular Image with Border
            Container(
              // padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: CircleAvatar(
                radius: radius ?? 35,
                backgroundColor: wayaTheme
                    .colorScheme.greyColor100, // Background color behind image
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),

            // Rank Badge
            Positioned(
              bottom: -25,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      rank,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Gap(40),

        // Name
        Transform.translate(
          offset:
              isCenter! ? Offset(0, -5) : Offset(0, 0), // Shift up by 10 pixels

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // Votes
              Text(
                votes,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
