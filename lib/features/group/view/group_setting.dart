
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/group/view/events.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/view/pages_for_you.dart';
import 'package:wayagram/features/pages/view/team_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

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
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);

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
                  (value) => ref.read(createGroupProvider.notifier).updateOpenToEveryone(value)),

          Gap(20),
          accessType(
              "Require Join Approval",
              "Manually approve requests to join and maintain control over access", viewModel.requireApproval,
                  (value) => ref.read(createGroupProvider.notifier).updateRequireApproval(value)),


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
              fontSize: 14,
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