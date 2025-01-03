import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';
import 'package:wayagram/features/auth/forgot_password/vm/credential_input_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/views/transaction_pin_view.dart';

class VerifyAccount extends ConsumerWidget {
  final Function goToNextTab;
  final String type;
  const VerifyAccount(
      {super.key, required this.goToNextTab, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelState = ref.watch(verifyAccountProvider);
    final viewModel = ref.watch(verifyAccountProvider.notifier);
    final wayaTheme = Theme.of(context);
    final credentialProvider = ref.watch(credentialInputProvider);
   
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Verify your Account", style: WayaTextStyles.titleLarge),
        const Gap(5),
        Text(
            "Enter the 6-digits code sent to your email address \n and Phone number",
            style: WayaTextStyles.hintStyle),
        const Gap(20),
        VerificationCode(
          textStyle: const TextStyle(fontSize: 20.0),
          keyboardType: TextInputType.number,
          underlineColor: wayaTheme.colorScheme.customBlack,
          fullBorder: true,
          fillColor: Colors.transparent,
          itemSize: 50,
          length: 6,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          cursorColor: wayaTheme.colorScheme.customPrimary,
          onCompleted: (String value) {
            viewModel.onCodeChanged(value);
          },
          onEditing: (bool value) {
            viewModel.onEditited(value);
            if (!viewModelState.isEditing) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
        const Gap(20),
        Align(
          alignment: Alignment.center,
          child: viewModelState.isResend
              ? GestureDetector(
                  onTap: () {
                    if (!viewModelState.isLoading) {
                      viewModel.resendOtp();
                    }
                  },
                  child: Container(
                      width: 95,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.primary75,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        "Resend Otp",
                        style: WayaTextStyles.smallactiveLinkStyle,
                      )))
              : Container(
                  width: 200,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.primary75,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Don't get any code ",
                        style: WayaTextStyles.bodySmall),
                    TextSpan(
                        text:
                            "Resend ${viewModelState.countdown ~/ 60}:${(viewModelState.countdown % 60).toString().padLeft(2, '0')}",
                        style: WayaTextStyles.smallactiveLinkStyle),
                  ]))),
        ),
        const Gap(50),
        /**
        
         */
        WayaButton(
            callback:() {
                    if (type == 'account-creation') {
                       final code = ref.watch(verifyAccountProvider).inputCode;
                      viewModel.verifyAccount(
                          () => WayaNav.to(const TransactionPinView()), code);
                    } else {
                      goToNextTab();
                    }
                  },
            centerWidget: LoadingState(
                loading: viewModelState.isLoading, text: 'Continue')),
      ],
    );
  }
}
