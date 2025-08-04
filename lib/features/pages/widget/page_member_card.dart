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
import 'package:wayagram/features/pages/data/model/get_page_member_model.dart';
import 'package:wayagram/features/pages/view/team_page.dart';

class PageMemberCardWidget extends StatelessWidget {
  const PageMemberCardWidget({
    super.key,
    required this.pageMember,
    required this.widget,
    required this.wayaTheme,
    required this.ref,
  });

  final GetPageMemberDocs? pageMember;
  final TeamPage widget;
  final ThemeData wayaTheme;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => WayaNav.toNamed('/pages/members/edit',
          arguments: {
            'email': pageMember?.user?.email,
            'id': pageMember?.userId,
            'pageId': widget.pageId,
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
                color: pageMember?.role == 'admin' ||
                    pageMember?.role == 'owner'
                    ? wayaTheme.colorScheme.success50
                    : wayaTheme.colorScheme.primary50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset(
                    pageMember?.role == 'admin' ||
                        pageMember?.role == 'owner'
                        ? 'assets/images/pages/crown.png'
                        : pageMember?.role == 'editor'
                        ? 'assets/images/pages/editor.png'
                        : 'assets/images/pages/moderator.png',
                    height: 8.h,
                  ),
                  const Gap(5),
                  Text(
                    "${pageMember?.role?.capitalizeFirst}",
                    style: TextStyle().wayaCopyWith(
                      color: pageMember?.role == 'admin' ||
                          pageMember?.role == 'owner'
                          ? wayaTheme.colorScheme.success
                          : WayaColors.primary700,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(
                  left: 0, right: 0, top: 0),
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: WayaColors.greyColor100,
                backgroundImage: NetworkImage(
                  '${pageMember?.user?.profilePicture}',
                ),
              ),
              title: Row(
                children: [
                  Text(
                    '${pageMember?.user?.firstName} ${pageMember?.user?.lastName}',
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
                '${pageMember?.user?.email}',
                style: wayaTheme.textTheme.bodyMedium!
                    .wayaCopyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),
              trailing:  Padding(
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
                          WayaNav.toNamed('/pages/members/edit',
                              arguments: {
                                'email': pageMember?.user?.email,
                                'id': pageMember?.userId,
                                'pageId': widget.pageId,
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
                          ref.read(widget.provider.notifier).removeTeamMember(context, '${pageMember?.userId}',
                              widget.pageId);
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
                          text: " Remove member",
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