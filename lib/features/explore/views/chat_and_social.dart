import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/search/search.dart';
import 'package:wayagram/features/explore/widgets/tabbed_feed.dart';
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
      body: TabbedFeedWidget(),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: WayaButton(
          callback: () => WayaUtils.showModalSheet(context, child: CreateSheet()),
          height: 50,
          centerWidget: Center(
            child: Icon(
              Icons.add,
              color: wayaTheme.colorScheme.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
