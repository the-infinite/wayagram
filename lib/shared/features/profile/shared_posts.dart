import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:wayagram/features/post/model/post_reponse_model.dart';
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
      ref.read(servicesProvider.notifier).getEngagedPost();
      ref.read(servicesProvider.notifier).getPosts();
      ref.read(servicesProvider.notifier).fetchPostsByCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(servicesProvider);

    List<Post> posts = widget.isExpanded
        ? state.topPosts
        : state.topPosts.sublist(0, min(state.topPosts.length, 3));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
     

        //? If there are posts to show and this is full view...
        if (state.posts.isNotEmpty && widget.isExpanded) ...[
          Text(
            "Based on your Interest",
            style: wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return WayaPostWidget(
                data: posts[index],
                index: index,
              );
            },
          ),
        ],

        //? If there are categorized posts to show.
        if (state.categorizedPosts.isNotEmpty && widget.isExpanded) ...[
          for (var category in state.categorizedPosts) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
              child: Text(
                category.categoryName,
                style: TextStyle(
                    color: wayaTheme.colorScheme.greyColor600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: category.posts.length,
              itemBuilder: (context, index) {
                return WayaPostWidget(
                  data: category.posts[index],
                  index: index,
                );
              },
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
        if (state.topPosts.isNotEmpty) ...[
          Text(
            "Recommended For You",
            style: wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return WayaPostWidget(
                data: posts[index],
                index: index,
              );
            },
          ),
        ],
      ],
    );
  }
}
