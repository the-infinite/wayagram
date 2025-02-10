
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


class ConfirmGroupDetails extends ConsumerStatefulWidget {
  static const route = '/confirmGroupDetails';
  const ConfirmGroupDetails({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfirmGroupDetailsState();
}

class _ConfirmGroupDetailsState extends ConsumerState<ConfirmGroupDetails> {

  Map<String, dynamic> formData = {};


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createGroupProvider);
    final viewModel2 = ref.watch(createGroupProvider.notifier);
    final dynamic args  = ModalRoute.of(context)?.settings.arguments ;
    return WayaScaffold(
      title: "Confirm Details",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing:   Padding(
        padding: const EdgeInsets.only(right: 20),
        child: WayaButton(
          callback: !viewModel.isLoading
              ? () async {
            // viewModel2.createGroup(context, viewModel.groupName.text,
            //     viewModel.groupDescription.text,  true, );
            viewModel2.reset();
           // WayaNav.toNamed("/successGroup", arguments: type);
          } : null,
          //centerWidget: LoadingState(loading: viewModel.isLoading, text: 'Create'),
          height: 30,
          text: 'Create',
          horizontalPadding: 12,
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

                  Image.file(File('${args['image'].absolute.path}'),
                      height:Get.height * 0.2, width: double.infinity,
                  alignment: Alignment.centerRight, fit: BoxFit.fitWidth,),
                  //WayaImage3(height: Get.height * 0.2,),
                  Gap(15),

                ],
              ),
              Positioned(
                  left: 16.w,
                  bottom: -20.h,
                  child: WayaDp(
                    radius: 28.r,
                  )),
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
  details(title, subTitle){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
              title,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: WayaColors.greyColor700,
                  fontFamily: WayaConstants.fontFamily
              )),
        ),
        const Spacer(),
        Expanded(
          child: Text(
              '$subTitle',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff6B7280),
              )),
        ),
      ],
    );
  }
}
