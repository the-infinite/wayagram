import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';
import 'package:wayagram/features/general_settings/reset_pin_page/verify_transaction_identity.dart';

class VerifyPhoneNumber extends ConsumerWidget {
  final Function goToNextTab;

  const VerifyPhoneNumber({
    super.key,
    required this.goToNextTab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelState = ref.watch(verifyAccountProvider);
    final viewModel = ref.watch(verifyAccountProvider.notifier);
    final wayaTheme = Theme.of(context);
    //final credentialProvider = ref.watch(credentialInputProvider);
    String personalPhone =
        ref.watch(personalFirstStepProvider).phoneNumber.text;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //? First, for the page title.
        Text(
          "Verify your phone number",
          style: WayaTextStyles.titleLarge,
        ),

        // Some space.
        const Gap(5),

        //? Give it a little bit more space.
        Text(
          "Enter the 6-digits code sent to +234$personalPhone to verify your Phone number",
          maxLines: 3,
          style: WayaTextStyles.hintStyle,
        ),

        // Some space.
        const Gap(20),

        //? Next, the OTP code text field.
        Align(
          alignment: Alignment.center,
          child: VerificationCode(
            textStyle: const TextStyle(fontSize: 20.0),
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

        // Some space.
        const Gap(20),

        //? Our button.
        Align(
          alignment: Alignment.center,
          child: viewModelState.isResend

              //? What to show when the user can resend this.
              ? GestureDetector(
                  onTap: () {
                    if (!viewModelState.isLoading) {
                      viewModel.resendPhoneOtp();
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
                  width: 220.sp,
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

        // Some space.
        Gap(50.h),

        // The final button.
        WayaButton(
          callback: !viewModelState.isLoading
              ? () {
                  final code = ref.watch(verifyAccountProvider).inputCode;
                  viewModel.verifyPhone(
                      onSuccess: () =>
                          WayaNav.toNamed(VerifyTransactionIdentity.route),
                      code: code);
                }
              : null,
          centerWidget: LoadingState(
            loading: viewModelState.isLoading,
            text: 'Continue',
          ),
        ),

        // Some space.
        Gap(80.h),

        Align(
          alignment: Alignment.center,
          child: TextButton(
              onPressed: () => WayaNav.toNamed(VerifyTransactionIdentity.route),
              child: Text(
                "Skip for now",
                style: wayaTheme.textTheme.descriptionStyle.copyWith(
                    color: wayaTheme.colorScheme.customPrimary,
                    fontWeight: FontWeight.w600),
              )),
        )
      ],
    );
  }
}
