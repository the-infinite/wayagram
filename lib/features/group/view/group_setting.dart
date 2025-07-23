
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';

class GroupSetting extends ConsumerStatefulWidget {
  static const route = '/groupSetting';
  const GroupSetting ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupSettingState();
}

class _GroupSettingState extends ConsumerState<GroupSetting>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final dynamic args  = ModalRoute.of(context)?.settings.arguments ;

    /// if approveJoinRequest is false they can join the group and vice versa

    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Group Access Settings',
      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20),
          Text(
            "Group Membership",
            style: wayaTheme.textTheme.hintStyle,
          ),
          Gap(20),

          accessType(
              "Open to Everyone",
              "Allow anyone to join without restrictions for a more inclusive community", viewModel.openToEveryone,
                  (value) {
                    ref.read(createGroupProvider.notifier).updateOpenToEveryone(value);
                    ref.read(createGroupProvider.notifier).updateGroupSetting(context, value, viewModel.approveJoinRequest, args['groupId']);
                  }
          ),

          accessType(
              "Approve join request",
              "Allow join request approval", viewModel.approveJoinRequest,
                  (value) {
                ref.read(createGroupProvider.notifier).updateApproveJoinRequest(value);
                ref.read(createGroupProvider.notifier).updateGroupSetting(context,viewModel.openToEveryone,
                    value, args['groupId']);
              }
          ),

          Gap(20),
          accessType(
              "Mute Group",
              "Manually disable members from commenting, liking,sharing and reposting on this group", viewModel.muteAndUnMute,
                  (value) {
                    ref.read(createGroupProvider.notifier).toggleMute(value);
                    ref.read(createGroupProvider.notifier).muteAndUnMuteGroup(context, value, args['groupId']);
                  })
            ,
        ],
      ),
    );
  }
 Widget accessType(title, subTitle,chk, onPressed){
   final wayaTheme = Theme.of(context);
    return Container(
      height: 88.h,
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title,
            style: wayaTheme.textTheme.titleSmall
        ),
        subtitle: Text(subTitle,
          style: TextStyle().wayaCopyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor500 ),
        ),
        trailing: Switch(
            value: chk,
            onChanged: onPressed
        ),
      ),
    );
 }
}