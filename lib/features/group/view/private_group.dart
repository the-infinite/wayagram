import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/view/approval_screen.dart';
import 'package:wayagram/features/group/view/edit_group_info.dart';
import 'package:wayagram/features/group/view/events.dart';
import 'package:wayagram/features/group/view/group_post.dart';
import 'package:wayagram/features/group/view/group_team.dart';
import 'package:wayagram/features/group/view/media_post.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/promotion/data/models/promotion_service_type.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'package:wayagram/shared/cache/group.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';

class PrivateGroup extends ConsumerStatefulWidget {
  final GroupModel group;

  const PrivateGroup({super.key, required this.group});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrivateGroupState();
}

class _PrivateGroupState extends ConsumerState<PrivateGroup> with SingleTickerProviderStateMixin {
  late final groupProvider = singleGroupProvider("group-${widget.group.id}");
  late final notifier = ref.read(groupProvider.notifier);
  int _selectedIndex = 0;
  GroupModel? _thisGroup;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.read(groupProvider);

    //? Return this component.
    final group = wayaGroupCache.getCachedData(widget.group.id) ?? _thisGroup;

    return WayaScaffold(
      padding: EdgeInsets.zero,
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Row(
        children: [
          InkWell(
              onTap: ()=> WayaNav.toNamed('/searchGroupAndPage',
                  arguments: {
                    'groupId': widget.group.id,
                    'name': 'group'
                  }
              ),
              child: WayaAssets.icons.genSet.search.svg(fit: BoxFit.none)),
          const Gap(12),
          InkWell(
            onTap: () => Share.share(
              WayaValueHelper.getShareableUrl(WayaAppRoutes.getGroupDetailsPage(widget.group.id)),
              subject: 'Share ${widget.group.name}',
            ),
            child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
          ),
          PopupMenuButton(
            onSelected: (value) {},
            iconColor: wayaTheme.colorScheme.greyColor400,
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  onTap: () {
                    WayaNav.goBack();
                    WayaNav.toNamed('/groupSetting', arguments: {
                      'groupId': widget.group.id
                    });
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: SvgPicture.asset('assets/images/pages/setting.svg'),
                    text: "Group settings",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  onTap: () => Share.share(
                    WayaValueHelper.getShareableUrl(WayaAppRoutes.getGroupDetailsPage(widget.group.id)),
                    subject: 'Share ${widget.group.name}',
                  ),
                  child: WayaActionNav(
                    context: context,
                    asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                    text: "Share Group link",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  onTap: () {
                    WayaNav.goBack();
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                    text: "Repost",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  onTap: () {
                    WayaNav.goBack();
                    WayaNav.toNamed(Promote.route, arguments: {
                      "contentId": widget.group.id,
                      "contentType": PromotionServiceType.page.name,
                      "data": group
                    });
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: SvgPicture.asset(
                      WayaAssets.icons.mFire.path,
                      height: 20,
                    ),
                    text: "Promote Group",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  onTap: () async {
                    await myGroupNotifier.deleteGroup(widget.group.id);
                    WayaNav.goBack(closeOverlays: true);
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: SvgPicture.asset(
                      'assets/images/pages/delete.svg',
                      color: wayaTheme.colorScheme.error500,
                      height: 16,
                    ),
                    text: "Delete Group",
                    color: wayaTheme.colorScheme.error500,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
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
                    height: 200, // Banner height
                    decoration: BoxDecoration(
                      color: WayaColors.primaryBrown50,
                      borderRadius: BorderRadius.circular(0),
                      image: widget.group.coverImage != null
                          ? DecorationImage(
                              image: NetworkImage(widget.group.coverImage!),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage('assets/images/pages/image_placeholder.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Gap(15),
                  GestureDetector(
                    onTap: () async {
                      final result = await WayaNav.to(
                        transition: Transition.circularReveal,
                        duration: const Duration(milliseconds: 500),
                        EditGroupInfo(
                          group: widget.group,
                        ),
                      );

                      //? If this is fine.
                      if (result != null) return;
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.w),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: wayaTheme.colorScheme.primary600, width: 1.5),
                        color: wayaTheme.colorScheme.white,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Text(
                        'Edit Group Info',
                        style: wayaTheme.textTheme.labelSmall
                            ?.wayaCopyWith(color: wayaTheme.colorScheme.primary600, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 16.w,
                top: 170.h,
                child: WayaDp(
                  radius: 30.r,
                  image: widget.group.profileImage,
                  isSelf: false,
                  isEdit: false,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.group.name,
                  style: wayaTheme.textTheme.bodyMedium,
                ),
                Text(
                  widget.group.description,
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
                      WayaValueHelper.formatNumber(widget.group.memberCount),
                      'Members',
                      onPressed: () => WayaNav.toNamed(WayaAppRoutes.getGroupMembersPage(widget.group.id)),
                    ),
                    const Gap(10),
                    actionType(
                      WayaValueHelper.formatNumber(viewModel.postCount ?? 0),
                      'Posts',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Gap(10),

          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'Posts',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              //   WayaTabButton(
              //     isSelected: _selectedIndex == 1,
              //     text: 'Events',
              //     onTap: () => setState(() => _selectedIndex = 1),
              //   ),
              WayaTabButton(
                isSelected: _selectedIndex == 2,
                text: 'Media',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 3,
                text: 'Approvals',
                onTap: () => setState(() => _selectedIndex = 3),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 4,
                text: 'Team',
                onTap: () => setState(() => _selectedIndex = 4),
              ),
            ],
          ),

          //? Selected content.
          _selectedIndex == 0
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: GroupPost(
                    provider: groupProvider,
                    id: widget.group.id,
                  ),
                )
              : _selectedIndex == 1
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Events(),
                    )
                  : _selectedIndex == 2
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: MediaPost(
                            provider: groupProvider,
                            id: widget.group.id,
                          ),
                        )
                      : _selectedIndex == 3
                          ? ApprovalScreen(
                              provider: groupProvider,
                              groupId: widget.group.id,
                            )
                          : GroupTeam(
                              provider: groupProvider,
                              groupId: widget.group.id,
                            ),
          //AllOrders()
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: WayaButton(
          callback: () => WayaNav.toNamed(WayaAppRoutes.getGroupPostScreen(widget.group.id)),
          height: 50,
          centerWidget: Center(
            child: Icon(
              Icons.add,
              color: wayaTheme.colorScheme.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget actionType(String txt, String txt2, {VoidCallback? onPressed}) {
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
            style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: wayaTheme.colorScheme.greyColor500,
            ),
          ),
        ],
      ),
    );
  }
}
