import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/views/display_feed.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/shared/features/moments/shared_moments.dart';
import 'package:wayagram/shared/features/profile/view/pages.dart';
import 'package:wayagram/shared/features/chat/widget/conversation.dart';
import 'package:wayagram/shared/features/profile/view/groups.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/shared/features/events/shared_event.dart';
import 'package:wayagram/shared/features/profile/shared_posts.dart';
import 'package:wayagram/shared/features/profile/view/polls.dart';

class TabbedFeedWidget extends StatefulWidget {
  const TabbedFeedWidget({super.key});

  @override
  State<TabbedFeedWidget> createState() => _TabbedFeedWidgetState();
}

class _TabbedFeedWidgetState extends State<TabbedFeedWidget> {
  final updater = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return this.
    return ValueListenableBuilder(
      valueListenable: updater,
      builder: (context, selectedTab, _) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Some space.
          Gap(10.h),

          //? Top moments.
          Text(
            "Top Moments",
            style: wayaTheme.textTheme.bodyMedium,
          ),

          // Some space.
          Gap(10.h),

          //? Shared moments.
          SharedMoments(),

          //? Now, for our tab buttons.
          SizedBox(
            height: 35.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.w,
                children: [
                  //? For all.
                  WayaCheckButton(
                    onTap: () => updater.value = 8,
                    isSelected: selectedTab == 8,
                    hasBackground: true,
                    isExpanded: false,
                    text: "All",
                  ),

                  //? For posts.
                  WayaCheckButton(
                    onTap: () => updater.value = 0,
                    isSelected: selectedTab == 0,
                    hasBackground: true,
                    isExpanded: false,
                    text: "Posts",
                  ),

                  //? For pages.
                  WayaCheckButton(
                    onTap: () => updater.value = 1,
                    isSelected: selectedTab == 1,
                    hasBackground: true,
                    isExpanded: false,
                    fontSize: 14.sp,
                    text: "Pages",
                  ),

                  //? For groups.
                  WayaCheckButton(
                    onTap: () => updater.value = 2,
                    isSelected: selectedTab == 2,
                    hasBackground: true,
                    isExpanded: false,
                    fontSize: 14.sp,
                    text: "Groups",
                  ),

                  //? For events
                  WayaCheckButton(
                    onTap: () => updater.value = 7,
                    isSelected: selectedTab == 7,
                    hasBackground: true,
                    fontSize: 14.sp,
                    isExpanded: false,
                    text: "Polls",
                  ),

                  //? For events
                  WayaCheckButton(
                    onTap: () => updater.value = 3,
                    isSelected: selectedTab == 3,
                    hasBackground: true,
                    isExpanded: false,
                    fontSize: 14.sp,
                    text: "Events",
                  ),

                  //? For chats.
                  WayaCheckButton(
                    onTap: () => updater.value = 4,
                    isSelected: selectedTab == 4,
                    hasBackground: true,
                    isExpanded: false,
                    fontSize: 14.sp,
                    text: "Chats",
                  ),
                ],
              ),
            ),
          ),

          // Some space.
          Gap(15.h),

          //? Now, we switch the active view.
          ...switch (selectedTab) {
            0 => [
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed(DisplayFeed.route),
                  subTitle: 'Based on your interests',
                  title: 'Discover',
                ),

                // Some space.
                Gap(10.h),

                //? For posts.
                SharedPosts(
                  isExpanded: true,
                ),

                // Some space.
                Gap(25.h),
              ],
            1 => [
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed('/pages'),
                  subTitle: 'View and manage pages',
                  title: 'Pages',
                ),

                // For pages.
                Gap(10.h),

                //? For pages.
                PagesFeedWidget(
                  isFollow: true,
                  isManaged: true,
                  isRecommended: true,
                  isExpanded: true,
                ),

                //? For pages.
                Gap(25.h),
              ],
            2 => [
                //? Groups
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed('/groups'),
                  subTitle: 'View and manage groups',
                  title: 'Groups',
                ),

                // Some space.
                Gap(10.h),

                //? For groups
                GroupsFeedWidget(
                  isGroupIJoined: true,
                  isMyGroups: true,
                  isRecommended: true,
                  isExpanded: true,
                ),

                //? Some space.
                Gap(25.h),
              ],
            3 => [
                //? For events.
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed(EventView.route),
                  subTitle: 'Join upcoming activities',
                  title: 'Events',
                ),

                // Some space.
                Gap(10.h),

                //? For shared events.
                SharedEvent(
                  isChatAndSocial: true,
                  isExpanded: true,
                ),

                // Some space.
                Gap(25.h),
              ],
            7 => [
                //? For events.
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed('/poll-and-voting'),
                  subTitle: 'Join upcoming activities',
                  title: 'Polls and Voting',
                ),

                // Some space.
                Gap(10.h),

                PollsFeedWidget(
                  isExpanded: true,
                ),

                // Some space.
                Gap(25.h),
              ],
            8 => [
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed(DisplayFeed.route),
                  subTitle: 'Based on your interests',
                  title: 'Discover',
                ),

                // Some space.
                Gap(10.h),

                //? For posts.
                SharedPosts(
                  isExpanded: false,
                ),

                // Some space.
                Gap(25.h),

                //? For pages.
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed('/pages'),
                  subTitle: 'View and manage pages',
                  title: 'Pages',
                ),

                // For pages.
                Gap(10.h),

                //? For pages.
                PagesFeedWidget(
                  isFollow: true,
                  isManaged: true,
                  isRecommended: true,
                  isExpanded: false,
                ),

                // Some space.
                Gap(25.h),

                //? Groups
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed('/groups'),
                  subTitle: 'View and manage groups',
                  title: 'Groups',
                ),

                // Some space.
                Gap(10.h),

                //? For groups
                GroupsFeedWidget(
                  isGroupIJoined: true,
                  isMyGroups: true,
                  isRecommended: true,
                  isExpanded: false,
                ),

                // Some space.
                Gap(25.h),

                //? For events.
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed(EventView.route),
                  subTitle: 'Join upcoming activities',
                  title: 'Events',
                ),

                // Some space.
                Gap(10.h),

                //? For shared events.
                SharedEvent(
                  isChatAndSocial: true,
                  isExpanded: false,
                ),

                // Some space.
                Gap(25.h),

                //? For events.
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed('/poll-and-voting'),
                  subTitle: 'Join upcoming activities',
                  title: 'Polls and Voting',
                ),

                // Some space.
                Gap(10.h),

                PollsFeedWidget(
                  isExpanded: false,
                ),

                // Some space.
                Gap(25.h),
              ],
            _ => [
                //? Good one.
                GroupedWidgetHeader(
                  onTap: () => WayaNav.toNamed(BottomView.route, arguments: 4),
                  subTitle: 'Connect with friends and communities',
                  title: 'Chats & Calls',
                ),

                // Some space.
                Gap(10.h),

                //? For conversations.
                const ConversationFeedWidget(isExpanded: true),

                // Some space.
                Gap(25.h),
              ],
          },
        ],
      ),
    );
  }
}
