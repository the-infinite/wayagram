// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/interests/vm/select_interest_vm.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/donation/widget/manage_donation_widget.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/features/follow/view/follow_page.dart';
import 'package:wayagram/features/general_settings/profile/modals/search.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/vm/donation.dart';
import 'package:wayagram/shared/features/profile/vm/groups.dart';
import 'package:wayagram/shared/features/profile/vm/pages.dart';
import 'package:wayagram/shared/features/profile/vm/poll.dart';
import 'package:wayagram/shared/features/profile/vm/product.dart';
import 'package:wayagram/shared/features/profile/vm/default.dart';
import 'package:wayagram/shared/features/profile/vm/event.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';
import 'package:wayagram/shared/features/profile/widget/poll.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';
import 'package:wayagram/shared/model/base_model.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  final CachedUserDataTuple data;
  final String source;

  // Construct.
  const MyProfilePage({
    super.key,
    required this.data,
    required this.source,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<MyProfilePage> {
  late final postNotifier = ref.read(userPostsProvider.notifier);
  late final commentedPostNotifier =
      ref.read(userCommentedPostsProvider.notifier);
  late final likedPostNotifier = ref.read(userLikedPostsProvider.notifier);
  late final repostPostNotifier = ref.read(userRepostsProvider.notifier);
  late final savedPostNotifier = ref.read(userSavedPostsProvider.notifier);
  late final groupsNotifier =
      ref.read(userGroupsProvider(widget.data.$1.id).notifier);
  late final pagesNotifier =
      ref.read(userPagesProvider(widget.data.$1.id).notifier);
  late final donationsNotifier =
      ref.read(userDonationsProvider(widget.data.$1.id).notifier);
  late final eventNotifier =
      ref.read(userEventsProvider(widget.data.$1.id).notifier);
  late final pollsNotifier =
      ref.read(userPollsProvider(widget.data.$1.id).notifier);
  late final productsNotifier =
      ref.read(userProductsProvider(widget.data.$1.id).notifier);
  late final conversationNotifier = ref.read(conversationProvider.notifier);
  late final interestsNotifier = ref.read(selectInterestProvider.notifier);
  final paginationController = ValueNotifier<bool>(false);
  final searchManager = ValueNotifier<BaseFilterModel?>(null);
  final followNotifier = myFollowProvider;
  final scrollHandler = WayaObservableScrollController();
  final _pageController = ValueNotifier(0);
  final _tabController = ExpandedTabController();
  final searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        WayaNav.onChange = () {
          _tabController.close();
        };
        await interestsNotifier.getUserInterest();
        await ShopResource.getShopCategories();
        await followNotifier.getFollowersOf();
        await followNotifier.getUsersFollowing();
      },
    );
    super.initState();
  }

  @override
  void reassemble() {
    postNotifier.reset();
    commentedPostNotifier.reset();
    likedPostNotifier.reset();
    repostPostNotifier.reset();
    savedPostNotifier.reset();
    eventNotifier.reset();
    followNotifier.reset();
    pollsNotifier.reset();

    // This is fine.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await _fetchMore();
        await followNotifier.getFollowersOf();
        await followNotifier.getUsersFollowing();
      },
    );
    super.reassemble();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    paginationController.dispose();
    searchController.dispose();
    searchManager.dispose();
    super.dispose();
  }

  Future<void> _fetchMore() async {
    //? If this is for pages.
    if (_pageController.value == 0) {
      await postNotifier.getPostsForUser(widget.data.$1.id);
    }

    //? If this is for repost
    if (_pageController.value == 1) {
      await repostPostNotifier.getRepostedPosts(widget.data.$1.id);
    }

    //? If this is for likes
    if (_pageController.value == 2) {
      await likedPostNotifier.getLikedPost(widget.data.$1.id);
    }

    //? If this is for comments
    if (_pageController.value == 3) {
      await commentedPostNotifier.getCommentedPost(widget.data.$1.id);
    }

    //? If this is for bookmarks
    if (_pageController.value == 4) {
      await savedPostNotifier.getSavedPostsForUser(widget.data.$1.id);
    }

    //? If this is for donations.
    if (_pageController.value == 5) {
      await donationsNotifier.getDonationsByUser(widget.data.$1.id);
    }

    //? If this is for polls.
    if (_pageController.value == 6) {
      await pollsNotifier.getPollsByUser(widget.data.$1.id);
    }

    //? If this is for pages.
    if (_pageController.value == 7) {
      await pagesNotifier.getPagesForUser(widget.data.$1.id);
    }

    //? If this is for groups.
    if (_pageController.value == 8) {
      await groupsNotifier.getGroupsForUser(widget.data.$1.id);
    }

    //? If this is for events..
    if (_pageController.value == 9) {
      await eventNotifier.getEventsForUser(widget.data.$1.id);
    }

    //? If this is for products.
    if (_pageController.value == 10) {
      await productsNotifier.getProductsByUser(widget.data.$1.id);
    }
  }

  void _shareProfile() async {
    //? Share the post.
    final result = await Share.share(
      WayaValueHelper.getShareableUrl(WayaAppRoutes.getProfileRoute(
          widget.data.$1.id, 'profile', widget.data.$2.username)),
      subject: 'Share Profile',
    );

    // This is fi
    if (result.status == ShareResultStatus.success) return;
  }

  void _triggerSearch(States interestState) async {
    final result = await WayaUtils.showModalSheet(
      context,
      isDismissible: false,
      child: SearchProfileModal(
        searchManager: searchManager,
        searchController: searchController,
        interests: interestState,
        page: _pageController.value,
      ),
    );

    // Okay.
    if (result != null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final interestState = ref.watch(selectInterestProvider);
    final postState = ref.watch(userPostsProvider);
    final likedPostState = ref.watch(userLikedPostsProvider);
    final commentedPostState = ref.watch(userCommentedPostsProvider);
    final repostedPostState = ref.watch(userRepostsProvider);
    final groupsState = ref.watch(userGroupsProvider(widget.data.$1.id));
    final pagesState = ref.watch(userPagesProvider(widget.data.$1.id));
    final donationsState = ref.watch(userDonationsProvider(widget.data.$1.id));
    final eventState = ref.watch(userEventsProvider(widget.data.$1.id));
    final pollsState = ref.watch(userPollsProvider(widget.data.$1.id));
    final savedPostsState = ref.watch(userSavedPostsProvider);
    final productsState = ref.watch(userProductsProvider(widget.data.$1.id));
    final user = widget.data.$1;
    final profile = widget.data.$2;

    //? Return the component.
    return ValueListenableBuilder(
      valueListenable: myFollowProvider,
      builder: (context, state, _) => ValueListenableBuilder(
        valueListenable: myGroupNotifier,
        builder: (context, groupState, _) => ValueListenableBuilder(
          valueListenable: myPageNotifier,
          builder: (context, pageState, _) => WayaScaffold(
            isScrollable: false,
            padding: EdgeInsets.zero,
            appBarTrailing: Row(
              spacing: 12,
              children: [
                //? Search
                IconButton(
                  icon: WayaAssets.icons.genSet.search.svg(
                    fit: BoxFit.none,
                  ),
                  onPressed: () => _triggerSearch(interestState),
                ),

                //? Share
                IconButton(
                  icon: WayaAssets.icons.genSet.share.svg(
                    fit: BoxFit.none,
                  ),
                  onPressed: _shareProfile,
                ),

                //? More
                PopupMenuButton(
                  onSelected: (value) {},
                  iconColor: wayaTheme.colorScheme.greyColor400,
                  position: PopupMenuPosition.under,
                  offset: Offset(0, 10),
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      height: 36.h,
                      onTap: () => WayaNav.toNamed(EditProfilePage.route),
                      child: WayaActionNav(
                        context: context,
                        asset: WayaAssets.images.pages.setting.svg(),
                        text: "Profile settings",
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
                        asset:
                            WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
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
                //? Clear all search queries in each of these ones.
                try {
                  searchController.clear();
                  searchManager.value = null;
                } catch (_) {}
              },
              child: ValueListenableBuilder(
                valueListenable: searchManager,
                builder: (context, search, _) => ValueListenableBuilder(
                  valueListenable: _pageController,
                  builder: (context, selectedPage, _) {
                    //? Get the filtered data for each type.
                    final filteredPosts = postState.posts(search);
                    final filteredRepostedPosts =
                        repostedPostState.posts(search);
                    final filteredLikedPosts = likedPostState.posts(search);
                    final filteredCommentedPosts =
                        commentedPostState.posts(search);
                    final filteredSavedPosts = savedPostsState.posts(search);
                    final filteredPolls = pollsState.polls(search);
                    final filteredEvents = eventState.events(search);
                    final filteredProducts = productsState.products(search);
                    final filteredGroups = groupsState.groups(search);
                    final filteredPages = pagesState.pages(search);
                    final filteredDonations = donationsState.donations(search);

                    //? Is this empty?
                    final isEmpty = switch (selectedPage) {
                      0 => filteredPosts.isEmpty && postState.hasLoaded,
                      1 => filteredRepostedPosts.isEmpty &&
                          repostedPostState.hasLoaded,
                      2 =>
                        filteredLikedPosts.isEmpty && likedPostState.hasLoaded,
                      3 => filteredCommentedPosts.isEmpty &&
                          commentedPostState.hasLoaded,
                      4 =>
                        filteredSavedPosts.isEmpty && savedPostsState.hasLoaded,
                      5 =>
                        filteredDonations.isEmpty && donationsState.hasLoaded,
                      6 => filteredPolls.isEmpty && pollsState.hasLoaded,
                      7 => filteredPages.isEmpty && pagesState.hasLoaded,
                      8 => filteredGroups.isEmpty && groupsState.hasLoaded,
                      9 => filteredEvents.isEmpty && eventState.hasLoaded,
                      10 => filteredProducts.isEmpty && productsState.hasLoaded,
                      _ => true,
                    };

                    //? Are we at end.
                    final isAtEnd = switch (selectedPage) {
                      0 => !postState.hasNextPage,
                      1 => !repostedPostState.hasNextPage,
                      2 => !likedPostState.hasNextPage,
                      3 => !commentedPostState.hasNextPage,
                      4 => !savedPostsState.hasNextPage,
                      5 => !donationsState.hasNextPage,
                      6 => !pollsState.hasNextPage,
                      7 => !pagesState.hasNextPage,
                      8 => !groupsState.hasNextPage,
                      9 => !eventState.hasNextPage,
                      10 => !productsState.hasNextPage,
                      _ => true,
                    };

                    //? Should we fetch.
                    final isLoading = switch (selectedPage) {
                      0 => postState.isLoading,
                      1 => repostedPostState.isLoading,
                      2 => likedPostState.isLoading,
                      3 => commentedPostState.isLoading,
                      4 => savedPostsState.isLoading,
                      5 => donationsState.isLoading,
                      6 => pollsState.isLoading,
                      7 => pagesState.isLoading,
                      8 => groupsState.isLoading,
                      9 => eventState.isLoading,
                      10 => productsState.isLoading,
                      _ => true,
                    };

                    //? Our component.
                    return WayaObservableScrollView(
                      handler: scrollHandler,
                      shouldFetch: false,
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
                                  //? FIrst, the background image.
                                  WayaImage2(
                                    height: size.height * 0.2,
                                    imageUrl: profile.coverImage,
                                  ),

                                  // Space.
                                  const Gap(15),

                                  //? How we go to the edit profile page.
                                  GestureDetector(
                                    onTap: () =>
                                        WayaNav.toNamed(EditProfilePage.route),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20.w),
                                      padding: REdgeInsets.symmetric(
                                          vertical: 5.dg, horizontal: 10.dg),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              wayaTheme.colorScheme.primary600,
                                          width: 1.5,
                                        ),
                                        color: wayaTheme.colorScheme.white,
                                        borderRadius:
                                            BorderRadius.circular(7.r),
                                      ),
                                      child: Text(
                                        'Edit Profile',
                                        style: wayaTheme.textTheme.labelSmall
                                            ?.wayaCopyWith(
                                          color:
                                              wayaTheme.colorScheme.primary600,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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

                          //? Second, the profile set.
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //? First, the name of the user in question.
                                Text(
                                  profile.displayName ?? '',
                                  style:
                                      wayaTheme.textTheme.bodyMedium?.copyWith(
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
                                    style: wayaTheme.textTheme.labelSmall
                                        ?.wayaCopyWith(
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
                                    style: wayaTheme.textTheme.labelSmall
                                        ?.wayaCopyWith(
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
                                      FollowRelationshipsPage.route),
                                  borderRadius: BorderRadius.circular(12.r),
                                  splashColor: wayaTheme.colorScheme.primary
                                      .withAlpha(30),
                                  focusColor:
                                      const Color.fromARGB(255, 179, 173, 170)
                                          .withAlpha(30),
                                  highlightColor: wayaTheme.colorScheme.primary
                                      .withAlpha(30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 10.w,
                                    children: [
                                      //? Users following.
                                      WayaRichText(
                                        title1: WayaValueHelper.formatNumber(
                                            state.followingTotalSize),
                                        title2: ' Following',
                                        style1: wayaTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: wayaTheme.colorScheme.black,
                                          fontSize: 12.sp,
                                        ),
                                        style2: wayaTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: wayaTheme
                                              .colorScheme.greyColor500,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                        ),
                                      ),

                                      //? Followers.
                                      WayaRichText(
                                        title1: WayaValueHelper.formatNumber(
                                            state.followersTotalSize),
                                        title2: ' Followers',
                                        style1: wayaTheme.textTheme.bodySmall
                                            ?.wayaCopyWith(
                                          color: wayaTheme.colorScheme.black,
                                          fontSize: 12.sp,
                                        ),
                                        style2: wayaTheme.textTheme.bodySmall
                                            ?.wayaCopyWith(
                                          color: wayaTheme
                                              .colorScheme.greyColor500,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
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
                                          color: wayaTheme
                                              .colorScheme.greyColor500,
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
                                WayaRichText(
                                  title1: 'Joined: ',
                                  title2: WayaDateHelper.getMonthlyTimestamp(
                                      user.createdAt ?? DateTime.now()),
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
                                text: 'Likes',
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
                                verticalPadding: 2.h,
                                offset: Offset(0, -160.h),
                                tabs: [
                                  // For comments.
                                  WayaExpandedTab(
                                    isSelected: selectedPage == 3,
                                    text: 'Comments',
                                    onTap: () {
                                      if (_pageController.value == 3) return;
                                      _pageController.value = 3;
                                      _tabController.close();
                                      _fetchMore();
                                    },
                                  ),

                                  // For bookmarks.
                                  WayaExpandedTab(
                                    isSelected: selectedPage == 4,
                                    text: "Bookmarks",
                                    onTap: () {
                                      if (_pageController.value == 4) return;
                                      _pageController.value = 4;
                                      _fetchMore();
                                    },
                                  ),

                                  // For donations.
                                  WayaExpandedTab(
                                    isSelected: selectedPage == 5,
                                    text: "Donations",
                                    onTap: () {
                                      if (_pageController.value == 5) return;
                                      _pageController.value = 5;
                                      _fetchMore();
                                    },
                                  ),

                                  // For polls.
                                  WayaExpandedTab(
                                    isSelected: selectedPage == 6,
                                    text: "Polls",
                                    onTap: () {
                                      if (_pageController.value == 6) return;
                                      _pageController.value = 6;
                                      _fetchMore();
                                    },
                                  ),

                                  // For pages.
                                  WayaExpandedTab(
                                    isSelected: selectedPage == 7,
                                    text: "Pages",
                                    onTap: () {
                                      if (_pageController.value == 7) return;
                                      _pageController.value = 7;
                                      _fetchMore();
                                    },
                                  ),

                                  // For groups.
                                  WayaExpandedTab(
                                    isSelected: selectedPage == 8,
                                    text: "Groups",
                                    onTap: () {
                                      if (_pageController.value == 8) return;
                                      _pageController.value = 8;
                                      _fetchMore();
                                    },
                                  ),

                                  // For events.
                                  WayaExpandedTab(
                                    isSelected: selectedPage == 9,
                                    text: "Events",
                                    onTap: () {
                                      if (_pageController.value == 9) return;
                                      _pageController.value = 9;
                                      _fetchMore();
                                    },
                                  ),

                                  // For products.
                                  WayaExpandedTab(
                                    isSelected: selectedPage == 10,
                                    text: "Products",
                                    onTap: () {
                                      if (_pageController.value == 10) return;
                                      _pageController.value = 10;
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
                          if (isEmpty) ...[
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
                          else if (selectedPage == 1)
                            ...List.generate(
                              filteredRepostedPosts.length,
                              (index) => WayaPostWidget(
                                data: filteredRepostedPosts[index],
                                index: index,
                                padded: true,
                              ),
                            )
                          else if (selectedPage == 2)
                            ...List.generate(
                              filteredLikedPosts.length,
                              (index) => WayaPostWidget(
                                data: filteredLikedPosts[index],
                                index: index,
                                padded: true,
                              ),
                            )
                          else if (selectedPage == 3)
                            ...List.generate(
                              filteredCommentedPosts.length,
                              (index) => WayaPostWidget(
                                data: filteredCommentedPosts[index],
                                index: index,
                                padded: true,
                              ),
                            )
                          else if (selectedPage == 4)
                            ...List.generate(
                              filteredSavedPosts.length,
                              (index) => WayaPostWidget(
                                data: filteredSavedPosts[index],
                                index: index,
                                padded: true,
                              ),
                            )
                          else if (selectedPage == 5)
                            ...List.generate(
                              filteredDonations.length,
                              (index) {
                                final donation = filteredDonations[index];
                                int daysLeft = donation.expirationDate
                                    .difference(donation.startDate)
                                    .inDays;
                                int amountRaised =
                                    double.parse(donation.amountRaised!)
                                        .toInt();
                                int targetedAmount =
                                    double.parse(donation.targetAmount!)
                                        .toInt();
                                double ratioLeft =
                                    amountRaised / targetedAmount;

                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
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
                          else if (selectedPage == 6)
                            ...List.generate(
                              filteredPolls.length,
                              (index) => SinglePollWidget(
                                poll: filteredPolls[index],
                                user: user,
                                padded: true,
                              ),
                            )
                          else if (selectedPage == 7)
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
                          else if (selectedPage == 8)
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
                          else if (selectedPage == 9)
                            ...List.generate(
                              filteredEvents.length,
                              (index) => EventCard(
                                event: filteredEvents[index],
                                userId: widget.data.$1.id,
                              ),
                            )
                          else if (selectedPage == 10)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: ProductsGrid(
                                products: filteredProducts,
                              ),
                            ),

                          //? Finally, if there is more to see...
                          if (!isAtEnd)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.h, horizontal: 70.w),
                              child: WayaProgressiveButton(
                                callback: () async =>
                                    await scrollHandler.getMore(),
                                notifier: paginationController,
                                isDisabled: isLoading,
                                text: 'See more',
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
