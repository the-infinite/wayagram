import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';
import 'package:gap/gap.dart';

class SharedPosts extends ConsumerStatefulWidget {
  final bool isExpanded;
  const SharedPosts({super.key, this.isExpanded = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedPostState();
}

class _SharedPostState extends ConsumerState<SharedPosts> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(servicesProvider.notifier).getEngagedPost();
      ref.read(exploreVmProvider.notifier).getUserFeeds();
      ref.read(servicesProvider.notifier).fetchPostsByCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(servicesProvider);
    final exploreNotifier = ref.watch(exploreVmProvider);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? If there are categorized posts to show.
        if (state.categorizedPosts.isNotEmpty && widget.isExpanded) ...[
          for (var category in state.categorizedPosts) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
              child: Text(
                category.categoryName,
                style: wayaTheme.textTheme.descriptionStyle,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: category.posts.length,
              itemBuilder: (context, index) => WayaPostWidget(
                data: category.posts[index],
                index: index,
              ),
            ),
            if (category.hasNextPage)
              WayaButton(
                callback: () {
                  ref
                      .read(servicesProvider.notifier)
                      .loadMorePosts(category.categoryName);
                },
                text: 'See More Post',
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor200),
                height: 36,
                color: wayaTheme.colorScheme.transparent,
                textColor: wayaTheme.colorScheme.customPrimary,
              )
          ],
        ],

        //? Just if there are some top rated posts to show.
        if (exploreNotifier.posts.isNotEmpty) ...[
          Text(
            "Recommended Posts",
            style: widget.isExpanded
                ? wayaTheme.textTheme.descriptionStyle.copyWith(
                    color: wayaTheme.colorScheme.greyColor700,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  )
                : wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.isExpanded
                ? exploreNotifier.posts.length
                : min(exploreNotifier.posts.length, 3),
            itemBuilder: (context, index) => WayaPostWidget(
              data: exploreNotifier.posts[index],
              index: index,
            ),
          ),
        ],
      ],
    );
  }
}
