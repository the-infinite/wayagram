import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';

class VerifyEmail extends ConsumerWidget {
  static const route = "/verify-email";
  const VerifyEmail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelState = ref.watch(verifyAccountProvider);
    final viewModel = ref.watch(verifyAccountProvider.notifier);
    final wayaTheme = Theme.of(context);

    final arg = ModalRoute.of(context)!.settings.arguments as String?;

    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Verify your Account",
            style: WayaTextStyles.titleLarge,
          ),
          const Gap(5),
          Text(
            "Enter the 6-digits code sent to your email address and Phone number",
            maxLines: 3,
            style: WayaTextStyles.hintStyle,
          ),
          const Gap(20),
          Align(
            alignment: Alignment.center,
            child: VerificationCode(
              textStyle: TextStyle(fontSize: 20.0.sp),
              keyboardType: TextInputType.number,
              underlineColor: wayaTheme.colorScheme.customBlack,
              fullBorder: true,
              fillColor: Colors.transparent,
              itemSize: 42,
              length: 6,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              cursorColor: wayaTheme.colorScheme.customPrimary,
              onCompleted: (String value) {
                viewModel.onCodeChanged(value);
              },
              onEditing: (bool value) {
                viewModel.onEdited(value);
                if (!viewModelState.isEditing) {
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
          const Gap(20),
          Align(
            alignment: Alignment.center,
            child: viewModelState.isResend
                ? GestureDetector(
                    onTap: () {
                      if (!viewModelState.isLoading) {
                        if (arg != null) {
                          viewModel.resendOtpForRegisteredButNotVerifiedUser(
                              email: arg);
                        }
                      }
                    },
                    child: Container(
                      width: 110,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.primary75,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        "Resend OTP",
                        style: WayaTextStyles.smallActiveLinkStyle,
                      ),
                    ),
                  )
                : Container(
                    width: 200,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.primary75,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Didn't get any code? ",
                            style: WayaTextStyles.bodySmall,
                          ),
                          TextSpan(
                            text:
                                "Resend ${viewModelState.countdown ~/ 60}:${(viewModelState.countdown % 60).toString().padLeft(2, '0')}",
                            style: WayaTextStyles.smallActiveLinkStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          const Gap(50),
          WayaButton(
            callback: !viewModelState.isLoading
                ? () {
                    final code = ref.watch(verifyAccountProvider).inputCode;
                    viewModel.verifyAccountForRegisteredButNotVerifiedUser(
                        arg!, code);
                  }
                : null,
            centerWidget: LoadingState(
              loading: viewModelState.isLoading,
              text: 'Continue to Login',
            ),
          ),
        ],
      ),
    );
  }
}
