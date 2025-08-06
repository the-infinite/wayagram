import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/follow/vm/follow_notifier.dart';
import 'package:wayagram/shared/features/user/resource/user_resource.dart';
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
  late final userFollowProvider = userFollowersProvider(widget.userId);
  late final followNotifier = ref.watch(userFollowProvider.notifier);
  FollowStatusModel? _followStatus;
  CachedUserDataTuple? _userInfo;
  bool _isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await UserResource.getUserDetails(widget.userId);
      final followState = await followNotifier.getFollowStatus(widget.userId);

      //? This is fair.
      if (mounted) {
        setState(
          () {
            _followStatus = followState;
            _userInfo = user;
          },
        );
      }
    });
    super.initState();
  }

  Future<void> _getFollowState() async {
    if (_isLoading) return;

    _isLoading = true;
    final result = await followNotifier.getFollowStatus(widget.userId);

    if (mounted) {
      setState(() {
        _followStatus = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //? This is fine.
    return VisibilityDetector(
      key: Key('follow_user_widget_${widget.userId}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= 1) {
          _getFollowState();
        }
      },
      child: _userInfo == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => WayaNav.toNamed(
                    WayaAppRoutes.getProfileRoute(_userInfo!.$1.id, 'profile')),
                borderRadius: BorderRadius.circular(12.r),
                splashColor: theme.colorScheme.primary.withAlpha(30),
                focusColor:
                    const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
                highlightColor: theme.colorScheme.primary.withAlpha(30),
                child: Card(
                  elevation: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 0, right: 0),
                          leading: ChatProfilePicture(
                            user: _userInfo!.$1,
                            radius: 20.h,
                            showActive: false,
                          ),
                          horizontalTitleGap: 5.w,
                          title: Row(
                            children: [
                              //? The fullname of the user in question.
                              Expanded(
                                child: Text(
                                  _userInfo!.$1.fullname,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),

                              // Infinite space.
                              SizedBox(width: 10.w),

                              //? Only show this when the user in question is not
                              //? the current user.
                              if (widget.userId != ConversationState.self.id)
                                GestureDetector(
                                  onTap: _followStatus == null
                                      ? null
                                      : () async {
                                          //? If this user is following this one.
                                          if (_followStatus!.isUserFollowing) {
                                            await myFollowProvider
                                                .unfollowUser(_userInfo!.$1.id);
                                          }

                                          //? Since I am not yet following this user...
                                          else {
                                            await myFollowProvider
                                                .followUser(_userInfo!.$1.id);
                                          }

                                          //? Update this.
                                          await _getFollowState();
                                        },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20.w),
                                    padding: REdgeInsets.symmetric(
                                        vertical: 5.dg, horizontal: 10.dg),
                                    decoration: BoxDecoration(
                                      border: _followStatus?.isUserFollowing ==
                                              true
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
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
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
                            _userInfo!.$2.username != null
                                ? '@${_userInfo!.$2.username}'
                                : 'ID: ${_userInfo!.$1.id}',
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.greyColor500,
                            ),
                          ),
                        ),
                        //? This is the user's bio.
                        Text(
                          _userInfo!.$2.bio ?? '',
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
