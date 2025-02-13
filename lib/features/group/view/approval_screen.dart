import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

import '../../../core/theme/waya_colors.dart';
import '../../pages/empty_state.dart';

class ApprovalScreen extends ConsumerStatefulWidget {
  final String groupId;
  const ApprovalScreen({super.key, required this.groupId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends ConsumerState<ApprovalScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('TESTING DARLINGTON ${widget.groupId}');
      ref.read(createGroupProvider.notifier).getJoinRequest(widget.groupId);
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final request = ref.watch(createGroupProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, right: 15,),
      color: wayaTheme.colorScheme.greyColor50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text('Pending Approvals',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: WayaColors.greyColor600,
                    fontFamily: WayaConstants.fontFamily)),
          ),
          viewModel.allGroupMemberDocs!.isEmpty ? PostEmptyState():
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.docs?.length,
              itemBuilder: (_, index) {
                final group = viewModel.docs?[index];
                return Container(
                  height: 60.h,
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.only(left: 10,),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10),
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 20,
                              backgroundColor: WayaColors.greyColor100,
                              backgroundImage:group?.user?.profilePicture == null?
                                  AssetImage('',) :
                              NetworkImage('${group?.user?.profilePicture}')
                          ),
                          Gap(10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                 '${group?.user?.firstName} ${group?.user?.lastName}',
                                  style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.black ),),
                              Gap(5),
                              Text(
                                '${group?.user?.email}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .wayaCopyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .greyColor500),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 68.w,
                                  child:WayaButton(
                                    callback: ()async{
                                      await request.approveRequest(context, '${group?.id}');
                                    },
                                    text: 'Approve',
                                    textStyle: TextStyle().wayaCopyWith(
                                      color: wayaTheme.colorScheme.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    isLoading: viewModel.isLoading,
                                    height: 32.h,
                                    color: wayaTheme.colorScheme.success50,
                                    textColor: wayaTheme.colorScheme.success,
                                  ),
                                ),

                                Gap(10),
                                SizedBox(
                                  width: 68.w,
                                  child:WayaButton(
                                    callback: ()async{
                                      await request.rejectRequest(context, '${group?.id}');
                                    },
                                    text: 'Decline',
                                    textStyle: TextStyle().wayaCopyWith(
                                      color: wayaTheme.colorScheme.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    isLoading: viewModel.isLoading,
                                    height: 32.h,
                                    color:WayaColors.error50,
                                    textColor: wayaTheme.colorScheme.error,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                     // Gap(6),
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
          message: "You don't have approvals yet"),
    );
  }
}
