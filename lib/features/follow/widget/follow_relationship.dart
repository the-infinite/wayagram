import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
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
              child: InkWell(
                onTap: () => WayaNav.toNamed(WayaAppRoutes.getProfileRoute(data.$1.id)),
                borderRadius: BorderRadius.circular(12.r),
                splashColor: theme.colorScheme.primary.withAlpha(30),
                focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
                highlightColor: theme.colorScheme.primary.withAlpha(30),
                child: Card(
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 0, right: 0),
                          leading: ChatProfilePicture(
                            user: data.$1,
                            radius: 20.h,
                            showActive: false,
                          ),
                          horizontalTitleGap: 5.w,
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
                                    border: this.data.isUserFollowing
                                        ? Border.all(
                                            color: theme.colorScheme.primary,
                                            width: 1.5,
                                          )
                                        : null,
                                    color: this.data.isUserFollowing  ? theme.colorScheme.white : theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(7.r),
                                  ),
                                  child: Text(
                                    this.data.isUserFollowing ? "Following" : "Follow",
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: this.data.isUserFollowing
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            data.$2.username != null ? '@${data.$2.username}' : 'ID: ${data.$1.id}',
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
            ),
    );
  }
}
