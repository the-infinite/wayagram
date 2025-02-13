

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
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';


class GroupTeam extends ConsumerStatefulWidget {
  final String groupId;
  const GroupTeam({super.key, required this.groupId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupTeamState();
}

class _GroupTeamState extends ConsumerState<GroupTeam> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('TESTING Group Team ID ${widget.groupId}');
      ref.read(createGroupProvider.notifier).getGroupMembers(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, right: 15, ),
      color:wayaTheme.colorScheme.greyColor50 ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WayaButton(
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Gap(8),
                Text(
                  "Add New Team Member",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
            callback: () {
              WayaNav.toNamed('/addGroupMember');
            },
            color: wayaTheme.colorScheme.primar50,
          ),
          const Gap(8),
          viewModel.allGroupMemberDocs!.isEmpty ? PostEmptyState():
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.allGroupMemberDocs?.length,
              itemBuilder: (_, index){
                final group = viewModel.allGroupMemberDocs?[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                        width: 80.w,
                        decoration: BoxDecoration(
                          color:group?.role == 'admin' || group?.role == 'owner'?
                          wayaTheme.colorScheme.success50: wayaTheme.colorScheme.primar50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              group?.role == 'admin' || group?.role == 'owner'?'assets/images/pages/crown.png':
                              group?.role == 'editor'?
                              'assets/images/pages/editor.png': 'assets/images/pages/moderator.png', height: 8.h,),
                            const Gap(5),
                            Text(
                              "${group?.role?.capitalizeFirst}",
                              style: TextStyle().wayaCopyWith(
                                color: group?.role == 'admin' || group?.role == 'owner'?
                                wayaTheme.colorScheme.success: WayaColors.primary700,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,

                              ),
                            ),
                          ],
                        ),
                      ),
                      //Gap(10),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0),
                        leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: WayaColors.greyColor100,
                            backgroundImage: NetworkImage('${group?.user?.profilePicture}')
                        ),

                        title:Row(children: [
                          Text(
                            '${group?.user?.firstName} ${group?.user?.lastName}',
                            style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.black ),),
                        ],),
                        subtitle:  Text('${group?.user?.email}',
                          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.greyColor500 ),
                        ),),



                    ],
                  ),
                );
              }),

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
    return Container(
      padding: EdgeInsets.all(30),
      child: EmptyState(
          hasButton: false,
          onTap: () {
            //WayaNav.toNamed(CreatePost.route);
          },
          buttontext: 'Create a Post',
          buttonTrailingIcon: SvgPicture.asset(
            WayaAssets.icons.addEventIcon.path,
            colorFilter:
            ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
          ),
          assetImage: Image.asset(
            WayaAssets.images.emptyEvent.path,
            scale: 1.5,
          ),
          message: "You haven't team members yet"),
    );
  }
}