import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';

class MuteGroup extends ConsumerStatefulWidget {
  static const route = '/muteGroup';
  const MuteGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MuteGroupState();
}

class _MuteGroupState extends ConsumerState<MuteGroup>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Mute Group',
      body: Column(
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
              "Mute Group",
              "Manually disable members from commenting, liking,sharing and reposting on this group",
              viewModel.muteAndUnMute, (value) {
            ref.read(createGroupProvider.notifier).toggleMute(value);
            ref
                .read(createGroupProvider.notifier)
                .muteAndUnMuteGroup(context, value, args['groupId']);
          }),
        ],
      ),
    );
  }

  Widget accessType(
      String title, String? subTitle, bool chk, Function(bool)? onPressed) {
    final wayaTheme = Theme.of(context);
    return Container(
      height: 88.h,
      padding:
          EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: wayaTheme.textTheme.titleSmall),
        subtitle: Text(
          subTitle ?? '',
          style: TextStyle().wayaCopyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor500),
        ),
        trailing: Switch(value: chk, onChanged: onPressed),
      ),
    );
  }
}
