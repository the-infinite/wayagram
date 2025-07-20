import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/group/widget/group_empty_state.dart';
import 'package:wayagram/features/group/widget/join_request_widget.dart';

import '../../../core/theme/waya_colors.dart';

class ApprovalScreen extends ConsumerStatefulWidget {
  final String groupId;
  final GroupProviderFamily provider;
  const ApprovalScreen({
    super.key,
    required this.groupId,
    required this.provider,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends ConsumerState<ApprovalScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(widget.provider.notifier).getJoinRequest(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(widget.provider);
    final request = ref.watch(widget.provider.notifier);
    debugPrint('APPROVAL GROYUPID ${widget.groupId}');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      color: wayaTheme.colorScheme.greyColor50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20.h),

          Text(
            'Pending Approvals',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: WayaColors.greyColor600,
              fontFamily: WayaConstants.fontFamily,
            ),
          ),

          Gap(10.h),

          //? If there are group members to invite.
          if (viewModel.joinRequestDocs!.isEmpty)
            GroupPageEmptyState(text: "You don't have approvals yet")
          else
            ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.joinRequestDocs?.length,
                itemBuilder: (_, index) {
                  final joinRequest = viewModel.joinRequestDocs![index];
                  return JoinRequestWidget(
                      reject: () => request.rejectRequest(
                          context, '${joinRequest.id}', widget.groupId),
                      accept: () => request.approveRequest(
                          context, '${joinRequest.id}', widget.groupId),
                      joinRequest: joinRequest);
                }),
        ],
      ),
    );
  }
}
