import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/set_notification.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';

class VerifyAccount extends ConsumerWidget {
  final Function goToNextTab;
  final type;
  const VerifyAccount(
      {super.key, required this.goToNextTab, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelState = ref.watch(verifyAccountProvider);
    final viewModel = ref.watch(verifyAccountProvider.notifier);

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
          underlineColor: WayaColors.customPrimary,
          fullBorder: true,
          fillColor: Colors.transparent,
          itemSize: 50,
          length: 6,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          cursorColor: WayaColors.customPrimary,
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
          child: Container(
              width: 200,
              alignment: Alignment.center,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: WayaColors.primary75,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text: "Don't get any code ",
                    style: WayaTextStyles.bodySmall),
                TextSpan(
                    text: "Resend 4s",
                    style: WayaTextStyles.smallactiveLinkStyle),
              ]))),
        ),
        const Gap(50),
        ElevatedButton(
            onPressed: viewModelState.inputCode.isEmpty ||
                    viewModelState.inputCode.length < 6
                ? null
                : () {
                    if (type == 'account-creation') {
                      WayaNav.to(const SetNotification());
                    } else {
                      goToNextTab();
                    }
                  },
            child: Text("Continue"))
      ],
    );
  }
}
