
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';

class PageSetting extends ConsumerStatefulWidget {
  static const route = '/pageSetting';
  const PageSetting ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageSettingState();
}

class _PageSettingState extends ConsumerState<PageSetting>
    with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);

    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Page Settings',
      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20),
          Text(
            "Page Permission Settings",
            style: wayaTheme.textTheme.hintStyle,
          ),
          Gap(20),

          accessType(
              "Follow Permissions",
              "Allow anyone to follow without restrictions for a more inclusive community", viewModel.openToEveryone,
                  (value) => ref.read(createGroupProvider.notifier).updateOpenToEveryone(value)),

          Gap(20),
          accessType(
              "Comment Permissions",
              "Choose who you want to comment on page posts to have more control over your page ", viewModel.requireApproval,
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