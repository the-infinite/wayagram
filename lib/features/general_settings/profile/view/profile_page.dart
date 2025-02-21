import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';
import 'package:wayagram/shared/features/profile/vm/default.dart';
import 'package:wayagram/shared/features/profile/vm/event.dart';
import 'package:wayagram/shared/features/profile/vm/groups.dart';
import 'package:wayagram/shared/features/profile/vm/pages.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const route = '/profile-page';
  final String id;

  // Construct.
  const ProfilePage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late final postNotifier = ref.watch(userPostsProvider.notifier);
  late final eventNotifier = ref.watch(userEventsProvider.notifier);
  late final groupsNotifier = ref.watch(userGroupsProvider.notifier);
  late final pagesNotifier = ref.watch(userPagesProvider.notifier);
  late final followNotifier = ref.watch(followProvider.notifier);
  final scrollHandler = WayaObservableScrollController();
  final _pageController = ValueNotifier(0);
  final _tabController = ExpandedTabController();
  FollowStatusModel? _followStatus;

  void _getFollowState() async {
    if (widget.id == ConversationState.self.id) return;
    final result = await followNotifier.getFollowStatus(widget.id);
    
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
        await followNotifier.getFollowersOf(widget.id);
        await followNotifier.getUsersFollowing(widget.id);
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

    // This is fine.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await _fetchMore();
        await followNotifier.getFollowersOf(widget.id);
        await followNotifier.getUsersFollowing(widget.id);
        _getFollowState();
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
      await postNotifier.getPostsForUser(widget.id);
    }

    //? If this is for groups.
    if (_pageController.value == 4) {
      await groupsNotifier.getGroupsForUser(widget.id);
    }

    //? If this is for pages.
    if (_pageController.value == 5) {
      await pagesNotifier.getPagesForUser(widget.id);
    }

    //? If this is for events..
    if (_pageController.value == 6) {
      await eventNotifier.getEventsForUser(widget.id);
    }
  }

  void _shareProfile() async {
    //? Share the post.
    final result = await Share.share('https://wayagram.ng/user/profile?id=${widget.id}', subject: 'Share Profile');

    // This is fi
    if (result.status == ShareResultStatus.success) return;
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final postState = ref.watch(userPostsProvider);
    final eventState = ref.watch(userEventsProvider);
    final groupsState = ref.watch(userGroupsProvider);
    final pagesState = ref.watch(userPagesProvider);
    final followState = ref.watch(followProvider);

    //? Return the component.
    return WayaScaffold(
      isScrollable: false,
      padding: EdgeInsets.zero,
      appBarTrailing: Row(
        spacing: 12,
        children: [
          //? Search
          IconButton(
            icon: WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
            onPressed: () async {},
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
                child: WayaActionNav(
                  context: context,
                  onTap: () {},
                  asset: WayaAssets.images.pages.setting.svg(),
                  text: "Group settings",
                  color: wayaTheme.colorScheme.customBlack,
                ),
              ),

              //? Share.
              PopupMenuItem<int>(
                value: 1,
                child: WayaActionNav(
                  context: context,
                  onTap: _shareProfile,
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
          groupsNotifier.reset();
          pagesNotifier.reset();
          followNotifier.reset();
        },
        child: ValueListenableBuilder(
            valueListenable: _pageController,
            builder: (context, selectedPage, _) {
              //? Is this empty?
              final isEmpty = switch (selectedPage) {
                0 => postState.posts.isEmpty && postState.hasLoaded,
                4 => groupsState.groups.isEmpty && groupsState.hasLoaded,
                5 => pagesState.pages.isEmpty && pagesState.hasLoaded,
                6 => eventState.events.isEmpty && eventState.hasLoaded,
                _ => true,
              };

              //? Are we at end.
              final isAtEnd = switch (selectedPage) {
                0 => !postState.hasNextPage,
                4 => !groupsState.hasNextPage,
                5 => !pagesState.hasNextPage,
                6 => !eventState.hasNextPage,
                _ => true,
              };

              //? Should we fetch.
              final shouldFetch = switch (selectedPage) {
                0 => !postState.isLoading,
                4 => !groupsState.isLoading,
                5 => !pagesState.isLoading,
                6 => !eventState.isLoading,
                _ => true,
              };

              //? Our component.
              return WayaObservableScrollView(
                handler: scrollHandler,
                shouldFetch: shouldFetch,
                isAtEnd: isAtEnd,
                onReachEnd: () async {
                  await _fetchMore();
                },
                child: WayaFutureSubscriber(
                  future: UserResource.getUserDetails(widget.id),
                  builder: (context, data) {
                    //? When this is undefined...
                    if (data == null) return const SizedBox();

                    // This is fine.
                    final user = data.$1;
                    final profile = data.$2;
                    final isSelf = user.id == ConversationState.self.id;

                    //? The main component.
                    return Column(
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
                                CachedNetworkImage(
                                  errorWidget: (context, url, error) => Container(
                                    height: (size.height * 0.2).h,
                                    color: wayaTheme.colorScheme.greyColor200,
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        color: wayaTheme.colorScheme.greyColor600,
                                      ),
                                    ),
                                  ),
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: (size.height * 0.2).h,
                                  imageUrl: profile.coverImage.toString(),
                                ),

                                // Space.
                                const Gap(15),

                                //? How we go to the edit profile page.
                                if (isSelf)
                                  GestureDetector(
                                    onTap: () {
                                      WayaNav.toNamed(
                                        EditProfilePage.route,
                                      );
                                    },
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
                                  )
                                else
                                  GestureDetector(
                                    onTap: _followStatus == null
                                        ? null
                                        : () async {
                                            //? If this user is following this one.
                                            if (_followStatus!.isUserFollowing) {
                                              await followNotifier.unfollowUser(widget.id);
                                            }

                                            //? Since I am not yet following this user...
                                            else {
                                              await followNotifier.followUser(widget.id);
                                            }

                                            //? Update the following state on screen.
                                            _getFollowState();
                                          },
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
                                        _followStatus?.isUserFollowing == true ? "Following" : "Follow",
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
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //? First, the name of the user in question.
                              Text(
                                user.fullname,
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
                                    fontSize: 13,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10.w,
                                children: [
                                  //? Users following.
                                  WayaRichText(
                                    title1: WayaValueHelper.formatNumber(followState.followingTotalSize),
                                    title2: ' Following',
                                    style1: wayaTheme.textTheme.bodySmall?.copyWith(
                                      color: wayaTheme.colorScheme.black,
                                      fontSize: 12,
                                    ),
                                    style2: wayaTheme.textTheme.bodySmall?.copyWith(
                                      color: wayaTheme.colorScheme.greyColor500,
                                      fontSize: 12,
                                    ),
                                  ),

                                  //? Followers.
                                  WayaRichText(
                                    title1: WayaValueHelper.formatNumber(followState.followersTotalSize),
                                    title2: ' Followers',
                                    style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                      color: wayaTheme.colorScheme.black,
                                      fontSize: 12,
                                    ),
                                    style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                      color: wayaTheme.colorScheme.greyColor500,
                                      fontSize: 12,
                                    ),
                                  ),

                                  //? Posts.
                                  WayaRichText(
                                    title1: WayaValueHelper.formatNumber(postState.totalSize),
                                    title2: ' Posts',
                                    style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                      color: wayaTheme.colorScheme.black,
                                      fontSize: 12,
                                    ),
                                    style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                      color: wayaTheme.colorScheme.greyColor500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              // This is fine.
                              Gap(5.w),

                              //? Some more space.
                              if (isSelf)
                                WayaRichText(
                                  title1: 'Joined: ',
                                  title2: WayaDateHelper.getMonthlyTimestamp(user.createdAt ?? DateTime.now()),
                                  style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 12,
                                  ),
                                  style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.greyColor500,
                                    fontSize: 12,
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
                                _fetchMore();
                              },
                            ),

                            // ?
                            //   WayaTabButton(
                            //     isSelected: selectedPage == 1,
                            //     text: 'Reposts',
                            //     onTap: () {
                            //       if (_pageController.value == 1) return;
                            //       _pageController.value = 1;
                            //       _tabController.close();
                            //       _fetchMore();
                            //     },
                            //   ),

                            //?
                            WayaTabButton(
                              isSelected: selectedPage == 2,
                              text: 'Polls',
                              onTap: () {
                                if (_pageController.value == 2) return;
                                _pageController.value = 2;
                                _tabController.close();
                                _fetchMore();
                              },
                            ),

                            //?
                            WayaTabButton(
                              isSelected: selectedPage == 3,
                              text: 'Donations',
                              onTap: () {
                                if (_pageController.value == 3) return;
                                _pageController.value = 3;
                                _tabController.close();
                                _fetchMore();
                              },
                            ),

                            //? The rest
                            WayaExpandedTabButton(
                              isSelected: selectedPage > 3,
                              text: 'More',
                              controller: _tabController,
                              tabs: [
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
                        const Gap(5),

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
                        else if (selectedPage == 4)
                          ...List.generate(
                            groupsState.groups.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SingleGroupWidget(
                                group: groupsState.groups[index],
                                index: index,
                              ),
                            ),
                          )
                        else if (selectedPage == 5)
                          ...List.generate(
                            pagesState.pages.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SinglePageWidget(
                                page: pagesState.pages[index],
                                index: index,
                              ),
                            ),
                          )
                        else if (selectedPage == 6)
                          ...List.generate(
                            eventState.events.length,
                            (index) => EventCard(
                              event: eventState.events[index],
                              userId: widget.id,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
