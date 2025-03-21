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
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';

class ConfirmPageDetails extends ConsumerStatefulWidget {
  static const route = '/confirmDetails';
  const ConfirmPageDetails({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfirmPageDetailsState();
}

class _ConfirmPageDetailsState extends ConsumerState<ConfirmPageDetails> {
  final createController = ValueNotifier(false);

  @override
  void dispose() {
    createController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final viewModel2 = ref.watch(createPageProvider.notifier);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    //final type  = ModalRoute.of(context)?.settings.arguments as String?;
    return WayaScaffold(
      title: "Confirm Details",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: WayaProgressiveButton(
          notifier: createController,
          callback: () async {
            await myPageNotifier.createPage(
              viewModel.pageName.text,
              viewModel.pageDescription.text,
              args['type'] == 'Public Page' ? true : false,
              (args['coverImage'] as File).path,
              (args['image'] as File).path,
            );
            viewModel2.reset();
            WayaNav.toNamed("/successPage");
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
                      radius: 20, backgroundImage: FileImage(File('${args['coverImage'].absolute.path}')))),
            ],
          ),
          const Gap(50),
          details('Page Name', viewModel.pageName.text.capitalizeFirst),
          Gap(20),
          details('Page Description', viewModel.pageDescription.text.capitalizeFirst),
          Gap(20),
          details('Page Type', args['type'])
        ],
      ),
    );
  }

  details(title, subTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: WayaColors.greyColor700,
                fontFamily: WayaConstants.fontFamily)),
        const Spacer(),
        Text(subTitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff6B7280),
            )),
      ],
    );
  }
}
