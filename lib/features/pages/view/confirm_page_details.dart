
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class ConfirmPageDetails extends ConsumerStatefulWidget {
  static const route = '/confirmDetails';
  const ConfirmPageDetails({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfirmPageDetailsState();
}

class _ConfirmPageDetailsState extends ConsumerState<ConfirmPageDetails> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPageProvider);
    final viewModel2 = ref.watch(createPageProvider.notifier);
    final dynamic args  = ModalRoute.of(context)?.settings.arguments ;
    //final type  = ModalRoute.of(context)?.settings.arguments as String?;
    return WayaScaffold(
      title: "Confirm Details",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing:   Padding(
        padding: const EdgeInsets.only(right: 20),
        child: WayaButton(
          callback: !viewModel.isLoading
              ? () async {
            await viewModel2.createPage(context, viewModel.pageName.text,
                viewModel.pageDescription.text,   args['type'] == 'Public Page' ? false : true,
                (args['coverImage'] as File).path, ( args['image'] as File).path );
            viewModel2.reset();
            WayaNav.toNamed("/successGroup",
                arguments: args['type']
            );
          } : null,
          height: 30,
          text: 'Create',
          horizontalPadding: 12,
          isLoading: viewModel.isLoading,
          textStyle: WayaTextStyles.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.white ),
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
                  WayaImage3(
                    height: Get.height * 0.2,
                  ),
                  Gap(15),

                ],
              ),

              Positioned(
                  left: 16.w,
                  bottom: -20.h,
                  child:  CircleAvatar(
                      radius: 20,
                      backgroundImage:
                      FileImage(File('${args['coverImage'].absolute.path}'))
                  )
              ),
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
 details(title, subTitle){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: WayaColors.greyColor700,
              fontFamily: WayaConstants.fontFamily
            )),
        const Spacer(),
        Text(
            subTitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff6B7280),
            )),
      ],
    );
 }
}
