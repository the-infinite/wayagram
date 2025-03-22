import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/group/state/group_state.dart';
import 'package:wayagram/features/group/view/events.dart';
import 'package:wayagram/features/group/view/group_post.dart';
import 'package:wayagram/features/group/view/media_post.dart';
import 'package:wayagram/features/group/view/report_group.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/shared/cache/group.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';

import 'private_group.dart';

class PublicGroup extends ConsumerStatefulWidget {
  static const route = '/groups/public';
  final String id;

  // Construct.
  const PublicGroup({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublicGroupState();
}

class _PublicGroupState extends ConsumerState<PublicGroup> with SingleTickerProviderStateMixin {
  late final groupProvider = singleGroupProvider("group-${widget.id}");
  late final notifier = ref.read(groupProvider.notifier);
  final handler = WayaObservableScrollController();
  final loadingController = ValueNotifier(false);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  Future<GroupModel?> _getGroup() async {
    final found = wayaGroupCache.getCachedData(widget.id);
    return found ?? (await myGroupNotifier.getSingleGroup(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(groupProvider);

    //? Now build the widget.
    return WayaFutureSubscriber(
      future: _getGroup(),
      suspense: (context) => const SizedBox(),
      builder: (context, data) {
        //? You can now return this.
        final group = wayaGroupCache.getCachedData(widget.id) ?? data;
    
        //? If the page is not yet defined...
        if (group == null) {
          return const SizedBox();
        }
    
        //? Fetch the data of this page.
        if (group.ownerId == ConversationState.self.id) {
          return PrivateGroup(group: group);
        }
    
        //? Now, we can move forward.
        return WayaScaffold(
            padding: EdgeInsets.zero,
            isLoading: state.isLoading,
            isScrollable: false,
            appBarTrailing: Row(
              spacing: 12,
              children: [
                WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
                InkWell(
                  onTap: () => Share.share(
                    WayaValueHelper.getShareableUrl(WayaAppRoutes.getGroupDetailsPage(widget.id)),
                    subject: 'Share ${group.name}',
                  ),
                  child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                ),
                PopupMenuButton(
                  onSelected: (value) {},
                  iconColor: wayaTheme.colorScheme.greyColor400,
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) {
                    return [
                      //   PopupMenuItem<int>(
                      //     value: 0,
                      //     onTap: () {
                      //       WayaNav.goBack();
                      //       //WayaNav.toNamed('/groupSetting');
                      //     },
                      //     child: WayaActionNav(
                      //       context: context,
                      //       asset: SvgPicture.asset(
                      //         'assets/images/pages/mute.svg',
                      //         height: 20,
                      //       ),
                      //       text: "  Mute Group",
                      //       color: wayaTheme.colorScheme.customBlack,
                      //     ),
                      //   ),
                      PopupMenuItem<int>(
                        value: 1,
                        onTap: () => Share.share(
                          WayaValueHelper.getShareableUrl(WayaAppRoutes.getGroupDetailsPage(widget.id)),
                          subject: 'Share ${group.name}',
                        ),
                        child: WayaActionNav(
                          context: context,
                          asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                          text: "  Share Group link",
                          color: wayaTheme.colorScheme.customBlack,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        onTap: () async {
                          WayaNav.goBack();
                          await WayaUtils.showModalSheet(
                            context,
                            child: ReportGroup(
                              statuses: groupReport,
                              currentStatus: "",
                              groupId: widget.id,
                            ),
                          );
                        },
                        child: WayaActionNav(
                          context: context,
                          asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                          text: "  Report Group",
                          color: wayaTheme.colorScheme.customBlack,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 3,
                        onTap: () async {
                          if (await myGroupNotifier.leaveGroup(widget.id)) {
                            WayaNav.goBack();
                          }
                        },
                        child: WayaActionNav(
                          context: context,
                          asset: WayaAssets.images.pages.doorOpen.svg(
                            color: wayaTheme.colorScheme.error500,
                            height: 20,
                          ),
                          text: "  Leave Group",
                          color: wayaTheme.colorScheme.error500,
                        ),
                      )
                    ];
                  },
                  child: WayaAssets.icons.genSet.moreHorz.svg(
                    fit: BoxFit.none,
                  ),
                ),
                Gap(8)
              ],
            ),
            body: WayaObservableScrollView(
              handler: handler,
              shouldFetch: !state.isLoading,
              isAtEnd: !state.hasMorePosts,
              scrollNotice: 120,
              onReachEnd: () async => await notifier.getGroupSinglePosts(widget.id),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200.h, // Banner height
                            decoration: BoxDecoration(
                              color: WayaColors.primaryBrown50,
                              borderRadius: BorderRadius.circular(0),
                              image: group.coverImage != null
                                  ? DecorationImage(
                                      image: NetworkImage(group.coverImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: AssetImage(WayaAssets.images.pages.imagePlaceholder.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
    
                          // Some space.
                          Gap(15),
    
                          //? The button to click when you want to see the profiles
                          //? of group members.
                          if (myGroupNotifier.isMemberOf(widget.id) || !group.isPrivate)
                            GestureDetector(
                              onTap: () => WayaNav.toNamed('/groups/members', arguments: widget.id),
                              child: Container(
                                margin: EdgeInsets.only(right: 20.w),
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: wayaTheme.colorScheme.primary600, width: 1.5),
                                  color: wayaTheme.colorScheme.white,
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Text(
                                  'Member',
                                  style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                                    color: wayaTheme.colorScheme.primary600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
    
                      //? Now, for the group profile picture.
                      Positioned(
                        left: 16.w,
                        top: 190,
                        child: WayaDp(
                          radius: 30.r,
                          image: group.profileImage,
                          isSelf: false,
                          isEdit: false,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
    
                  //? Now, the section for its posts.
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          //'${viewModel.name?.capitalizeFirst}',
                          group.name,
                          style: wayaTheme.textTheme.bodyMedium,
                        ),
    
                        //? Now, the description.
                        Text(
                          group.description,
                          style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: wayaTheme.colorScheme.greyColor500,
                          ),
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            actionType(
                              WayaValueHelper.formatNumber(group.memberCount),
                              'Members',
                              onPressed: () => WayaNav.toNamed(
                                '/groups/members',
                                arguments: widget.id,
                              ),
                            ),
                            const Gap(10),
    
                            //? This is fine.
                            actionType(
                              WayaValueHelper.formatNumber(state.postCount ?? 0),
                              'Posts',
                            ),
                          ],
                        ),
    
                        //? When the user is a member of this group.
                        if (myGroupNotifier.isMemberOf(widget.id)) ...[
                          Row(
                            children: [
                              WayaTabButton(
                                isSelected: _selectedIndex == 0,
                                text: 'Posts',
                                onTap: () => setState(() => _selectedIndex = 0),
                              ),
                              WayaTabButton(
                                isSelected: _selectedIndex == 1,
                                text: 'Events',
                                onTap: () => setState(() => _selectedIndex = 1),
                              ),
                              WayaTabButton(
                                isSelected: _selectedIndex == 2,
                                text: 'Media',
                                onTap: () => setState(() => _selectedIndex = 2),
                              ),
                            ],
                          ),
                          _selectedIndex == 0
                              ? GroupPost(
                                  groupId: widget.id,
                                )
                              : _selectedIndex == 1
                                  ? Events()
                                  : MediaPost(groupId: widget.id)
                        ]
    
                        //? Since the user has not joined and it is private
                        else if (group.isPrivate) ...[
                          Gap(100.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //? First, the lock icon.
                              WayaAssets.icons.genSet.lock.svg(),
    
                              // Some space.
                              Gap(10.h),
    
                              //? The private text.
                              Text('This group is private', style: wayaTheme.textTheme.titleLarge),
    
                              // Some space.
                              Gap(10.h),
    
                              //?
                              Text(
                                'You must join to see posts and participate',
                                style: wayaTheme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: WayaConstants.fontFamily,
                                  fontSize: 16.sp,
                                ),
                              ),
    
                              // Some space.
                              Gap(30.h),
    
                              //? Now, let this fly.
                              WayaProgressiveButton(
                                notifier: loadingController,
                                callback: () async => await myGroupNotifier.joinGroup(widget.id),
                                text: 'Join & Request Access',
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: SizedBox(
              height: 50,
              width: 50,
              child: WayaButton(
                callback: () {
                  WayaNav.toNamed('/createGroupPost', arguments: widget.id);
                },
                height: 50,
                centerWidget: Center(
                  child: Icon(
                    Icons.add,
                    color: wayaTheme.colorScheme.white,
                    size: 40,
                  ),
                ),
              ),
            ));
      },
    );
  }

  actionType(txt, txt2, {onPressed}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Row(
        children: [
          Text(txt, style: wayaTheme.textTheme.bodySmall),
          const Gap(3),
          Text(
            txt2,
            style: wayaTheme.textTheme.bodyMedium!
                .wayaCopyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: wayaTheme.colorScheme.greyColor500),
          ),
        ],
      ),
    );
  }

  cancelRequest(onTap, cancel) {
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          WayaAssets.icons.genSet.lock.path,
        ),
        Text('This group is private', style: wayaTheme.textTheme.titleLarge),
        Gap(10),
        Text('You must join to see posts and participate',
            style: wayaTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w400,
              fontFamily: WayaConstants.fontFamily,
              fontSize: 16.sp,
            )),
        const Gap(30),
        WayaButton(
          callback: onTap,
          color: wayaTheme.colorScheme.white,
          textColor: wayaTheme.colorScheme.greyColor700,
          text: 'Access to Group requested',
        ),
        Gap(10),
        InkWell(
          onTap: cancel,
          child: Text('Cancel request', style: wayaTheme.textTheme.titleSmall),
        ),
      ],
    );
  }
}
