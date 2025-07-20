import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';

class TwoFactorAuth extends ConsumerStatefulWidget {
  static const route = "/two-factor-authentication";
  final String email;
  const TwoFactorAuth({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TwoFactorAuthState();
}

class _TwoFactorAuthState extends ConsumerState<TwoFactorAuth> {
  late final notifier = ref.read(verifyAccountProvider.notifier);
  int countDown = 60;
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = ModalRoute.of(context)!.settings.arguments;

      if (arg != null) {
        if (arg == "resend") {
          notifier.updateResend(true);
        } else {
          notifier.updateFromLoginState(true);
        }
      }
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
    final state = ref.watch(verifyAccountProvider);
    final wayaTheme = Theme.of(context);
    return PopScope(
        onPopInvokedWithResult: (popping, _) {
          if (!popping) return;
          notifier.reset();
        },
        child: WayaScaffold(
            isScrollable: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //? First, for the page title.
                Text(
                  "2FA Verification",
                  style: WayaTextStyles.titleLarge,
                ),

                // Some space.
                const Gap(5),

                //? Give it a little bit more space.
                Text(
                  "We sent a 6-digits code sent to ${widget.email}",
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
                      notifier.onCodeChanged(value);
                    },
                    onEditing: (bool value) {
                      notifier.onEdited(value);
                      if (!state.isEditing) {
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
                            if (!state.isLoading) {
                              setState(() {
                                countDown = 60;
                              });
                              startCountdown();
                              final email = Uri.decodeComponent(widget.email);
                              notifier.resend2faOtp(email: email);
                            }
                          },
                          child: Container(
                            width: 110,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: wayaTheme.colorScheme.primary75,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
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
                  callback: !state.isLoading
                      ? () async {
                          final code = state.inputCode;
                          notifier.twoFaVerification(
                              code: code, email: widget.email);
                        }
                      : null,
                  centerWidget: LoadingState(
                    loading: state.isLoading,
                    text: 'Verify',
                  ),
                ),
              ],
            )));
  }
}
