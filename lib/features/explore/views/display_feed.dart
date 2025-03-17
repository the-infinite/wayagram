import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/shared/features/events/shared_event.dart';
import 'package:wayagram/shared/features/profile/shared_posts.dart';
import 'package:wayagram/shared/features/moments/shared_moments.dart';
import 'package:wayagram/features/explore/search/search.dart';
import 'package:wayagram/shared/features/profile/view/polls.dart';

class DisplayFeed extends ConsumerStatefulWidget {
  static const route = "/feed";
  const DisplayFeed({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DisplayFeedState();
}

class _DisplayFeedState extends ConsumerState<DisplayFeed> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      ref.read(exploreVmProvider.notifier).getUserFeeds();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      title: "Discovery",
      appBarTrailing: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.w,
          children: [
            GestureDetector(
              onTap: () => WayaNav.toNamed(SearchView.route),
              child: SvgPicture.asset(
                WayaAssets.icons.searchIconFeed.path,
                height: 20.dg,
                width: 20.dg,
              ),
            ),
            WayaDp(
              onTap: () {
                WayaNav.toNamed('/general-settings');
              },
              radius: 18.r,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Text(
            "Based on your follows",
            style: wayaTheme.textTheme.descriptionStyle,
          ),
          const Gap(10),
          SharedMoments(),
          const Gap(10),
          SharedPosts(
            isExpanded: true,
          ),
          const Gap(25),
          PollsFeedWidget(
            isExpanded: true,
          ),
          const Gap(25),
          SharedEvent()
        ],
      ),
    );
  }

  Widget buildEmptyFeed({required BuildContext context}) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Text(
        "No Feed",
        style: wayaTheme.textTheme.bodyMedium,
      ),
    );
  }
}
