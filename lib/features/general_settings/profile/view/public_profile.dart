// ignore_for_file: deprecated_member_use_from_same_package, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/block.dart';
import 'package:wayagram/features/chat/modals/group/mute.dart';
import 'package:wayagram/features/chat/modals/report.dart';
import 'package:wayagram/features/chat/modals/unblock.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/donation/widget/manage_donation_widget.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/features/pages/state/page_state.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';
import 'package:wayagram/shared/cache/chat.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';
import 'package:wayagram/shared/features/profile/vm/donation.dart';
import 'package:wayagram/shared/features/profile/vm/poll.dart';
import 'package:wayagram/shared/features/profile/vm/product.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';
import 'package:wayagram/shared/features/profile/vm/default.dart';
import 'package:wayagram/shared/features/profile/vm/event.dart';
import 'package:wayagram/shared/features/profile/vm/groups.dart';
import 'package:wayagram/shared/features/profile/vm/pages.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';
import 'package:wayagram/shared/features/profile/widget/poll.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class UsersProfilePage extends ConsumerStatefulWidget {
  final CachedUserDataTuple data;
  final String source;

  // Construct.
  const UsersProfilePage({
    super.key,
    required this.data,
    required this.source,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<UsersProfilePage> {
  late final userFollowProvider = userFollowersProvider(widget.data.$1.id);
  late final userPostsProvider = otherUserPostsProvider(widget.data.$1.id);
  late final postNotifier = ref.read(userPostsProvider.notifier);
  late final followNotifier = ref.read(userFollowProvider.notifier);
  late final eventNotifier =
      ref.read(userEventsProvider(widget.data.$1.id).notifier);
  late final groupsNotifier =
      ref.read(userGroupsProvider(widget.data.$1.id).notifier);
  late final pagesNotifier =
      ref.read(userPagesProvider(widget.data.$1.id).notifier);
  late final pollsNotifier =
      ref.read(userPollsProvider(widget.data.$1.id).notifier);
  late final donationsNotifier =
      ref.read(userDonationsProvider(widget.data.$1.id).notifier);
  late final productsNotifier =
      ref.read(userProductsProvider(widget.data.$1.id).notifier);
  late final conversationNotifier = ref.read(conversationProvider.notifier);

  final scrollHandler = WayaObservableScrollController();
  final _pageController = ValueNotifier(0);
  final _tabController = ExpandedTabController();
  FollowStatusModel? _followStatus;

  Future<void> _getFollowState() async {
    if (widget.data.$1.id == ConversationState.self.id) return;
    final result = await myFollowProvider.getFollowStatus(widget.data.$1.id);

    //? Update this value if it works fine.
    if (mounted) {
      setState(() {
        _followStatus = result;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        WayaNav.onChange = () {
          _tabController.close();
        };
        await followNotifier.getFollowersOf(widget.data.$1.id);
        await followNotifier.getUsersFollowing(widget.data.$1.id);
        _getFollowState();
      },
    );
    super.initState();
  }

  @override
  void reassemble() {
    postNotifier.reset();
    eventNotifier.reset();
    followNotifier.reset();
    pollsNotifier.reset();
    donationsNotifier.reset();

    // This is fine.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await _fetchMore();
        await followNotifier.getFollowersOf(widget.data.$1.id);
        await followNotifier.getUsersFollowing(widget.data.$1.id);
        _getFollowState();
      },
    );
    super.reassemble();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMore() async {
    //? If this is for pages.
    if (_pageController.value == 0) {
      await postNotifier.getPostsForUser(widget.data.$1.id);
    }

    //? If this is for polls.
    if (_pageController.value == 2) {
      await pollsNotifier.getPollsByUser(widget.data.$1.id);
    }

    //? If this is for donations.
    if (_pageController.value == 3) {
      await donationsNotifier.getDonationsByUser(widget.data.$1.id);
    }

    //? If this is for groups.
    if (_pageController.value == 4) {
      await groupsNotifier.getGroupsForUser(widget.data.$1.id);
    }

    //? If this is for pages.
    if (_pageController.value == 5) {
      await pagesNotifier.getPagesForUser(widget.data.$1.id);
    }

    //? If this is for events..
    if (_pageController.value == 6) {
      await eventNotifier.getEventsForUser(widget.data.$1.id);
    }

    //? If this is for products.
    if (_pageController.value == 7) {
      await productsNotifier.getProductsByUser(widget.data.$1.id);
    }
  }

  void _shareProfile() async {
    final result = await Share.share(
      WayaValueHelper.getShareableUrl(WayaAppRoutes.getProfileRoute(
          widget.data.$1.id, 'profile', widget.data.$2.username)),
      subject: 'Share Profile',
    );

    // This is fi
    if (result.status == ShareResultStatus.success) return;
  }

  void _chatWithUser() async {
    final user = widget.data.$1;
    var chat = wayaChatsCache.getItem(
      (chat) =>
          chat.chatType == ChatType.personal &&
          chat.chatMembers.any((member) => member.userId == user.id),
    );
    chat ??= await conversationNotifier
        .startChat(ChatType.personal, [widget.data.$1.id]);

    //? Stop if we could not make this chat.
    if (chat == null) return;

    //? If we could make this chat...
    final chatNotifier = ref.read(chatProvider(chat.id).notifier);
    chatNotifier.setChat(chat);
    WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final postState = ref.watch(userPostsProvider);
    final eventState = ref.watch(userEventsProvider(widget.data.$1.id));
    final groupsState = ref.watch(userGroupsProvider(widget.data.$1.id));
    final pagesState = ref.watch(userPagesProvider(widget.data.$1.id));
    final followState = ref.watch(userFollowProvider);
    final pollsState = ref.watch(userPollsProvider(widget.data.$1.id));
    final donationsState = ref.watch(userDonationsProvider(widget.data.$1.id));
    final productsState = ref.watch(userProductsProvider(widget.data.$1.id));
    final conversationState = ref.watch(conversationProvider);
    final user = widget.data.$1;
    final profile = widget.data.$2;
    var chat = wayaChatsCache.getItem(
      (chat) =>
          chat.chatType == ChatType.personal &&
          chat.chatMembers.any((member) => member.userId == user.id),
    );

    //? Return the component.
    return ValueListenableBuilder(
      valueListenable: myFollowProvider,
      builder: (context, state, _) => WayaScaffold(
        isScrollable: false,
        padding: EdgeInsets.zero,
        appBarTrailing: Row(
          spacing: 6,
          children: [
            //? Chat only works when you have not blocked a user.
            if (!conversationState.isBlocked(user.id))
              IconButton(
                icon: WayaAssets.icons.chat.svg(
                  fit: BoxFit.none,
                  colorFilter: ColorFilter.mode(
                    wayaTheme.colorScheme.customBlack,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: _chatWithUser,
              ),

            // //? Share
            // IconButton(
            //   icon: WayaAssets.icons.genSet.share.svg(
            //     fit: BoxFit.none,
            //   ),
            //   onPressed: _shareProfile,
            // ),

            //? More
            PopupMenuButton(
              onSelected: (value) {},
              iconColor: wayaTheme.colorScheme.greyColor400,
              position: PopupMenuPosition.under,
              offset: Offset(0, 10),
              itemBuilder: (context) => [
                //? Block this user.
                PopupMenuItem<int>(
                  value: 1,
                  height: 36.h,
                  onTap: conversationState.isBlocked(widget.data.$1.id)
                      ? () async {
                          final result = await WayaUtils.showModalSheet<bool?>(
                            context,
                            child: UnblockUserDialog(
                              user: user,
                              profile: profile,
                              ref: ref,
                            ),
                          );

                          // If this is defined...
                          if (result == null) return;

                          //? Then pop.
                          if (result) {
                            WayaSnackBar.showToast(
                                "This user has been unblocked successfully");
                          }
                        }
                      : () async {
                          final result = await WayaUtils.showModalSheet<bool?>(
                            context,
                            child: BlockUserDialog(
                              user: user,
                              profile: profile,
                              ref: ref,
                            ),
                          );

                          // If this is defined...
                          if (result == null) return;

                          //? Then pop.
                          if (result) {
                            WayaSnackBar.showToast(
                                "This user has been blocked successfully");
                          }
                        },
                  child: WayaActionNav(
                    context: context,
                    asset: WayaAssets.icons.cProfileBlock.svg(
                      fit: BoxFit.none,
                      color: conversationState.isBlocked(widget.data.$1.id)
                          ? wayaTheme.colorScheme.customBlack
                          : wayaTheme.colorScheme.error,
                    ),
                    text: conversationState.isBlocked(widget.data.$1.id)
                        ? "Unblock account"
                        : "Block account",
                    color: conversationState.isBlocked(widget.data.$1.id)
                        ? wayaTheme.colorScheme.customBlack
                        : wayaTheme.colorScheme.error,
                  ),
                ),

                //?  Mute this account.
                PopupMenuItem<int>(
                  value: 2,
                  height: 36.h,
                  onTap: () async {
                    //? This is fine.
                    chat ??= await conversationNotifier
                        .startChat(ChatType.personal, [user.id]);

                    //? This is fine.
                    if (chat == null) {
                      return;
                    }

                    //? If this is already muted...
                    if (chat!.self?.isMuted ?? false) {
                      await conversationNotifier.muteOrUnmuteGroup(
                          chat!.id, null);
                    }

                    //? Mute the group
                    else {
                      WayaUtils.showModalSheet(
                        context,
                        child: MuteChatGroupModal(
                          chat: chat!,
                          notifier: conversationNotifier,
                        ),
                      );
                    }
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: WayaAssets.icons.cProfileMute.svg(
                      fit: BoxFit.none,
                      color: wayaTheme.colorScheme.customBlack,
                    ),
                    text: "Mute Account",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),

                //?  Report this account.
                PopupMenuItem<int>(
                  value: 3,
                  height: 36.h,
                  onTap: () async {
                    //conversationNotifier.reportUser(widget.data.$1.id);
                    final result = await WayaUtils.showModalSheet<bool?>(
                      context,
                      child: ReportChatPage(
                        statuses: pageReport,
                        userId: widget.data.$1.id,
                      ),
                    );

                    // If this is defined...
                    if (result == null) return;

                    //? Then pop.
                    if (result) {
                      WayaSnackBar.showToast("This user has been Reported");
                    }
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: WayaAssets.icons.cProfileReport.svg(
                      fit: BoxFit.none,
                      color: wayaTheme.colorScheme.customBlack,
                    ),
                    text: "Report Account",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),

                //? Share profile
                PopupMenuItem<int>(
                  value: 7,
                  height: 36.h,
                  onTap: _shareProfile,
                  child: WayaActionNav(
                    context: context,
                    asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                    text: "Share profile",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
              ],
              child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none),
            ),

            // This is fine.
            Gap(8)
          ],
        ),
        title: '',
        body: PopScope(
          onPopInvokedWithResult: (isPopping, _) {
            if (!isPopping) return;
            // postNotifier.reset();
            // eventNotifier.reset();
            // groupsNotifier.reset();
            // pagesNotifier.reset();
            // pollsNotifier.reset();
            // donationsNotifier.reset();
            // if (widget.source != 'profile') followNotifier.reset();
          },
          child: ValueListenableBuilder(
            valueListenable: _pageController,
            builder: (context, selectedPage, _) {
              //? Get the filtered data for each type.
              final filteredPosts = postState.posts(null);
              final filteredPolls = pollsState.polls(null);
              final filteredEvents = eventState.events(null);
              final filteredProducts = productsState.products(null);
              final filteredGroups = groupsState.groups(null);
              final filteredPages = pagesState.pages(null);
              final filteredDonations = donationsState.donations(null);

              //? Is this empty?
              final isEmpty = switch (selectedPage) {
                0 => filteredPosts.isEmpty && postState.hasLoaded,
                2 => filteredPolls.isEmpty && pollsState.hasLoaded,
                3 => filteredDonations.isEmpty && donationsState.hasLoaded,
                4 => filteredGroups.isEmpty && groupsState.hasLoaded,
                5 => filteredPages.isEmpty && pagesState.hasLoaded,
                6 => filteredEvents.isEmpty && eventState.hasLoaded,
                7 => filteredProducts.isEmpty && productsState.hasLoaded,
                _ => true,
              };

              //? Are we at end.
              final isAtEnd = switch (selectedPage) {
                0 => !postState.hasNextPage,
                2 => !pollsState.hasNextPage,
                3 => !donationsState.hasNextPage,
                4 => !groupsState.hasNextPage,
                5 => !pagesState.hasNextPage,
                6 => !eventState.hasNextPage,
                7 => !productsState.hasNextPage,
                _ => true,
              };

              //? Should we fetch.
              final shouldFetch = switch (selectedPage) {
                0 => !postState.isLoading,
                2 => !pollsState.isLoading,
                3 => !donationsState.isLoading,
                4 => !groupsState.isLoading,
                5 => !pagesState.isLoading,
                6 => !eventState.isLoading,
                7 => !productsState.isLoading,
                _ => true,
              };

              //? Our component.
              return WayaObservableScrollView(
                handler: scrollHandler,
                shouldFetch: shouldFetch,
                isAtEnd: isAtEnd,
                onReachEnd: () async => await _fetchMore(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? First, the picture set.
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        //? The
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //? First, the background image.
                            WayaImage2(
                              height: size.height * 0.2,
                              imageUrl: profile.coverImage,
                            ),

                            // Space.
                            const Gap(15),

                            //? Toggle following
                            ValueListenableBuilder(
                              valueListenable: wayaChatsCache,
                              builder: (context, redraws, _) => Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                spacing: 10.w,
                                children: [
                                  //? If this is muted.
                                  if (chat?.self?.isMuted ?? false)
                                    WayaAssets.icons.cProfileUnmute.svg(
                                      height: 24.sp,
                                      width: 24.sp,
                                      colorFilter: ColorFilter.mode(
                                        wayaTheme.colorScheme.error,
                                        BlendMode.srcIn,
                                      ),
                                    ),

                                  //? Toggle following
                                  GestureDetector(
                                    onTap: _followStatus == null
                                        ? null
                                        : () async {
                                            //? If this user is following this one.
                                            if (_followStatus!
                                                .isUserFollowing) {
                                              await myFollowProvider
                                                  .unfollowUser(
                                                      widget.data.$1.id);
                                            }

                                            //? Since I am not yet following this user...
                                            else {
                                              await myFollowProvider.followUser(
                                                  widget.data.$1.id);
                                            }

                                            //? Update the following state on screen.
                                            await _getFollowState();
                                          },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      padding: REdgeInsets.symmetric(
                                          vertical: 5.dg, horizontal: 10.dg),
                                      decoration: BoxDecoration(
                                        border:
                                            _followStatus?.isUserFollowing ==
                                                    true
                                                ? Border.all(
                                                    color: wayaTheme
                                                        .colorScheme.primary,
                                                    width: 1.5,
                                                  )
                                                : null,
                                        color: _followStatus == null
                                            ? wayaTheme.colorScheme.greyColor200
                                            : _followStatus!.isUserFollowing
                                                ? wayaTheme.colorScheme.white
                                                : wayaTheme.colorScheme.primary,
                                        borderRadius:
                                            BorderRadius.circular(7.r),
                                      ),
                                      child: Text(
                                        _followStatus == null
                                            ? "Loading"
                                            : _followStatus!.isUserFollowing
                                                ? "Following"
                                                : "Follow",
                                        style: wayaTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: _followStatus == null
                                              ? wayaTheme
                                                  .colorScheme.greyColor500
                                              : _followStatus!.isUserFollowing
                                                  ? wayaTheme
                                                      .colorScheme.primary
                                                  : wayaTheme.colorScheme.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        //? The user's profile picture.
                        Positioned(
                          left: 16.w,
                          bottom: 10.h,
                          child: ChatProfilePicture(
                            user: user,
                            canMove: true,
                            radius: 28.r,
                            showActive: false,
                          ),
                        ),
                      ],
                    ),

                    // Some.
                    const Gap(2),

                    //? Second, the picture set.
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //? First, the name of the user in question.
                          Text(
                            profile.displayName ?? '',
                            style: wayaTheme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: wayaTheme.colorScheme.black,
                            ),
                          ),

                          // Some space.
                          const Gap(5),

                          //? Second, the username of this user in question.
                          if (profile.username != null) ...[
                            Text(
                              '@${profile.username}',
                              style:
                                  wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                                color: wayaTheme.colorScheme.greyColor500,
                                fontSize: 13.sp,
                              ),
                            ),

                            // Some space.
                            const Gap(5),
                          ],

                          //? Third, the user's bio.
                          if (profile.bio != null) ...[
                            Text(
                              profile.bio!,
                              style:
                                  wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                                color: wayaTheme.colorScheme.greyColor700,
                              ),
                            ),

                            // This is fine.
                            const Gap(5),
                          ],

                          //? Fourth the profile overview.
                          InkWell(
                            customBorder: const StadiumBorder(),
                            onTap: () => WayaNav.toNamed(
                                WayaAppRoutes.getFollowersPage(
                                    widget.data.$1.id, 'mutual', 'profile')),
                            borderRadius: BorderRadius.circular(12.r),
                            splashColor:
                                wayaTheme.colorScheme.primary.withAlpha(30),
                            focusColor: const Color.fromARGB(255, 179, 173, 170)
                                .withAlpha(30),
                            highlightColor:
                                wayaTheme.colorScheme.primary.withAlpha(30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 10.w,
                              children: [
                                //? Users following.
                                WayaRichText(
                                  title1: WayaValueHelper.formatNumber(
                                      followState.followingTotalSize),
                                  title2: ' Following',
                                  style1:
                                      wayaTheme.textTheme.bodySmall?.copyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 12.sp,
                                  ),
                                  style2:
                                      wayaTheme.textTheme.bodySmall?.copyWith(
                                    color: wayaTheme.colorScheme.greyColor500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                  onTap2: () => WayaNav.toNamed(
                                    WayaAppRoutes.getFollowersPage(
                                        widget.data.$1.id,
                                        'following',
                                        'profile'),
                                  ),
                                ),

                                //? Followers.
                                WayaRichText(
                                  title1: WayaValueHelper.formatNumber(
                                      followState.followersTotalSize),
                                  title2: ' Followers',
                                  style1: wayaTheme.textTheme.bodySmall
                                      ?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 12.sp,
                                  ),
                                  style2: wayaTheme.textTheme.bodySmall
                                      ?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.greyColor500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                  onTap2: () => WayaNav.toNamed(
                                    WayaAppRoutes.getFollowersPage(
                                        widget.data.$1.id,
                                        'followers',
                                        'profile'),
                                  ),
                                ),

                                //? Posts.
                                WayaRichText(
                                  title1: WayaValueHelper.formatNumber(
                                      postState.totalSize),
                                  title2: ' Posts',
                                  style1: wayaTheme.textTheme.bodySmall
                                      ?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 12.sp,
                                  ),
                                  style2: wayaTheme.textTheme.bodySmall
                                      ?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.greyColor500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // This is fine.
                          Gap(5.w),

                          //? Some more space.
                          //if (isSelf)
                          WayaRichText(
                            title1: 'Joined: ',
                            title2: WayaDateHelper.getMonthlyTimestamp(
                                user.createdAt ?? DateTime.now()),
                            style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                              color: wayaTheme.colorScheme.black,
                              fontSize: 12.sp,
                            ),
                            style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                              color: wayaTheme.colorScheme.greyColor500,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Some space.
                    const Gap(10),

                    //? The tab selector goes here.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //?
                        WayaTabButton(
                          isSelected: selectedPage == 0,
                          text: 'Posts',
                          onTap: () {
                            if (_pageController.value == 0) return;
                            _pageController.value = 0;
                            _tabController.close();
                            _tabController.away();
                            _fetchMore();
                          },
                        ),

                        // ?
                        WayaTabButton(
                          isSelected: selectedPage == 1,
                          text: 'Reposts',
                          onTap: () {
                            if (_pageController.value == 1) return;
                            _pageController.value = 1;
                            _tabController.close();
                            _tabController.away();
                            _fetchMore();
                          },
                        ),

                        //?
                        WayaTabButton(
                          isSelected: selectedPage == 2,
                          text: 'Polls',
                          onTap: () {
                            if (_pageController.value == 2) return;
                            _pageController.value = 2;
                            _tabController.close();
                            _tabController.away();
                            _fetchMore();
                          },
                        ),

                        //? The rest
                        WayaExpandedTabButton(
                          isSelected: selectedPage > 2,
                          text: 'More',
                          controller: _tabController,
                          tabs: [
                            //? For donations
                            WayaExpandedTab(
                              isSelected: selectedPage == 3,
                              text: 'Donations',
                              onTap: () {
                                if (_pageController.value == 3) return;
                                _pageController.value = 3;
                                _tabController.close();
                                _fetchMore();
                              },
                            ),

                            // For groups.
                            WayaExpandedTab(
                              isSelected: selectedPage == 4,
                              text: "Groups",
                              onTap: () {
                                if (_pageController.value == 4) return;
                                _pageController.value = 4;
                                _fetchMore();
                              },
                            ),

                            // For pages.
                            WayaExpandedTab(
                              isSelected: selectedPage == 5,
                              text: "Pages",
                              onTap: () {
                                if (_pageController.value == 5) return;
                                _pageController.value = 5;
                                _fetchMore();
                              },
                            ),

                            // For pages.
                            WayaExpandedTab(
                              isSelected: selectedPage == 6,
                              text: "Events",
                              onTap: () {
                                if (_pageController.value == 6) return;
                                _pageController.value = 6;
                                _fetchMore();
                              },
                            ),

                            // For pages.
                            WayaExpandedTab(
                              isSelected: selectedPage == 7,
                              text: "Products",
                              onTap: () {
                                if (_pageController.value == 7) return;
                                _pageController.value = 7;
                                _fetchMore();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Some space.
                    Gap(5.w),

                    // Now our component.
                    if (!(widget.data.$2.isPublic ?? true) &&
                        _followStatus?.isUserFollowing == false) ...[
                      Gap(100.h),

                      //? Fair enough.
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //? First, the lock icon.
                            WayaAssets.icons.genSet.lock.svg(),

                            // Some space.
                            Gap(10.h),

                            //? The private text.
                            Text(
                              'This account is private',
                              style: wayaTheme.textTheme.titleLarge,
                            ),

                            // Some space.
                            Gap(10.h),

                            //?
                            Text(
                              'You must follow this user to see their posts and content',
                              style: wayaTheme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontFamily: WayaConstants.fontFamily,
                                fontSize: 16.sp,
                              ),
                            ),

                            // Some space.
                            Gap(30.h),
                          ],
                        ),
                      ),
                    ] else if (isEmpty) ...[
                      //? First, space that scales with the screen size.
                      Gap(60.h),

                      //? Second the actual component itself.
                      Center(
                        child: EmptyState(
                          assetImage: WayaAssets.icons.emptyState.svg(),
                          message: "Nothing to show yet",
                        ),
                      ),

                      //? Finally, space that scales with the screen size.
                      Gap(60.h),
                    ] else if (selectedPage == 0)
                      ...List.generate(
                        filteredPosts.length,
                        (index) => WayaPostWidget(
                          data: filteredPosts[index],
                          index: index,
                          padded: true,
                        ),
                      )
                    else if (selectedPage == 2)
                      ...List.generate(
                        filteredPolls.length,
                        (index) => SinglePollWidget(
                          poll: filteredPolls[index],
                          user: user,
                          padded: true,
                        ),
                      )
                    else if (selectedPage == 3)
                      ...List.generate(
                        filteredDonations.length,
                        (index) {
                          final donation = filteredDonations[index];
                          int daysLeft = donation.expirationDate
                              .difference(donation.startDate)
                              .inDays;
                          int amountRaised =
                              double.parse(donation.amountRaised!).toInt();
                          int targetedAmount =
                              double.parse(donation.targetAmount!).toInt();
                          double ratioLeft = amountRaised / targetedAmount;

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: ManageDonationWidget(
                              text: "Donate",
                              amountRaised: WayaHelpers.formatPrice(int.parse(
                                  '${donation.amountRaised?.replaceAll('.00', '')}')),
                              targetAmount: WayaHelpers.formatPrice(int.parse(
                                  '${donation.targetAmount?.replaceAll('.00', '')}')),
                              title: donation.title.capitalizeFirst,
                              image: donation.imageURL,
                              dayLeft: daysLeft < 0 ? '0' : '$daysLeft',
                              donationCount: donation.donationCount,
                              rangeRatio: ratioLeft,
                              onTap: () {
                                WayaNav.toNamed('/donation-details',
                                    arguments: {
                                      'title':
                                          '${donation.title.capitalizeFirst}',
                                      'image': '${donation.imageURL}',
                                      'amountRaised':
                                          '${donation.amountRaised?.replaceAll('.00', '')}',
                                      'targetAmount':
                                          '${donation.targetAmount?.replaceAll('.00', '')}',
                                      'desc': donation.description,
                                      'solution': donation.solution,
                                      'impact': donation.impact,
                                      'url': '${donation.url}',
                                      'minimumDonationAmount':
                                          '${donation.minimumDonationAmount}',
                                      'daysLeft': '$daysLeft',
                                      'privacy': '${donation.privacy}',
                                      'id': donation.id,
                                      'donationCount':
                                          '${donation.donationCount}',
                                      "donation": donation
                                    });
                              },
                              buttonWidth: 60.0,
                            ),
                          );
                        },
                      )
                    else if (selectedPage == 4)
                      ...List.generate(
                        filteredGroups.length,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: SingleGroupWidget(
                            group: filteredGroups[index],
                            index: index,
                          ),
                        ),
                      )
                    else if (selectedPage == 5)
                      ...List.generate(
                        filteredPages.length,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: SinglePageWidget(
                            page: filteredPages[index],
                            index: index,
                          ),
                        ),
                      )
                    else if (selectedPage == 6)
                      ...List.generate(
                        filteredEvents.length,
                        (index) => EventCard(
                          event: filteredEvents[index],
                          userId: widget.data.$1.id,
                        ),
                      )
                    else if (selectedPage == 7)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ProductsGrid(
                          products: filteredProducts,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
