import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/explore/search/widgets/user_widget.dart';
import 'package:wayagram/features/follow/widget/follow_relationship.dart';
import 'package:wayagram/features/follow/widget/invitation_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';

class FollowersDataView extends ConsumerWidget {
  final FollowProvider provider;
  final WayaObservableScrollController handler;
  final String userId;

  //? This is fine.
  const FollowersDataView({
    super.key,
    required this.provider,
    required this.handler,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //? The data we happen to need.
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    //? The body of the page in question.
    return WayaPaginatedListView(
      isEmpty: state.hasLoadedFollowers && state.followers.isEmpty,
      shouldFetch: !state.isLoadingFollowers,
      isAtEnd: !state.followersHasNextPage,
      nextPage: state.followersPage,
      itemCount: state.followers.length,
      handler: handler,
      getPage: (page) => notifier.getFollowersOf(state.userId),
      whenEmpty: Center(
        child: EmptyState(
          assetImage: WayaAssets.icons.emptyState.svg(),
          message: "No followers yet",
        ),
      ),
      builder: (context, index) => FollowUserWidget(
        userId: state.followers[index].otherFollowerId(userId),
      ),
    );
  }
}

class FollowingDataView extends ConsumerWidget {
  final FollowProvider provider;
  final WayaObservableScrollController handler;
  final String userId;

  //? This is fine.
  const FollowingDataView({
    super.key,
    required this.provider,
    required this.handler,
    required this.userId,
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
      isEmpty: state.hasLoadedFollowing && state.following.isEmpty,
      handler: handler,
      getPage: (page) => notifier.getUsersFollowing(state.userId),
      whenEmpty: Center(
        child: EmptyState(
          assetImage: WayaAssets.icons.emptyState.svg(),
          message: "Nobody is following yet",
        ),
      ),
      builder: (context, index) => FollowUserWidget(
        userId: state.following[index].otherFollowerId(userId),
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
        isEmpty: state.hasLoadedFollowers && state.followers.isEmpty,
        nextPage: state.followersPage,
        itemCount: state.followers.length,
        handler: handler,
        getPage: (page) => myFollowProvider.getFollowersOf(),
        whenEmpty: Center(
          child: EmptyState(
            assetImage: WayaAssets.icons.emptyState.svg(),
            message: "You do not have any followers yet",
          ),
        ),
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
        isEmpty: state.hasLoadedFollowing && state.following.isEmpty,
        shouldFetch: !state.isLoadingFollowing,
        isAtEnd: !state.followingHasNextPage,
        nextPage: state.followingPage,
        itemCount: state.following.length,
        handler: handler,
        getPage: (page) => myFollowProvider.getUsersFollowing(),
        whenEmpty: Center(
          child: EmptyState(
            assetImage: WayaAssets.icons.emptyState.svg(),
            message: "You are not following anyone yet",
          ),
        ),
        builder: (context, index) => FollowRelationshipWidget(
          index: index,
          data: state.following[index],
        ),
      ),
    );
  }
}

class MyInvitationDataView extends StatelessWidget {
  final WayaObservableScrollController handler;

  //? This is fine.
  const MyInvitationDataView({
    super.key,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    //? The body of the page in question.
    return ValueListenableBuilder(
      valueListenable: myFollowProvider,
      builder: (context, state, _) => WayaPaginatedListView(
        isEmpty: state.hasLoadedInvitation && state.invitation.isEmpty,
        shouldFetch: !state.isLoadingInvitation,
        isAtEnd: !state.followersHasNextPage,
        nextPage: state.invitationPage,
        itemCount: state.invitation.length,
        handler: handler,
        getPage: (page) => myFollowProvider.getInvitationOf(),
        whenEmpty: Center(
          child: EmptyState(
            assetImage: WayaAssets.icons.emptyState.svg(),
            message: "You do not have any invitation yet",
          ),
        ),
        builder: (context, index) => InvitationWidget(
          index: index,
          data: state.invitation[index],
        ),
      ),
    );
  }
}
