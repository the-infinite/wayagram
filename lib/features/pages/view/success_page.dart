

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

class SuccessPage extends ConsumerStatefulWidget {
  static const route = '/successPage';
  const SuccessPage({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SuccessPageState();
}

class _SuccessPageState extends ConsumerState<SuccessPage> {

  bool sel =  false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPageProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      removeAppBar: true,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(50),
          Center(child: Image.asset('assets/images/pages/team.png', height: 160.h,)),
          const Gap(50),
          Text(
              'Page Created Successfully',
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: WayaColors.black,
                  fontFamily: WayaConstants.fontFamily
              )),
          const Gap(10),
          Text(
              'Great news! Your Page has been successfully\ncreated and you can manage it anytime in the\nPages section.',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: WayaColors.greyColor500,
                  fontFamily: WayaConstants.fontFamily
              ),textAlign: TextAlign.center,),
          const Gap(150),
          WayaButton(
            callback: !viewModel.isLoading
                ? () async {
              WayaNav.toNamed("/pages");
            } : null,
            centerWidget: LoadingState(
                loading: viewModel.isLoading, text: 'Manage Page'),
            height: 50.h,
          ),

        ],
      ),
    );
  }

}
