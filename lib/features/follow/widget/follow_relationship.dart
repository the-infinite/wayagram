import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class FollowRelationshipWidget extends StatelessWidget {
  final FollowModel data;
  final int index;
  final FollowNotifier notifier;

  // This is fine.
  const FollowRelationshipWidget({
    super.key,
    required this.data,
    required this.index,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    //? Our theme.
    final theme = Theme.of(context);

    //? The actual component.
    return WayaFutureSubscriber(
      future: data.getOtherUser(),
      suspense: (context) => const SizedBox(),
      builder: (context, data) => data == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 0, right: 0),
                        leading: ChatProfilePicture(user: data.$1, radius: 20.h),
                        title: Row(
                          children: [
                            //? The fullname of the user in question.
                            Text(
                              data.$1.fullname,
                              style: theme.textTheme.bodyMedium,
                            ),

                            // Infinite space.
                            Spacer(),

                            //? The current state of affairs.
                            GestureDetector(
                              onTap: () async {
                                //? If this user is following this one.
                                if (this.data.isUserFollowing) {
                                  await notifier.unfollowUser(data.$1.id);
                                }

                                //? Since I am not yet following this user...
                                else {
                                  await notifier.followUser(data.$1.id);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20.w),
                                padding: REdgeInsets.symmetric(vertical: 5.dg, horizontal: 10.dg),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.colorScheme.primary600,
                                    width: 1.5,
                                  ),
                                  color: theme.colorScheme.white,
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Text(
                                  this.data.isUserFollowing == true ? "Following" : "Follow",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '',
                          style: theme.textTheme.bodySmall!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.greyColor500,
                          ),
                        ),
                      ),

                      //Gap(10),

                      //? This is the user's bio.
                      Text(
                        data.$2.bio ?? '',
                        style: theme.textTheme.displaySmall!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.greyColor500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
