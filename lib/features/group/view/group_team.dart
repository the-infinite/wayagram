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
import 'package:wayagram/features/group/data/model/all_group_member_model.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/group/widget/group_empty_state.dart';
import 'package:wayagram/features/group/widget/group_member_card.dart';
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
            GroupPageEmptyState(text: 'No members yet')
          else
            ListView.builder(
                padding: EdgeInsets.only(bottom: 50.h),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.allGroupMemberDocs?.length,
                itemBuilder: (_, index) {
                  return ValueListenableBuilder(
                      valueListenable: wayaGroupCache,
                      builder: (context, redraws, _) {
                        final groupMember =
                            viewModel.allGroupMemberDocs?[index];
                        final group =
                            wayaGroupCache.getCachedData(widget.groupId);
                        if (group == null) {
                          return SizedBox();
                        }
                        //? If this is in vertical orientation.
                        if (vertical) {
                          return GroupMemberCardWidget(
                              groupMember: groupMember,
                              widget: widget,
                              wayaTheme: wayaTheme,
                              ref: ref);
                        }
                        // Build and return our component.
                        return GroupMemberCardWidget(
                            groupMember: groupMember,
                            widget: widget,
                            wayaTheme: wayaTheme,
                            ref: ref);
                      });
                })
        ],
      ),
    );
  }
}
