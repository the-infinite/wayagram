

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
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class SuccessGroup extends ConsumerStatefulWidget {
  static const route = '/successGroup';
  const SuccessGroup({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SuccessGroupState();
}

class _SuccessGroupState extends ConsumerState<SuccessGroup> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> formData = {};

  bool sel =  false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createGroupProvider);
    final wayaTheme = Theme.of(context);
    final type  = ModalRoute.of(context)?.settings.arguments as String?;
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
              'Group Created Successfully',
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: WayaColors.black,
                  fontFamily: WayaConstants.fontFamily
              )),
          const Gap(10),
          Text(
            'Great news! Your Group has been successfully created and you can manage it anytime in the\nGroups section.',
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
              WayaNav.toNamed("/groupPublic");
            } : null,
            centerWidget: LoadingState(
                loading: viewModel.isLoading, text: 'Manage Group'),
            height: 50.h,
          ),

        ],
      ),
    );
  }

}
