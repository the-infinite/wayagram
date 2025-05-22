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
import 'package:wayagram/shared/features/moments/shared_moments.dart';
import 'package:wayagram/features/explore/search/search.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

class DisplayFeed extends ConsumerStatefulWidget {
  static const route = "/feed";
  const DisplayFeed({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DisplayFeedState();
}

class _DisplayFeedState extends ConsumerState<DisplayFeed> {
  final handler = WayaObservableScrollController();
  late final notifier = ref.read(exploreVmProvider.notifier);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchMore() async {
    await notifier.getUserFeeds();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(exploreVmProvider);

    print("wefwef length ${state.posts.length}");

    //? Return the view.
    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {
        if (!isPopping) return;
        notifier.reset();
      },
      child: WayaScaffold(
        isLoading: false,
        isScrollable: false,
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
        body: WayaObservableScrollView(
          handler: handler,
          shouldFetch: !state.isLoading,
          isAtEnd: !state.hasMore,
          scrollNotice: 80,
          onReachEnd: _fetchMore,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //? Some prefixed space.
              const Gap(10),

              //? THe shared moments section.
              Text(
                "Top Moments",
                style: wayaTheme.textTheme.descriptionStyle.copyWith(
                  color: wayaTheme.colorScheme.greyColor700,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Some space.
              Gap(10.h),

              //? Shared moments.
              SharedMoments(),

              // Some more space.
              Gap(10.h),

              //? Now for our posts.
              ...List.generate(
                state.posts.length,
                (index) => WayaPostWidget(
                  data: state.posts[index],
                  index: index,
                ),
              ),
            ],
          ),
        ),
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
