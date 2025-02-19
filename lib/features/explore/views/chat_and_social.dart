import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/search/search.dart';
import 'package:wayagram/features/explore/views/display_feed.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/shared/features/posts/shared_posts.dart';
import 'package:wayagram/shared/features/moments/shared_moments.dart';
import 'package:wayagram/shared/features/pages/widgets/pages_feed_widget.dart';
import 'package:wayagram/shared/features/chat/widget/conversation.dart';
import 'package:wayagram/shared/features/groups/widgets/groups_feed_widget.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/shared/features/events/shared_event.dart';
import 'package:wayagram/features/explore/bottom_sheet/create_sheet.dart';

class ChatAndSocial extends ConsumerStatefulWidget {
  static const route = "/chat-and-social";
  const ChatAndSocial({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatAndSocialState();
}

class _ChatAndSocialState extends ConsumerState<ChatAndSocial> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: "Chat & Socials",
         backgroundColor: wayaTheme.colorScheme.scaffoldColor,
        appBarTrailing: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => WayaNav.toNamed(SearchView.route),
                child: SvgPicture.asset(WayaAssets.icons.searchIconFeed.path),
              ),
              const Gap(6),
              WayaDp(
                onTap: () {
                  WayaNav.toNamed('/general-settings');
                },
                radius: 18,
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
              "Top Moments",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            SharedMoments(),
            GroupedWidgetHeader(
                onTap: () {
                  WayaNav.toNamed(DisplayFeed.route);
                },
                subTitle: 'Based on your interests',
                title: 'Discover'),
            const Gap(25),
            SharedPosts(),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {
                  WayaNav.toNamed('/pages');
                },
                subTitle: 'View and manage pages',
                title: 'Pages'),
            const Gap(25),
            PagesFeedWidget(
              isFollow: true,
              isManaged: true,
              isRecommended: true,
            ),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {
                  WayaNav.toNamed('/groups');
                },
                subTitle: 'View and manage groups',
                title: 'Groups'),
            const Gap(25),
            GroupsFeedWidget(
              isGroupIJoined: true,
              isMyGroups: true,
              isRecommended: true,
            ),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {
                  WayaNav.toNamed(EventView.route);
                },
                subTitle: 'Join upcoming activities',
                title: 'Events'),
            const Gap(25),
            SharedEvent(
              isChatAndSocial: true,
            ),
            const Gap(25),
            GroupedWidgetHeader(
              onTap: () {
                Navigator.pushNamed(context, BottomView.route, arguments: 4);
              },
              subTitle: 'Connect with friends and communities',
              title: 'Chats & Calls',
            ),
            const Gap(25),
            const ConversationFeedWidget(isExpanded: false),
          ],
        ),

        // floating button
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: WayaButton(
            callback: () async {
              // show create action modal
              await WayaUtils.showModalSheet(context, child: CreateSheet());
            },
            height: 50,
            centerWidget: Center(
              child: Icon(
                Icons.add,
                color: wayaTheme.colorScheme.white,
                size: 40,
              ),
            ),
          ),
        ));
  }
}
