import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';

class ConfirmGroupDetails extends ConsumerStatefulWidget {
  static const route = '/confirmGroupDetails';
  const ConfirmGroupDetails({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfirmGroupDetailsState();
}

class _ConfirmGroupDetailsState extends ConsumerState<ConfirmGroupDetails> {
  final createController = ValueNotifier(false);

  @override
  void dispose() {
    createController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final notifier = ref.read(createGroupProvider.notifier);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    return WayaScaffold(
      title: "Confirm Details",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IntrinsicHeight(
          child: WayaProgressiveButton(
            notifier: createController,
            callback: () async {
              final createdGroup = await myGroupNotifier.createGroup(
                viewModel.groupName.text,
                viewModel.groupDescription.text,
                args['type'] == 'Public Group' ? false : true,
                (args['coverImage'] as File).path,
                (args['image'] as File).path,
              );
              notifier.reset();
              WayaNav.goBack();
              await Future.delayed(const Duration(milliseconds: 350));
              WayaNav.goBack();
              await Future.delayed(const Duration(milliseconds: 350));
              WayaNav.replaceNamed("/successGroup", arguments: {'type': args['type'], 'id': createdGroup?.id});
            },
            height: null,
            verticalPadding: 6.h,
            horizontalPadding: 12.w,
            text: 'Create',
            textStyle: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.white,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  args['coverImage'] == null
                      ? Image.asset(
                          'assets/images/pages/image_placeholder.png',
                          height: Get.height * 0.2,
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          fit: BoxFit.fitWidth,
                        )
                      : Image.file(
                          File('${args['image'].absolute.path}'),
                          height: Get.height * 0.2,
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          fit: BoxFit.fitWidth,
                        ),
                  Gap(15),
                ],
              ),
              Positioned(
                left: 16.w,
                bottom: -20.h,
                child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        //args['coverImage'].absolute.path != null?
                        FileImage(File('${args['coverImage']?.absolute.path}'))
                    // AssetImage('assets/images/pages/image_placeholder.png')
                    ),
              ),
            ],
          ),
          const Gap(50),
          details('Group Name', viewModel.groupName.text.capitalizeFirst),
          Gap(20),
          details('Group Description', viewModel.groupDescription.text.capitalizeFirst),
          Gap(20),
          //details('Group Type', '$type')
          details('Group Type', args['type'])
        ],
      ),
    );
  }

  details(title, subTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: WayaColors.greyColor700,
            fontFamily: WayaConstants.fontFamily,
          ),
        ),

        //? This is fine.
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 15.h),
            child: Text(
              subTitle,
              maxLines: 2,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff6B7280),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
