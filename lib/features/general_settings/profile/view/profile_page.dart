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
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/posts/vm/default.dart';
import 'package:wayagram/shared/features/posts/widget/default.dart';
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
  late final postNotifier = ref.watch(postsProvider.notifier);
  final _pageController = ValueNotifier(0);
  final _tabController = ExpandedTabController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _fetchMore();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchMore() async {
    switch (_pageController.value) {
      case 0:
        {
          await postNotifier.getPostsForUser(widget.id);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final postState = ref.watch(postsProvider);

    //? Return the component.
    return WayaScaffold(
      isScrollable: false,
      padding: EdgeInsets.zero,
      appBarTrailing: Row(
        spacing: 12,
        children: [
          //
          WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),

          //
          WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),

          //
          PopupMenuButton(
            onSelected: (value) {},
            iconColor: wayaTheme.colorScheme.greyColor400,
            position: PopupMenuPosition.under,
            offset: Offset(0, 5),
            itemBuilder: (context) {
              return [
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
                PopupMenuItem<int>(
                  value: 1,
                  child: WayaActionNav(
                    context: context,
                    onTap: () {
                      Share.share('Hello');
                    },
                    asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                    text: "Share Group link",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
              ];
            },
            child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none),
          ),

          // This is fine.
          Gap(8)
        ],
      ),
      title: '',
      body: PopScope(
        onPopInvokedWithResult: (isPopping, _) {
          postNotifier.reset();
        },
        child: WayaObservableScrollView(
          shouldFetch: !postState.hasLoaded,
          isAtEnd: !postState.hasNextPage,
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
              return ValueListenableBuilder(
                valueListenable: _pageController,
                builder: (context, selectedPage, _) {
                  //? Is this empty?
                  final isEmpty = switch (selectedPage) {
                    0 => postState.posts.isEmpty && postState.hasLoaded,
                    _ => true,
                  };

                  //? Our component.
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
                                ),
                            ],
                          ),

                          //? The user's profile picture.
                          Positioned(
                            left: 16.w,
                            bottom: 3.h,
                            child: ChatProfilePicture(
                              user: user,
                              radius: 28.r,
                              showActive: false,
                            ),
                          ),
                        ],
                      ),

                      // Some.
                      const Gap(10),

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
                              const Gap(5),
                            ],

                            //? Fourth the profile overview.
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 5,
                              children: [
                                //? Users following.
                                WayaRichText(
                                  title1: WayaValueHelper.formatNumber(0),
                                  title2: ' Following',
                                  style1: wayaTheme.textTheme.bodySmall?.copyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 11,
                                  ),
                                  style2: wayaTheme.textTheme.bodySmall?.copyWith(
                                    color: wayaTheme.colorScheme.greyColor500,
                                    fontSize: 11,
                                  ),
                                ),

                                //? Followers.
                                WayaRichText(
                                  title1: WayaValueHelper.formatNumber(0),
                                  title2: ' Followers',
                                  style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 11,
                                  ),
                                  style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.greyColor500,
                                    fontSize: 11,
                                  ),
                                ),

                                //? Posts.
                                WayaRichText(
                                  title1: WayaValueHelper.formatNumber(0),
                                  title2: ' Posts',
                                  style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 11,
                                  ),
                                  style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.greyColor500,
                                    fontSize: 11,
                                  ),
                                ),

                                //? If this is me...
                                if (isSelf)
                                  WayaRichText(
                                    title1: 'Joined: ',
                                    title2: WayaDateHelper.getMonthlyTimestamp(user.createdAt ?? DateTime.now()),
                                    style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                      color: wayaTheme.colorScheme.black,
                                      fontSize: 11,
                                    ),
                                    style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(
                                      color: wayaTheme.colorScheme.greyColor500,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Some space.
                      const Gap(10),

                      //? The padding here.
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
                            },
                          ),

                          WayaExpandedTabButton(
                            isSelected: selectedPage > 2,
                            text: 'More',
                            controller: _tabController,
                            tabs: [
                              //?
                              WayaExpandedTab(
                                isSelected: selectedPage == 3,
                                text: 'Donations',
                                onTap: () {
                                  if (_pageController.value == 3) return;
                                  _pageController.value = 3;
                                },
                              ),

                              // For groups.
                              WayaExpandedTab(
                                isSelected: selectedPage == 4,
                                text: "Groups",
                                onTap: () {
                                  if (_pageController.value == 4) return;
                                  _pageController.value = 4;
                                },
                              ),

                              // For pages.
                              WayaExpandedTab(
                                isSelected: selectedPage == 5,
                                text: "Pages",
                                onTap: () {
                                  if (_pageController.value == 5) return;
                                  _pageController.value = 5;
                                },
                              ),

                              // For pages.
                              WayaExpandedTab(
                                isSelected: selectedPage == 6,
                                text: "Events",
                                onTap: () {
                                  if (_pageController.value == 6) return;
                                  _pageController.value = 6;
                                },
                              ),

                              // For pages.
                              WayaExpandedTab(
                                isSelected: selectedPage == 7,
                                text: "Products",
                                onTap: () {
                                  if (_pageController.value == 7) return;
                                  _pageController.value = 7;
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
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
