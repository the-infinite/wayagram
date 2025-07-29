import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/cache/group.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';

class GroupTeam extends ConsumerStatefulWidget {
  final String groupId;
  final GroupProviderFamily provider;
  const GroupTeam({
    super.key,
    required this.groupId,
    required this.provider,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupTeamState();
}

class _GroupTeamState extends ConsumerState<GroupTeam>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(widget.provider.notifier).getGroupMembers(widget.groupId);
    });
  }

  final bool vertical = false;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(widget.provider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      color: wayaTheme.colorScheme.greyColor50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Some space
          Gap(20.h),

          //? Add a new member.
          WayaButton(
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(8),
                Text(
                  "Add New Team Member",
                  style: TextStyle().wayaCopyWith(
                    color: wayaTheme.colorScheme.customPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            callback: () => WayaNav.toNamed(
                WayaAppRoutes.getAddGroupMemberPage(widget.groupId)),
            color: wayaTheme.colorScheme.primary50,
          ),
          Gap(10.h),
          if (viewModel.allGroupMemberDocs!.isEmpty)
            PostEmptyState()
          else
            // ListView.builder(
            //     padding: EdgeInsets.only(bottom: 50.h),
            //     physics: const NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: viewModel.allGroupMemberDocs?.length,
            //     itemBuilder: (_, index) {
            //       final group = viewModel.allGroupMemberDocs?[index];
            //       return ValueListenableBuilder(
            //           valueListenable: wayaGroupCache,
            //           builder: (context, redraws, _) {
            //             return InkWell(
            //               onTap: () => WayaNav.toNamed('/groups/members/edit',
            //                   arguments: {
            //                     'email': group?.user?.email,
            //                     'id': group?.userId,
            //                     'groupId': widget.groupId,
            //                   }),
            //               child: Container(
            //                 margin: EdgeInsets.only(bottom: 15),
            //                 padding: EdgeInsets.only(left: 10),
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(12),
            //                     color: Colors.white),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Gap(10),
            //                     Container(
            //                       padding:
            //                           const EdgeInsets.fromLTRB(4, 1, 4, 1),
            //                       width: 80.w,
            //                       decoration: BoxDecoration(
            //                         color: group?.role == 'admin' ||
            //                                 group?.role == 'owner'
            //                             ? wayaTheme.colorScheme.success50
            //                             : wayaTheme.colorScheme.primary50,
            //                         borderRadius: BorderRadius.circular(10),
            //                       ),
            //                       child: Row(
            //                         children: [
            //                           Image.asset(
            //                             group?.role == 'admin' ||
            //                                     group?.role == 'owner'
            //                                 ? 'assets/images/pages/crown.png'
            //                                 : group?.role == 'editor'
            //                                     ? 'assets/images/pages/editor.png'
            //                                     : 'assets/images/pages/moderator.png',
            //                             height: 8.h,
            //                           ),
            //                           const Gap(5),
            //                           Text(
            //                             "${group?.role?.capitalizeFirst}",
            //                             style: TextStyle().wayaCopyWith(
            //                               color: group?.role == 'admin' ||
            //                                       group?.role == 'owner'
            //                                   ? wayaTheme.colorScheme.success
            //                                   : WayaColors.primary700,
            //                               fontWeight: FontWeight.w500,
            //                               fontSize: 11.sp,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     //Gap(10),
            //                     ListTile(
            //                       contentPadding: EdgeInsets.only(
            //                           left: 0, right: 0, top: 0),
            //                       leading: CircleAvatar(
            //                         radius: 20,
            //                         backgroundColor: WayaColors.greyColor100,
            //                         backgroundImage: NetworkImage(
            //                           '${group?.user?.profilePicture}',
            //                         ),
            //                       ),
            //                       title: Row(
            //                         children: [
            //                           Text(
            //                             '${group?.user?.firstName} ${group?.user?.lastName}',
            //                             style: wayaTheme.textTheme.bodyMedium!
            //                                 .wayaCopyWith(
            //                               fontSize: 14.sp,
            //                               fontWeight: FontWeight.w600,
            //                               color: wayaTheme.colorScheme.black,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       subtitle: Text(
            //                         '${group?.user?.email}',
            //                         style: wayaTheme.textTheme.bodyMedium!
            //                             .wayaCopyWith(
            //                           fontSize: 12.sp,
            //                           fontWeight: FontWeight.w400,
            //                           color: wayaTheme.colorScheme.greyColor500,
            //                         ),
            //                       ),
            //                       trailing: Padding(
            //                         padding: EdgeInsets.only(right: 20),
            //                         child: PopupMenuButton(
            //                           onSelected: (value) {},
            //                           iconColor:
            //                               wayaTheme.colorScheme.greyColor400,
            //                           position: PopupMenuPosition.under,
            //                           itemBuilder: (context) {
            //                             return [
            //                               PopupMenuItem<int>(
            //                                 value: 0,
            //                                 onTap: () {
            //                                   WayaNav.toNamed(
            //                                       '/groups/members/edit',
            //                                       arguments: {
            //                                         'email': group?.user?.email,
            //                                         'id': group?.userId,
            //                                         'groupId': widget.groupId,
            //                                       });
            //                                 },
            //                                 child: WayaActionNav(
            //                                   context: context,
            //                                   asset: WayaAssets.images.pages.editor
            //                                       .image(color: wayaTheme.colorScheme.greyColor600,
            //                                     height: 20,
            //                                   ),
            //                                   text: "  Edit Group",
            //                                   color: wayaTheme
            //                                       .colorScheme.customBlack,
            //                                 ),
            //                               ),
            //                               PopupMenuItem<int>(
            //                                 value: 1,
            //                                 onTap: () {
            //                                  // await myGroupNotifier.removeGroupMember('${group?.userId}',
            //                                  //      widget.groupId);
            //                                   ref.read(createGroupProvider.notifier)
            //                                       .removeTeamMember(context, '${group?.userId}', widget.groupId);
            //
            //                                   setState(() {});
            //                                 },
            //                                 child: WayaActionNav(
            //                                   context: context,
            //                                   asset: WayaAssets
            //                                       .images.pages.delete
            //                                       .svg(
            //                                     color: wayaTheme
            //                                         .colorScheme.error500,
            //                                     height: 20,
            //                                   ),
            //                                   text: "Remove member",
            //                                   color: wayaTheme
            //                                       .colorScheme.error500,
            //                                 ),
            //                               ),
            //                             ];
            //                           },
            //                           child:
            //                               WayaAssets.icons.genSet.moreHorz.svg(
            //                             fit: BoxFit.none,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             );
            //           });
            //     }),
          ///

    ListView.builder(
          padding: EdgeInsets.only(bottom: 50.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel.allGroupMemberDocs?.length,
        itemBuilder: (_, index){

       return ValueListenableBuilder(
           valueListenable: wayaGroupCache,
           builder: (context, redraws, _) {
             final group = viewModel.allGroupMemberDocs?[index];
             final groupMember = wayaGroupCache.getCachedData(widget.groupId);
             if (groupMember == null) {
               return SizedBox();
             }
             //? If this is in vertical orientation.
             if (vertical) {
               return InkWell(
                 onTap: () => WayaNav.toNamed('/groups/members/edit',
                     arguments: {
                       'email': group?.user?.email,
                       'id': group?.userId,
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
                           color: group?.role == 'admin' ||
                               group?.role == 'owner'
                               ? wayaTheme.colorScheme.success50
                               : wayaTheme.colorScheme.primary50,
                           borderRadius: BorderRadius.circular(10),
                         ),
                         child: Row(
                           children: [
                             Image.asset(
                               group?.role == 'admin' ||
                                   group?.role == 'owner'
                                   ? 'assets/images/pages/crown.png'
                                   : group?.role == 'editor'
                                   ? 'assets/images/pages/editor.png'
                                   : 'assets/images/pages/moderator.png',
                               height: 8.h,
                             ),
                             const Gap(5),
                             Text(
                               "${group?.role?.capitalizeFirst}",
                               style: TextStyle().wayaCopyWith(
                                 color:
                                 group?.role == 'admin' ||
                                     group?.role == 'owner'
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
                             '${group?.user?.profilePicture}',
                           ),
                         ),
                         title: Row(
                           children: [
                             Text(
                               '${group?.user?.firstName} ${group?.user?.lastName}',
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
                           '${group?.user?.email}',
                           style: wayaTheme.textTheme.bodyMedium!
                               .wayaCopyWith(
                             fontSize: 12.sp,
                             fontWeight: FontWeight.w400,
                             color: wayaTheme.colorScheme.greyColor500,
                           ),
                         ),
                         trailing:
                         group?.role == 'admin' ||
                             group?.role == 'owner'
                             ? Container() : Padding(
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
                                           'email': group?.user?.email,
                                           'id': group?.userId,
                                           'groupId': widget.groupId,
                                         });
                                   },
                                   child: WayaActionNav(
                                     context: context,
                                     asset: WayaAssets.images.pages.editor
                                         .image(color: wayaTheme.colorScheme.greyColor600,
                                       height: 20,
                                     ),
                                     text: "  Edit Group",
                                     color: wayaTheme
                                         .colorScheme.customBlack,
                                   ),
                                 ),
                                 PopupMenuItem<int>(
                                   value: 1,
                                   onTap: () async{
                                     await myGroupNotifier.removeGroupMember('${group?.userId}',
                                          widget.groupId);
                                     // ref.read(createGroupProvider.notifier)
                                     //     .removeTeamMember(context, '${group?.userId}', widget.groupId);

                                     setState(() {});
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
             // Build and return our component.
             return InkWell(
               onTap: () => WayaNav.toNamed('/groups/members/edit',
                   arguments: {
                     'email': group?.user?.email,
                     'id': group?.userId,
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
                         color: group?.role == 'admin' ||
                             group?.role == 'owner'
                             ? wayaTheme.colorScheme.success50
                             : wayaTheme.colorScheme.primary50,
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Row(
                         children: [
                           Image.asset(
                             group?.role == 'admin' ||
                                 group?.role == 'owner'
                                 ? 'assets/images/pages/crown.png'
                                 : group?.role == 'editor'
                                 ? 'assets/images/pages/editor.png'
                                 : 'assets/images/pages/moderator.png',
                             height: 8.h,
                           ),
                           const Gap(5),
                           Text(
                             "${group?.role?.capitalizeFirst}",
                             style: TextStyle().wayaCopyWith(
                               color: group?.role == 'admin' ||
                                   group?.role == 'owner'
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
                           '${group?.user?.profilePicture}',
                         ),
                       ),
                       title: Row(
                         children: [
                           Text(
                             '${group?.user?.firstName} ${group?.user?.lastName}',
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
                         '${group?.user?.email}',
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
                                   WayaNav.toNamed(
                                       '/groups/members/edit',
                                       arguments: {
                                         'email': group?.user?.email,
                                         'id': group?.userId,
                                         'groupId': widget.groupId,
                                       });
                                 },
                                 child: WayaActionNav(
                                   context: context,
                                   asset: WayaAssets.images.pages.editor
                                       .image(color: wayaTheme.colorScheme.greyColor600,
                                     height: 20,
                                   ),
                                   text: "  Edit Group",
                                   color: wayaTheme
                                       .colorScheme.customBlack,
                                 ),
                               ),
                               PopupMenuItem<int>(
                                 value: 1,
                                 onTap: () {
                                   // await myGroupNotifier.removeGroupMember('${group?.userId}',
                                   //      widget.groupId);
                                   ref.read(createGroupProvider.notifier)
                                       .removeTeamMember(context, '${group?.userId}', widget.groupId);

                                   setState(() {});
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
           });
    })

        ],
      ),
    );
  }
}

class PostEmptyState extends StatelessWidget {
  const PostEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              //WayaNav.toNamed(CreatePost.route);
            },
            buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(
                  wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You don't have team members yet"),
      ),
    );
  }
}
