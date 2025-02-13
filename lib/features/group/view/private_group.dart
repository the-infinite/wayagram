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
import 'package:wayagram/features/group/view/approval_screen.dart';
import 'package:wayagram/features/group/view/events.dart';
import 'package:wayagram/features/group/view/group_team.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/view/pages_for_you.dart';

class PrivateGroup extends ConsumerStatefulWidget {
  static const route = '/privateGroup';
  const PrivateGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrivateGroupState();
}

class _PrivateGroupState extends ConsumerState<PrivateGroup> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final viewGroupModel = ref.watch(createGroupProvider.notifier);

    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    return WayaScaffold(
      onTapBackButton: () {
        WayaNav.toNamed('/groups');
        //Navigator.pushNamed(context, BottomView.route, arguments: 5);
      },
      padding: EdgeInsets.zero,
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Row(
        spacing: 12,
        children: [
          WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
          InkWell(
            onTap: () => Share.share('${args['url']}'),
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
                    child: _buildActionNav(
                      context: context,
                      onTap: () {
                        Navigator.pop(context);
                        WayaNav.toNamed('/groupSetting');
                      },
                      asset: SvgPicture.asset('assets/images/pages/setting.svg'),
                      text: "Group settings",
                      color: wayaTheme.colorScheme.customBlack,
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: _buildActionNav(
                        context: context,
                        onTap: () {
                          Share.share('${args['url']}');
                        },
                        asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                        text: "Share Group link",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: _buildActionNav(
                        context: context,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                        text: "Repost",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: _buildActionNav(
                        context: context,
                        onTap: () {
                          viewGroupModel.deleteGroup(context, '', '${ConversationState.self.id}');
                          Navigator.pop(context);
                        },
                        asset: SvgPicture.asset(
                          'assets/images/pages/delete.svg',
                          color: wayaTheme.colorScheme.error500,
                          height: 2,
                        ),
                        text: "Delete Group",
                        color: wayaTheme.colorScheme.error500),
                  )
                ];
              },
              child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none)),
          Gap(8)
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
                        image:
                            //viewModel.profileImage!=null
                            args['profileImage'] != null
                                ? DecorationImage(
                                    image: NetworkImage('${args['profileImage']}'),
                                    //image: NetworkImage('${viewModel.profileImage}'),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: AssetImage('assets/images/pages/image_placeholder.png'),
                                    fit: BoxFit.cover,
                                  )),
                  ),
                  Gap(15),
                  GestureDetector(
                    onTap: () {
                      WayaNav.toNamed('/editGroupInfo', arguments: '${args['groupId']}');
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
                  top: 190,
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: WayaColors.greyColor100,
                      backgroundImage: NetworkImage('${args['coverImage']}')
                      //NetworkImage('${viewModel.coverImage}'),
                      )),
            ],
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${args['name']}', style: wayaTheme.textTheme.bodyMedium),
                Text(
                  '${args['desc']}',
                  //'Find your sound . Discuss writing, composing, recording, and much more',
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 12, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
                ),
                const Gap(10),
                Row(
                  children: [
                    actionType('${args['memberCount']}', 'Members', onPressed: () => WayaNav.toNamed('/membersScreen')),
                    const Gap(10),
                    actionType('0', 'Posts'),
                  ],
                ),
                const Gap(10),
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

                //const Gap(20),
              ],
            ),
          ),

          _selectedIndex == 0
              ? PagesForYou()
              : _selectedIndex == 1
                  ? Events()
                  : _selectedIndex == 2
                      ? PagesForYou()
                      : _selectedIndex == 3
                          ? ApprovalScreen(
                              groupId: '${args['groupId']}',
                            )
                          : GroupTeam(groupId: '${args['groupId']}')
          //AllOrders()
        ],
      ),
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
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
          ),
        ],
      ),
    );
  }

  InkWell _buildActionNav({
    required BuildContext context,
    required VoidCallback onTap,
    required Widget asset,
    required String text,
    required Color color,
  }) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(color: color, fontWeight: FontWeight.w500, fontSize: 12),
          )
        ],
      ),
    );
  }
}
