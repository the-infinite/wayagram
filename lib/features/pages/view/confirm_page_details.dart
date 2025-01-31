
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
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
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> formData = {};


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPageProvider);
    final viewModel2 = ref.watch(createPageProvider.notifier);
    final wayaTheme = Theme.of(context);
    final type  = ModalRoute.of(context)?.settings.arguments as String?;
    return WayaScaffold(
      title: "Confirm Details",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing:   Padding(
        padding: const EdgeInsets.only(right: 20),
        child: WayaButton(
          callback: !viewModel.isLoading
              ? () async {
            //if (_formKey.currentState!.validate()) {
             viewModel2.reset();
              WayaNav.toNamed("/successPage");
           // }
          } : null,
          centerWidget: LoadingState(
              loading: viewModel.isLoading, text: 'Create'),
          height: 30,
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
                  child: WayaDp(
                    radius: 28.r,
                  )),
            ],
          ),
          const Gap(50),
          details('Page Name', viewModel.pageName.text.capitalizeFirst),
          Gap(20),
          details('Page Description', viewModel.pageDescription.text.capitalizeFirst),
          Gap(20),
          details('Page Type', '$type')
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
