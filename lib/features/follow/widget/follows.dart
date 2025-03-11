import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/follow/widget/follow_relationship.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';

class FollowersDataView extends ConsumerWidget {
  final FollowProvider provider;
  final WayaObservableScrollController handler;

  //? This is fine.
  const FollowersDataView({
    super.key,
    required this.provider,
    required this.handler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //? The data we happen to need.
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    //? The body of the page in question.
    return WayaPaginatedListView(
      shouldFetch: !state.isLoadingFollowers,
      isAtEnd: !state.followersHasNextPage,
      nextPage: state.followersPage,
      itemCount: state.followers.length,
      handler: handler,
      getPage: (page) => notifier.getFollowersOf(state.userId),
      builder: (context, index) => FollowRelationshipWidget(
        index: index,
        data: state.followers[index],
        notifier: notifier,
      ),
    );
  }
}

class FollowingDataView extends ConsumerWidget {
  final FollowProvider provider;
  final WayaObservableScrollController handler;

  //? This is fine.
  const FollowingDataView({
    super.key,
    required this.provider,
    required this.handler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //? The data we happen to need.
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    //? The body of the page in question.
    return WayaPaginatedListView(
      shouldFetch: !state.isLoadingFollowing,
      isAtEnd: !state.followingHasNextPage,
      nextPage: state.followingPage,
      itemCount: state.following.length,
      handler: handler,
      getPage: (page) => notifier.getUsersFollowing(state.userId),
      builder: (context, index) => FollowRelationshipWidget(
        index: index,
        data: state.following[index],
        notifier: notifier,
      ),
    );
  }
}
