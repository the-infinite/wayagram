import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/moments/data/model/followed_user_moments_model.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class MomentsWidget extends StatelessWidget {
  final UserMoments? moment;
  final bool isCreate;
  final VoidCallback? onTap;
  final bool hasMoment;
  const MomentsWidget({super.key, this.isCreate = false, this.onTap, this.hasMoment = false, this.moment});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    if (isCreate) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5.h,
          children: [
            //? First, the moment the user is making.
            Stack(
              children: [
                //? Now, the user's icons.
                Container(
                  padding: EdgeInsets.all(3.dg),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: wayaTheme.colorScheme.white,
                    gradient: hasMoment
                        ? LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [
                              Color(0xFFB43000),
                              Color(0x99FFEF8C),
                              Color(0xFFFF5D2E),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          )
                        : null,
                  ),
                  child: Center(
                    child: WayaDp(
                      radius: 40.r,
                    ),
                  ),
                ),

                //? Then the plus button for creating stuff.
                Positioned(
                  bottom: 0,
                  right: -2,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, border: Border.all(width: 2, color: wayaTheme.colorScheme.white)),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff3D89DF)),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: wayaTheme.colorScheme.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

            //? Second, the user's name.
            Text(
              "You",
              maxLines: 1,
              style: wayaTheme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: WayaFutureSubscriber(
        future: UserResource.getUserDetails(moment!.userId),
        suspense: (context) => const SizedBox(),
        error: (context, error, [stackTrace]) => const SizedBox(),
        builder: (context, data) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5.h,
          children: [
            //? First, the image.
            Container(
              padding: EdgeInsets.all(3.dg),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: wayaTheme.colorScheme.white,
                gradient: hasMoment
                    ? LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Color(0xFFB43000),
                          Color(0x99FFEF8C),
                          Color(0xFFFF5D2E),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      )
                    : null,
              ),
              child: WayaDp(
                image: moment!.moments[0].image ?? data?.$1.profilePicture,
                radius: 40.r,
                isSelf: false,
                isEdit: false,
                onTap: null,
              ),
            ),

            //? Second, the user's name.
            Text(
              data?.$2.username ?? "Loading",
              maxLines: 1,
              style: wayaTheme.textTheme.bodySmall?.copyWith(
                fontSize: 13.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
