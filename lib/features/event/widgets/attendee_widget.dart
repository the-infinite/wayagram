import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/event/data/model/event_attendee_response_model.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';

class AttendeeWidget extends ConsumerStatefulWidget {
  final Doc attendee;
  const AttendeeWidget({super.key, required this.attendee});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AttendeeWidgetState();
}

class _AttendeeWidgetState extends ConsumerState<AttendeeWidget> {
  late bool following;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      fetchFollowStatus();
    });
    following = false;
    super.initState();
  }

  void fetchFollowStatus() async {
    final FollowStatus? followStatus = await ref
        .read(eventVmProvider.notifier)
        .getFollow(widget.attendee.userId);
    setState(() {
      following = followStatus!.isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final state = ref.watch(eventVmProvider);
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WayaDp(
                          image: widget.attendee.profilePicture ?? '',
                          radius: 28,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150.w,
                              child: Text(
                                  "${widget.attendee.firstName.capitalizeFirst} ${widget.attendee.lastName.capitalizeFirst}",
                                  overflow: TextOverflow.ellipsis,
                                  style: wayaTheme.textTheme.bodyMedium),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            SizedBox(
                              width: 150.w,
                              child: Text(
                                widget.attendee.username,
                                style: wayaTheme.textTheme.hintStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    if (widget.attendee.userId != state.userId) ...[
                      if (!following)
                        SizedBox(
                          width: 60,
                          child: WayaButton(
                            callback: () async {
                              setState(() {
                                following = true;
                              });
                              ref
                                  .read(eventVmProvider.notifier)
                                  .follow(widget.attendee.userId);
                              fetchFollowStatus();
                            },
                            text: 'Follow',
                            height: 30,
                            textStyle: wayaTheme.textTheme.hintStyle
                                .wayaCopyWith(
                                    color: wayaTheme.colorScheme.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                            radius: 6,
                          ),
                        ),
                      if (following)
                        SizedBox(
                          width: 80,
                          child: WayaButton(
                            callback: () async {
                              setState(() {
                                following = false;
                              });
                              ref
                                  .read(eventVmProvider.notifier)
                                  .unfollow(widget.attendee.userId);
                              fetchFollowStatus();
                            },
                            text: 'Following',
                            textColor: wayaTheme.colorScheme.customPrimary,
                            height: 30,
                            textStyle: wayaTheme.textTheme.hintStyle
                                .wayaCopyWith(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                            radius: 5,
                            color: wayaTheme.colorScheme.transparent,
                            border: Border.all(
                                width: 1,
                                color: wayaTheme.colorScheme.customPrimary),
                          ),
                        ),
                    ] else ...[
                      SizedBox.shrink()
                    ]
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.attendee.bio ?? '',
                  style: wayaTheme.textTheme.hintStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
