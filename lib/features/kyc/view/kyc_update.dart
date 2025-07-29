import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/kyc/vm/kyc_vm.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class KycUpdate extends ConsumerStatefulWidget {
  static const route = '/kycUpdate';
  const KycUpdate({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KycUpdateState();
}

class _KycUpdateState extends ConsumerState<KycUpdate> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(kycVmProvider.notifier).getMyKYC();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(kycVmProvider);
    final wayaTheme = Theme.of(context);

    // final dynamic args  = ModalRoute.of(context)?.settings.arguments;
    return WayaScaffold(
      title: "KYC Update",
      isLoading: viewModel.isLoading,
      isScrollable: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(150),
          Image.asset(
            'assets/images/kyc_empty.png',
            height: 106.h,
            width: 126.w,
          ),
          const Gap(20),
          Text(
            'KYC Verification Status',
            textAlign: TextAlign.center,
            style: WayaTextStyles.bodySmall.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.black),
          ),
          const Gap(10),
          Text(
            'Track the progress of your KYC submission and take necessary actions.',
            textAlign: TextAlign.center,
            style: WayaTextStyles.bodySmall.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500),
          ),
          const Gap(15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.kycStatus == 'APPROVED'
                    ? 'Approved'
                    : viewModel.kycStatus == 'PENDING'
                        ? 'Pending Review'
                        : 'Rejected',
                textAlign: TextAlign.center,
                style: WayaTextStyles.bodySmall.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.greyColor700),
              ),
              const Gap(10),
              Image.asset(
                viewModel.kycStatus == 'APPROVED'
                    ? 'assets/images/approved.png'
                    : viewModel.kycStatus == 'PENDING'
                        ? 'assets/images/review.png'
                        : 'assets/images/rejected.png',
                height: 16.h,
              ),
              const Gap(10),
              viewModel.kycStatus == 'APPROVED' ||
                      viewModel.kycStatus == 'PENDING'
                  ? Text(
                      'Date Submitted: ${ref.read(createPollVotingProvider.notifier).formatDt2(viewModel.date)} ',
                      textAlign: TextAlign.center,
                      style: WayaTextStyles.bodySmall.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: WayaColors.greyColor800),
                    )
                  : Container(),
            ],
          ),
          Gap(100.h),
          viewModel.kycStatus == 'APPROVED'
              ? WayaButton(
                  text: 'Start Using Your Account',
                  color: wayaTheme.colorScheme.primary500,
                  textColor: wayaTheme.colorScheme.white,
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor300),
                  callback: () {
                    WayaNav.goBack();
                  },
                  textStyle: WayaTextStyles.bodySmall.copyWith(
                      fontSize: 16.sp,
                      fontFamily: WayaConstants.fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.white),
                )
              : viewModel.kycStatus == 'PENDING'
                  ? WayaButton(
                      text: "We’ll notify you once reviewed",
                      color: wayaTheme.colorScheme.greyColor300,
                      textColor: wayaTheme.colorScheme.white,
                      border: Border.all(
                          width: 1, color: wayaTheme.colorScheme.greyColor300),
                      callback: () {},
                      textStyle: WayaTextStyles.bodySmall.copyWith(
                          fontSize: 16.sp,
                          fontFamily: WayaConstants.fontFamily,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.white),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          viewModel.reason ?? '',
                          style: wayaTheme.textTheme.descriptionStyle,
                        ),
                        Gap(10.h),
                        WayaButton(
                          text: 'Update Documents',
                          color: wayaTheme.colorScheme.primary500,
                          textColor: wayaTheme.colorScheme.white,
                          border: Border.all(
                              width: 1,
                              color: wayaTheme.colorScheme.greyColor300),
                          callback: () {
                            //WayaNav.goBack();
                            WayaNav.toNamed(AddBusinessAccountView.route);
                          },
                          textStyle: WayaTextStyles.bodySmall.copyWith(
                              fontSize: 16.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.white),
                        )
                      ],
                    )
        ],
      ),
    );
  }
}
