import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';

class PagesFeedWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final bool isFollow;
  final bool isRecommended;
  final bool isManaged;
  const PagesFeedWidget({
    super.key,
    this.isExpanded = false,
    this.isFollow = false,
    this.isManaged = false,
    this.isRecommended = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PagesFeedWidgetState();
}

class _PagesFeedWidgetState extends ConsumerState<PagesFeedWidget> {
  late final notifier = ref.read(createPageProvider.notifier);
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.getPagesUserFollows();
      notifier.getRecommendedPages();
      notifier.getAllPages(ConversationState.self.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(createPageProvider);

    // followed pages
    List<PageModel>? followedPages = widget.isExpanded
        ? state.pagesUsersFollow
        : state.pagesUsersFollow?.sublist(0, min(state.pagesUsersFollow!.length, 2));

    // recommended groups
    List<PageModel>? recommendedPages = widget.isExpanded
        ? state.recommendedPages
        : state.recommendedPages?.sublist(0, min(state.recommendedPages!.length, 2));

    // my groups
    List<PageModel>? myPages =
        widget.isExpanded ? state.myPages : state.myPages?.sublist(0, min(state.myPages!.length, 2));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //>  Show only two among the pages that i am managing
        if (widget.isManaged && myPages!.isNotEmpty) ...[
          Text(
            "My Pages",
            style: widget.isExpanded ? wayaTheme.textTheme.descriptionStyle : wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: myPages.length,
            itemBuilder: (context, index) => SinglePageWidget(
              page: myPages[index],
              index: index,
            ),
          ),
        ],
        //> Show only if i have followed some pages
        if (widget.isFollow && followedPages!.isNotEmpty) ...[
          Text(
            "Pages you follow",
            style: widget.isExpanded ? wayaTheme.textTheme.descriptionStyle : wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: followedPages.length,
            itemBuilder: (context, index) => SinglePageWidget(
              page: followedPages[index],
              index: index,
            ),
          ),
        ],
        //> Recommended groups
        if (widget.isRecommended && recommendedPages!.isNotEmpty) ...[
          Text(
            "Recommended for you",
            style: widget.isExpanded ? wayaTheme.textTheme.descriptionStyle : wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: recommendedPages.length,
            itemBuilder: (context, index) => SinglePageWidget(
              page: recommendedPages[index],
              index: index,
            ),
          ),
        ],
      ],
    );
  }
}
