import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/search/widgets/user_widget.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/follow/view/suggested_friends.dart';

class SharedSuggestedFriendsWidget extends ConsumerWidget {
  final bool isExpanded;
  final WayaObservableScrollController handler;

  //? This is fine too.
  const SharedSuggestedFriendsWidget({
    super.key,
    required this.isExpanded,
    required this.handler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //? Return our component.
    return ValueListenableBuilder(
      valueListenable: myFollowProvider,
      builder: (context, state, _) {
        //? If this is empty.
        if (state.suggestions.isEmpty) {
          return const SizedBox.shrink();
        }

        //? If this is expanded, make this paginate-able.
        if (isExpanded) {
          return WayaObservableScrollView(
            shouldFetch: false,
            isAtEnd: false,
            handler: handler,
            padding: EdgeInsets.only(top: 20.h),
            onReachEnd: myFollowProvider.getFollowSuggestions,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                state.suggestions.length,
                (index) => FollowUserWidget(
                  userId: state.suggestions[index].id,
                ),
              ),
            ),
          );
        }

        //? If this is not empty.
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 10.h,
          children: [
            //? First, the section header.
            GroupedWidgetHeader(
              onTap: () => WayaNav.to(const SuggestedFriendsScreen(),
                  transition: WayaTransition.rightToLeftWithFade),
              subTitle: 'Follow your friends and meet new people',
              title: 'Suggested Friends',
            ),

            //? Second, let us show the actual user cards.
            ...List.generate(
              min(state.suggestions.length, 3),
              (index) => FollowUserWidget(
                userId: state.suggestions[index].id,
              ),
            ),
          ],
        );
      },
    );
  }
}
