import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/state/default.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class FollowUserWidget extends ConsumerStatefulWidget {
  final String userId;

  // Construct.
  const FollowUserWidget({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends ConsumerState<FollowUserWidget> {
  late final userFollowProvider = FollowProvider(
    (ref) => FollowNotifier(FollowState.initial.copyWith(
      userId: widget.userId,
    )),
  );
  late final followNotifier = ref.watch(userFollowProvider.notifier);
  FollowStatusModel? _followStatus;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _getFollowState();
    });
    super.initState();
  }

  Future<void> _getFollowState() async {
    if (widget.userId == ConversationState.self.id) return;
    final result = await followNotifier.getFollowStatus(widget.userId);

    //? Update this value if it works fine.
    if (mounted) {
      setState(() {
        _followStatus = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WayaFutureSubscriber(
      future: UserResource.getUserDetails(widget.userId),
      suspense: (context) => const SizedBox(),
      builder: (context, data) => data == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => WayaNav.toNamed(WayaAppRoutes.getProfileRoute(data.$1.id, 'profile')),
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

                              //? Only show this when the user in question is not
                              //? the current user.
                              if (widget.userId != ConversationState.self.id)
                                GestureDetector(
                                  onTap: _followStatus == null
                                      ? null
                                      : () async {
                                          //? If this user is following this one.
                                          if (_followStatus!.isUserFollowing) {
                                            await followNotifier.unfollowUser(data.$1.id);
                                          }

                                          //? Since I am not yet following this user...
                                          else {
                                            await followNotifier.followUser(data.$1.id);
                                          }

                                          //? Update this.
                                          await _getFollowState();
                                        },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20.w),
                                    padding: REdgeInsets.symmetric(vertical: 5.dg, horizontal: 10.dg),
                                    decoration: BoxDecoration(
                                      border: _followStatus?.isUserFollowing == true
                                          ? Border.all(
                                              color: theme.colorScheme.primary,
                                              width: 1.5,
                                            )
                                          : null,
                                      color: _followStatus == null
                                          ? theme.colorScheme.greyColor200
                                          : _followStatus!.isUserFollowing
                                              ? theme.colorScheme.white
                                              : theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(7.r),
                                    ),
                                    child: Text(
                                      _followStatus == null
                                          ? "Loading"
                                          : _followStatus!.isUserFollowing
                                              ? "Following"
                                              : "Follow",
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: _followStatus == null
                                            ? theme.colorScheme.greyColor500
                                            : _followStatus!.isUserFollowing
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
                              fontSize: 12.sp,
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
                            fontSize: 12.sp,
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
