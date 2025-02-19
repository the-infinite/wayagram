import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/group/widget/group_widget.dart';
import 'package:wayagram/features/pages/data/model/pages_users_follow_model.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class PagesFeedWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final bool isFollow;
  final bool isRecommended;
  final bool isManaged;
  const PagesFeedWidget(
      {super.key,
      this.isExpanded = false,
      this.isFollow = false,
      this.isManaged = false,
      this.isRecommended = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PagesFeedWidgetState();
}

class _PagesFeedWidgetState extends ConsumerState<PagesFeedWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getPagesUserFollows();
      ref.read(createPageProvider.notifier).getRecommendedPages();
      ref.read(createPageProvider.notifier).getAllPages(ConversationState.self.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(createPageProvider);

    // followed pages
    List<PagesUsersFollowDocs>? followedPages = widget.isExpanded
        ? state.pagesUsersFollow
        : state.pagesUsersFollow
            ?.sublist(0, min(state.pagesUsersFollow!.length, 2));

    // recommended groups
    List<PagesUsersFollowDocs>? recommendedPages = widget.isExpanded
        ? state.recommendedPages
        : state.recommendedPages
            ?.sublist(0, min(state.recommendedPages!.length, 2));

    // my groups
    List<PagesUsersFollowDocs>? myPages = widget.isExpanded
        ? state.myPages
        : state.myPages?.sublist(0, min(state.myPages!.length, 2));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //>  Show only two among the pages that i am managing
        if (widget.isManaged && myPages!.isNotEmpty) ...[
          Text(
            "My Pages",
            style: wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myPages.length,
              itemBuilder: (context, index) {
                final page = myPages[index];
                return GroupWidget(
                  isWhite: true,
                 name: '${page.name?.capitalizeFirst}',
                  desc: '${page.description?.capitalizeFirst}',
                  image: '${page.coverImage}',
                  count:
                      '${page.followerCount} ${page.followerCount == 0 || page.followerCount == 1 ? 'Follower' : 'Followers'}',
                  buttonText: 'Following',
                  onTap: () {},
                  chk: false,
                );
              }),
        ],
        //> Show only if i have followed some pages
        if (widget.isFollow && followedPages!.isNotEmpty) ...[
          Text(
            "Pages you follow",
            style: wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: followedPages.length,
              itemBuilder: (context, index) {
                final page = followedPages[index];
                return GroupWidget(
                   isWhite: true,
                  name: '${page.name?.capitalizeFirst}',
                  desc: '${page.description?.capitalizeFirst}',
                  image: '${page.coverImage}',
                  count:
                      '${page.followerCount} ${page.followerCount == 0 || page.followerCount == 1 ? 'Follower' : 'Followers'}',
                  buttonText: 'Following',
                  onTap: () {},
                  chk: true,
                );
              }),
        ],
        //> Recommended groups
        if (widget.isRecommended && recommendedPages!.isNotEmpty) ...[
          Text(
            "Recommended for you",
            style: wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recommendedPages.length,
              itemBuilder: (context, index) {
                final page = recommendedPages[index];
                return GroupWidget(
                   isWhite: true,
                    name: '${page.name?.capitalizeFirst}',
                  desc: '${page.description?.capitalizeFirst}',
                  image: '${page.coverImage}',
                  count:
                      '${page.followerCount} ${page.followerCount == 0 || page.followerCount == 1 ? 'Follower' : 'Followers'}',
                  buttonText: 'Join',
                  isRecommended: true,
                  onTap: () {},
                  chk: true,
                );
              }),
        ],
      ],
    );
  }
}
