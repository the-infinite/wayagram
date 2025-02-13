import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/shared/features/events/shared_event.dart';
import 'package:wayagram/shared/features/posts/shared_posts.dart';

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
            children: [
              SvgPicture.asset(WayaAssets.icons.searchIconFeed.path),
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
            SharedPosts(isExpanded: true,),
            const Gap(25),
            SharedEvent()
          ],
        ));
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
