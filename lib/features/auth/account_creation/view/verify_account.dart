import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';

class VerifyAccount extends ConsumerStatefulWidget {
  final Function({String? emailAddress}) goToNextTab;
  final String type;
  final String email;
  const VerifyAccount(
      {super.key,
      required this.goToNextTab,
      required this.type,
      this.email = ''});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends ConsumerState<VerifyAccount> {
  int countDown = 60;
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startCountdown();
    });
    super.initState();
  }

  void startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (countDown > 0) {
          setState(() {
            countDown = countDown - 1;
          });
        } else {
          _timer?.cancel();
        }
      },
    );
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModelState = ref.watch(verifyAccountProvider);
    final viewModel = ref.watch(verifyAccountProvider.notifier);
    final wayaTheme = Theme.of(context);
    String personalEmail = ref.watch(personalFirstStepProvider).email.text;

    return PopScope(
        onPopInvokedWithResult: (popping, _) {
          if (!popping) return;
          ref.watch(verifyAccountProvider.notifier).reset();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //? First, for the page title.
            Text(
              "Verify your email address",
              style: WayaTextStyles.titleLarge,
            ),

            // Some space.
            const Gap(5),

            //? Give it a little bit more space.
            Text(
              "We sent a 6-digits code sent to ${widget.email.isNotEmpty ? widget.email : personalEmail} to verify your email",
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
              child: countDown == 0

                  //? What to show when the user can resend this.
                  ? GestureDetector(
                      onTap: () {
                        if (!viewModelState.isLoading) {
                          setState(() {
                            countDown = 60;
                          });
                          startCountdown();
                          viewModel.resend2faOtp(email: widget.email);
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
                                  "Resend ${countDown ~/ 60}:${(countDown % 60).toString().padLeft(2, '0')}",
                              style: WayaTextStyles.smallActiveLinkStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            // Some space.
            const Gap(50),

            // The final button.
            WayaButton(
              callback: !viewModelState.isLoading
                  ? () {
                      if (widget.type == 'account-creation') {
                        final code = ref.watch(verifyAccountProvider).inputCode;
                        viewModel.verifyAccount(
                            onSuccess: () => widget.goToNextTab(),
                            code: code,
                            type: widget.type);
                      } else if (widget.type == "forgot-password") {
                        widget.goToNextTab(emailAddress: widget.email);
                      }
                    }
                  : null,
              centerWidget: LoadingState(
                loading: viewModelState.isLoading,
                text: 'Continue',
              ),
            ),
          ],
        ));
  }
}
