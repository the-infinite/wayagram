import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/shared/components/engagement_range.dart';

class EventWidget extends ConsumerWidget {
  final EventDoc event;
  const EventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    final bool isMyEvent = event.userId == ConversationState.self.id;
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: wayaTheme.colorScheme.greyColor200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaImage(
                  imageUrl: event.image,
                  height: 180.h,
                  width: double.infinity,
                  radius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 220.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: wayaTheme.textTheme.bodyMedium,
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                // if (event.location == 'physical')
                                SizedBox(
                                  width: 250.w,
                                  child: Text(
                                    "${event.locationAddress.capitalizeFirst} by ${WayaHelpers.format24HRSToAPM(event.startTime)}",
                                    style: wayaTheme.textTheme.hintStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // if (event.location == 'virtual')
                                //   GestureDetector(
                                //     onTap: () {
                                //       Clipboard.setData(ClipboardData(
                                //           text: event.locationAddress));
                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(
                                //         SnackBar(
                                //             content: Text(
                                //                 "Link copied to clipboard")),
                                //       );
                                //     },
                                //     child: Text("Copy Link",
                                //         style: wayaTheme.textTheme.bodySmall!
                                //             .wayaCopyWith(
                                //                 color: wayaTheme
                                //                     .colorScheme.customPrimary,
                                //                 fontSize: 11,
                                //                 fontWeight: FontWeight.w600)),
                                //   ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 68,
                            child: WayaButton(
                              callback: () {},
                              text: event.eventStatus,
                              textColor: wayaTheme.colorScheme.pending,
                              height: 30,
                              color: wayaTheme.colorScheme.pending50,
                              textStyle: wayaTheme.textTheme.hintStyle.copyWith(
                                  color: wayaTheme.colorScheme.pending,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500),
                              radius: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      EngagementRange(
                          bottomLeft: event.location.capitalizeFirst,
                          bottomRight: event.maxCapacity == null ||
                                  event.maxCapacity == 0
                              ? "Unlimited"
                              : "${event.maxCapacity! - event.noOfAttendees} Ticket Left",
                          range: event.maxCapacity == null ||
                                  event.maxCapacity == 0
                              ? 0
                              : (event.maxCapacity! -
                                      (event.maxCapacity! -
                                          event.noOfAttendees)) /
                                  100),
                      SizedBox(
                        height: 6.h,
                      ),
                      WayaButton(
                        callback: () => WayaNav.toNamed(
                            WayaAppRoutes.getEventDetailsScreen(event.id)),
                        color: wayaTheme.colorScheme.primary50,
                        textColor: wayaTheme.colorScheme.customPrimary,
                        text: isMyEvent ? "Manage Event" : "View Event",
                      ),
                    ],
                  ),
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
