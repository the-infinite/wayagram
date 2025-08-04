import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/data/model/all_group_member_model.dart';
import 'package:wayagram/features/group/view/group_team.dart';



class GroupMemberCardWidget extends StatelessWidget {
  const GroupMemberCardWidget({
    super.key,
    required this.groupMember,
    required this.widget,
    required this.wayaTheme,
    required this.ref,
  });

  final AllGroupMemberDocs? groupMember;
  final GroupTeam widget;
  final ThemeData wayaTheme;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => WayaNav.toNamed('/groups/members/edit',
          arguments: {
            'email': groupMember?.user?.email,
            'id': groupMember?.userId,
            'groupId': widget.groupId,
          }),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(10),
            Container(
              padding:
              const EdgeInsets.fromLTRB(4, 1, 4, 1),
              width: 80.w,
              decoration: BoxDecoration(
                color: groupMember?.role == 'admin' ||
                    groupMember?.role == 'owner'
                    ? wayaTheme.colorScheme.success50
                    : wayaTheme.colorScheme.primary50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset(
                    groupMember?.role == 'admin' ||
                        groupMember?.role == 'owner'
                        ? 'assets/images/pages/crown.png'
                        : groupMember?.role == 'editor'
                        ? 'assets/images/pages/editor.png'
                        : 'assets/images/pages/moderator.png',
                    height: 8.h,
                  ),
                  const Gap(5),
                  Text(
                    "${groupMember?.role?.capitalizeFirst}",
                    style: TextStyle().wayaCopyWith(
                      color:
                      groupMember?.role == 'admin' ||
                          groupMember?.role == 'owner'
                          ? wayaTheme.colorScheme.success
                          : WayaColors.primary700,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            //Gap(10),
            ListTile(
              contentPadding: EdgeInsets.only(
                  left: 0, right: 0, top: 0),
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: WayaColors.greyColor100,
                backgroundImage: NetworkImage(
                  '${groupMember?.user?.profilePicture}',
                ),
              ),
              title: Row(
                children: [
                  Text(
                    '${groupMember?.user?.firstName} ${groupMember?.user?.lastName}',
                    style: wayaTheme.textTheme.bodyMedium!
                        .wayaCopyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: wayaTheme.colorScheme.black,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                '${groupMember?.user?.email}',
                style: wayaTheme.textTheme.bodyMedium!
                    .wayaCopyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),
              trailing: Padding(
                padding: EdgeInsets.only(right: 20),
                child: PopupMenuButton(
                  onSelected: (value) {},
                  iconColor:
                  wayaTheme.colorScheme.greyColor400,
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        onTap: () {
                          WayaNav.toNamed(
                              '/groups/members/edit',
                              arguments: {
                                'email': groupMember?.user?.email,
                                'id': groupMember?.userId,
                                'groupId': widget.groupId,
                              });
                        },
                        child: WayaActionNav(
                          context: context,
                          asset: WayaAssets.images.pages.editor
                              .image(color: wayaTheme.colorScheme.greyColor600,
                            height: 20,
                          ),
                          text: "  Edit member info",
                          color: wayaTheme
                              .colorScheme.customBlack,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        onTap: () {
                          ref.read(widget.provider.notifier).removeTeamMember(context, '${groupMember?.userId}',
                              widget.groupId);

                        },
                        child: WayaActionNav(
                          context: context,
                          asset: WayaAssets
                              .images.pages.delete
                              .svg(
                            color: wayaTheme
                                .colorScheme.error500,
                            height: 20,
                          ),
                          text: "Remove member",
                          color: wayaTheme
                              .colorScheme.error500,
                        ),
                      ),
                    ];
                  },
                  child:
                  WayaAssets.icons.genSet.moreHorz.svg(
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}