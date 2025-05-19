// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/features/follow/view/follow_page.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/vm/poll.dart';
import 'package:wayagram/shared/features/profile/vm/product.dart';
import 'package:wayagram/shared/features/profile/vm/default.dart';
import 'package:wayagram/shared/features/profile/vm/event.dart';
import 'package:wayagram/shared/features/profile/widget/poll.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

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
  late final savedPostNotifier = ref.read(userSavedPostsProvider.notifier);
  late final eventNotifier = ref.read(userEventsProvider.notifier);
  late final pollsNotifier = ref.read(userPollsProvider.notifier);
  late final productsNotifier = ref.read(userProductsProvider(widget.data.$1.id).notifier);
  late final conversationNotifier = ref.read(conversationProvider.notifier);
  final followNotifier = myFollowProvider;
  final scrollHandler = WayaObservableScrollController();
  final _pageController = ValueNotifier(0);
  final _tabController = ExpandedTabController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        WayaNav.onChange = () {
          _tabController.close();
        };
        await followNotifier.getFollowersOf();
        await followNotifier.getUsersFollowing();
      },
    );
    super.initState();
  }

  @override
  void reassemble() {
    postNotifier.reset();
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
    super.dispose();
  }

  Future<void> _fetchMore() async {
    //? If this is for pages.
    if (_pageController.value == 0) {
      await postNotifier.getPostsForUser(widget.data.$1.id);
    }

    //? If this is for likes
    if (_pageController.value == 2) {
      //await donationsNotifier.getDonationsByUser(widget.data.$1.id);
    }

    //? If this is for comments
    if (_pageController.value == 3) {
      //await donationsNotifier.getDonationsByUser(widget.data.$1.id);
    }

    //? If this is for bookmarks
    if (_pageController.value == 4) {
      await savedPostNotifier.getSavedPostsForUser(widget.data.$1.id);
    }

    //? If this is for polls.
    if (_pageController.value == 5) {
      await pollsNotifier.getPollsByUser(widget.data.$1.id);
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
    //? Share the post.
    final result = await Share.share(
      WayaValueHelper.getShareableUrl(WayaAppRoutes.getProfileRoute(widget.data.$1.id)),
      subject: 'Share Profile',
    );

    // This is fi
    if (result.status == ShareResultStatus.success) return;
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final postState = ref.watch(userPostsProvider);
    final eventState = ref.watch(userEventsProvider);
    final pollsState = ref.watch(userPollsProvider);
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
                // IconButton(
                //   icon: WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
                //   onPressed: () async {},
                // ),

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
                postNotifier.reset();
                eventNotifier.reset();
                pollsNotifier.reset();
              },
              child: ValueListenableBuilder(
                valueListenable: _pageController,
                builder: (context, selectedPage, _) {
                  //? Is this empty?
                  final isEmpty = switch (selectedPage) {
                    0 => postState.posts.isEmpty && postState.hasLoaded,
                    // 2 => donationsState.donations.isEmpty && donationsState.hasLoaded,
                    // 3 => myGroupNotifier.createdGroups.isEmpty && !myGroupNotifier.hasMoreCreatedGroups,
                    4 => savedPostsState.posts.isEmpty && savedPostsState.hasLoaded,
                    5 => pollsState.polls.isEmpty && pollsState.hasLoaded,
                    6 => eventState.events.isEmpty && eventState.hasLoaded,
                    7 => productsState.products.isEmpty && productsState.hasLoaded,
                    _ => true,
                  };

                  //? Are we at end.
                  final isAtEnd = switch (selectedPage) {
                    0 => !postState.hasNextPage,
                    // 2 => !donationsState.hasNextPage,
                    // 3 => !myGroupNotifier.hasMoreCreatedGroups,
                    4 => !savedPostsState.hasNextPage,
                    5 => !pollsState.hasNextPage,
                    6 => !eventState.hasNextPage,
                    7 => !productsState.hasNextPage,
                    _ => true,
                  };

                  //? Should we fetch.
                  final shouldFetch = switch (selectedPage) {
                    0 => !postState.isLoading,
                    // 2 => !donationsState.isLoading,
                    // 3 => !myGroupNotifier.isLoading,
                    4 => !savedPostsState.isLoading,
                    5 => !pollsState.isLoading,
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
                                //? FIrst, the background image.
                                WayaImage2(
                                  height: size.height * 0.2,
                                  imageUrl: profile.coverImage,
                                ),

                                // Space.
                                const Gap(15),

                                //? How we go to the edit profile page.
                                GestureDetector(
                                  onTap: () => WayaNav.toNamed(EditProfilePage.route),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20.w),
                                    padding: REdgeInsets.symmetric(vertical: 5.dg, horizontal: 10.dg),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: wayaTheme.colorScheme.primary600,
                                        width: 1.5,
                                      ),
                                      color: wayaTheme.colorScheme.white,
                                      borderRadius: BorderRadius.circular(7.r),
                                    ),
                                    child: Text(
                                      'Edit Profile',
                                      style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                                        color: wayaTheme.colorScheme.primary600,
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
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
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
                                  style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
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
                                  style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.greyColor700,
                                  ),
                                ),

                                // This is fine.
                                const Gap(5),
                              ],

                              //? Fourth the profile overview.
                              InkWell(
                                customBorder: const StadiumBorder(),
                                onTap: () => WayaNav.toNamed(FollowRelationshipsPage.route),
                                borderRadius: BorderRadius.circular(12.r),
                                splashColor: wayaTheme.colorScheme.primary.withAlpha(30),
                                focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
                                highlightColor: wayaTheme.colorScheme.primary.withAlpha(30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 10.w,
                                  children: [
                                    //? Users following.
                                    WayaRichText(
                                      title1: WayaValueHelper.formatNumber(state.followingTotalSize),
                                      title2: ' Following',
                                      style1: wayaTheme.textTheme.bodySmall?.copyWith(
                                        color: wayaTheme.colorScheme.black,
                                        fontSize: 12.sp,
                                      ),
                                      style2: wayaTheme.textTheme.bodySmall?.copyWith(
                                        color: wayaTheme.colorScheme.greyColor500,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      ),
                                    ),

                                    //? Followers.
                                    WayaRichText(
                                      title1: WayaValueHelper.formatNumber(state.followersTotalSize),
                                      title2: ' Followers',
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

                                    //? Posts.
                                    WayaRichText(
                                      title1: WayaValueHelper.formatNumber(postState.totalSize),
                                      title2: ' Posts',
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

                              // This is fine.
                              Gap(5.w),

                              //? Some more space.
                              //if (isSelf)
                              WayaRichText(
                                title1: 'Joined: ',
                                title2: WayaDateHelper.getMonthlyTimestamp(user.createdAt ?? DateTime.now()),
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
                              tabs: [
                                //? For donations
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

                                // For groups.
                                WayaExpandedTab(
                                  isSelected: selectedPage == 4,
                                  text: "Bookmarks",
                                  onTap: () {
                                    if (_pageController.value == 4) return;
                                    _pageController.value = 4;
                                    _fetchMore();
                                  },
                                ),

                                // For pages.
                                WayaExpandedTab(
                                  isSelected: selectedPage == 5,
                                  text: "Polls",
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
                            postState.posts.length,
                            (index) => WayaPostWidget(
                              data: postState.posts[index],
                              index: index,
                              padded: true,
                            ),
                          )
                        else if (selectedPage == 2)
                          ...[] // Likes
                        else if (selectedPage == 3)
                          ...[] // Comments
                        else if (selectedPage == 4)
                          ...List.generate(
                            savedPostsState.posts.length,
                            (index) => WayaPostWidget(
                              data: savedPostsState.posts[index],
                              index: index,
                              padded: true,
                            ),
                          ) // Bookmarks
                        else if (selectedPage == 5)
                          ...List.generate(
                            pollsState.polls.length,
                            (index) => SinglePollWidget(
                              poll: pollsState.polls[index],
                              user: user,
                              padded: true,
                            ),
                          )
                        else if (selectedPage == 6)
                          ...List.generate(
                            eventState.events.length,
                            (index) => EventCard(
                              event: eventState.events[index],
                              userId: widget.data.$1.id,
                            ),
                          )
                        else if (selectedPage == 7)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: ProductsGrid(
                              products: productsState.products,
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
    );
  }
}
