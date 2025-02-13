import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import '../../../core/theme/waya_colors.dart';

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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, right: 15,),
      color: wayaTheme.colorScheme.greyColor50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                              radius: 40,
                              backgroundColor: WayaColors.greyColor100,
                              backgroundImage:group?.user?.profilePicture == null?
                                  AssetImage('assets/images/pages/cam.png',) :
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
                                Container(
                                  padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                  width: 68.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: wayaTheme.colorScheme.success50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Approve",
                                      style: TextStyle().wayaCopyWith(
                                        color: wayaTheme.colorScheme.success,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Gap(10),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                  width: 68.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: WayaColors.error50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Decline",
                                      style: TextStyle().wayaCopyWith(
                                        color: WayaColors.error,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
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
