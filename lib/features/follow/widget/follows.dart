import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/explore/search/widgets/user_widget.dart';
import 'package:wayagram/features/follow/widget/follow_relationship.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
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
      builder: (context, index) => FollowUserWidget(
        userId: state.followers[index].otherUserId,
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
      builder: (context, index) => FollowUserWidget(
        userId: state.following[index].otherUserId,
      ),
    );
  }
}

class MyFollowersDataView extends StatelessWidget {
  final WayaObservableScrollController handler;

  //? This is fine.
  const MyFollowersDataView({
    super.key,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    //? The body of the page in question.
    return ValueListenableBuilder(
      valueListenable: myFollowProvider,
      builder: (context, state, _) => WayaPaginatedListView(
        shouldFetch: !state.isLoadingFollowers,
        isAtEnd: !state.followersHasNextPage,
        nextPage: state.followersPage,
        itemCount: state.followers.length,
        handler: handler,
        getPage: (page) => myFollowProvider.getFollowersOf(state.userId),
        builder: (context, index) => FollowRelationshipWidget(
          index: index,
          data: state.followers[index],
        ),
      ),
    );
  }
}

class MyFollowingDataView extends StatelessWidget {
  final WayaObservableScrollController handler;

  //? This is fine.
  const MyFollowingDataView({
    super.key,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    //? The body of the page in question.
    return ValueListenableBuilder(
      valueListenable: myFollowProvider,
      builder: (context, state, _) => WayaPaginatedListView(
        shouldFetch: !state.isLoadingFollowing,
        isAtEnd: !state.followingHasNextPage,
        nextPage: state.followingPage,
        itemCount: state.following.length,
        handler: handler,
        getPage: (page) => myFollowProvider.getUsersFollowing(state.userId),
        builder: (context, index) => FollowRelationshipWidget(
          index: index,
          data: state.following[index],
        ),
      ),
    );
  }
}
