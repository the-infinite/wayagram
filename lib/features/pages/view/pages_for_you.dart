import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

import '../../../assetsgen/assets.gen.dart';
import '../../explore/widgets/grouped_widget_header.dart';
import '../../post/view/create_post.dart';
import '../../shop/widgets/empty_state.dart';

class PagesForYou extends ConsumerStatefulWidget {
  const PagesForYou({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PagesForYouState();
}

class _PagesForYouState extends ConsumerState<PagesForYou>
    with SingleTickerProviderStateMixin {
  late final notifier = ref.watch(createPageProvider.notifier);
  final _wayaLocalDataSource = WayaLocalDataSource();

  int like = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      myPageNotifier.getCreatedPages();
      notifier.getRecommendedPages();
      notifier.getAllPosts(_wayaLocalDataSource.getUserId());
      notifier.getPopularPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewPage = ref.watch(createPageProvider);

    return ValueListenableBuilder(
      valueListenable: myPageNotifier,
      builder: (context, redraws, _) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // @the-infinite -- I feel like if am not following any page,
          // i should not be seeing that empty state
          // it makes the UI look noisy
          if (viewPage.pagePopularPostDocs?.isEmpty ?? true) ...[
            SizedBox.shrink()
          ] else ...[
            Text(
              'Based on pages you follow',
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: WayaColors.greyColor700,
              ),
            ),

            // Some space.
            Gap(10.h),

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewPage.pagePopularPostDocs?.length ?? 0,
              itemBuilder: (_, index) => WayaPostWidget(
                data: viewPage.pagePopularPostDocs![index],
                index: index,
              ),
            ),
            // Some space.
            Gap(25.h),
          ],

          //? Suggestions.
          GroupedWidgetHeader(
            onTap: () {
              WayaNav.toNamed('/suggestion');
            },
            subTitle: 'Connect with friends and communities',
            title: 'Suggestions',
          ),
          const Gap(25),
          if (viewPage.recommendedPages?.isEmpty ?? true)
            ActivityLogsEmptyState(text: 'No pages to recommend just yet')
          else
            SizedBox(
              height: 190,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: viewPage.recommendedPages?.length ?? 0,
                itemBuilder: (_, index) => SinglePageWidget(
                  page: viewPage.recommendedPages![index],
                  index: index,
                  vertical: true,
                ),
              ),
            ),
          Gap(20),
          if (viewPage.pagePopularPostDocs?.isEmpty ?? true)
            //  - @the-infinite, I removed this PostEmptyState(),
            // because i think the UI looks better without it,
            // you can add it back if you think it will be better to have it
            SizedBox.shrink()
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewPage.pagePopularPostDocs?.length ?? 0,
              itemBuilder: (_, index) => WayaPostWidget(
                data: viewPage.pagePopularPostDocs![index],
                index: index,
              ),
            ),
        ],
      ),
    );
  }
}

class PostEmptyState extends StatelessWidget {
  const PostEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              WayaNav.toNamed(CreatePost.route);
            },
            buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(
                  wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created any post yet"),
      ),
    );
  }
}

class PageEmptyState extends StatelessWidget {
  const PageEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              // WayaNav.toNamed('/createGroup');
            },
            //buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(
                  wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You don't have suggestions yet"),
      ),
    );
  }
}
