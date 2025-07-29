import 'dart:async';

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
import 'package:wayagram/features/general_settings/profile/data/model/profile_edit_type_model.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_name.dart';

class VerifyYourIdentityPage extends ConsumerStatefulWidget {
  static const route = '/verify-your-identity';

  const VerifyYourIdentityPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyIdentityPageState();
}

class _VerifyIdentityPageState extends ConsumerState<VerifyYourIdentityPage> {
  int countDown = 60;
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic args = ModalRoute.of(context)!.settings.arguments;

      if (args != null) {
        ProfileEditType type = args['type'] as ProfileEditType;
        if (type == ProfileEditType.email) {
          ref
              .read(verifyAccountProvider.notifier)
              .requestOtp(purpose: "CHANGE_OF_EMAIL", email: args['initial']);
        } else {
          ref.read(verifyAccountProvider.notifier).requestOtp(
              purpose: "CHANGE_OF_PHONE", phone: "234${args['initial']}");
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
    final viewModelState = ref.watch(verifyAccountProvider);
    final viewModel = ref.watch(verifyAccountProvider.notifier);
    final wayaTheme = Theme.of(context);

    // for editing email or phone
    final dynamic args = ModalRoute.of(context)!.settings.arguments;

    return WayaScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //? First, for the page title.
          Text(
            "Verify your Identity",
            style: WayaTextStyles.titleLarge,
          ),

          // Some space.
          const Gap(5),

          //? Give it a little bit more space.
          Text(
            "Enter the 6-digits code sent to your email address and Phone number",
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
                        setState(() {
                          countDown = 60;
                        });
                        startCountdown();
                        if (args != null) {
                          ProfileEditType type =
                              args['type'] as ProfileEditType;
                          if (type == ProfileEditType.email) {
                            ref.read(verifyAccountProvider.notifier).requestOtp(
                                purpose: "CHANGE_OF_EMAIL",
                                email: args['initial']);
                          } else {
                            ref.read(verifyAccountProvider.notifier).requestOtp(
                                purpose: "CHANGE_OF_PHONE",
                                phone: "234${args['initial']}");
                          }
                        } else {
                          ref
                              .read(verifyAccountProvider.notifier)
                              .requestEmailOtp();
                        }
                        // viewModel.resendOtp();
                      }
                    },
                    child: Container(
                      width: 110,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
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
                    padding: const EdgeInsets.all(12),
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
                    final code = ref.watch(verifyAccountProvider).inputCode;

                    //viewModel.verifyYourIdentity(() => WayaNav.to(const ResetPinPage()), code);
                    // viewModel.verifyYourIdentity((){
                    //
                    // }, code);
                    if (args != null) {
                      ProfileEditType type = args['type'] as ProfileEditType;
                      if (type == ProfileEditType.email) {
                        WayaNav.replaceNamed(
                          EditNamePage.route,
                          arguments: ProfileEditArguments(
                              editType: ProfileEditType.email,
                              initialValue: args['initial'],
                              code: code),
                        );
                      } else {
                        WayaNav.replaceNamed(EditNamePage.route,
                            arguments: ProfileEditArguments(
                                editType: ProfileEditType.phone,
                                initialValue: args['initial'],
                                code: code));
                      }

                      return;
                    }

                    WayaNav.replaceNamed('/reset-pin-page',
                        arguments: {'code': code});
                  }
                : null,
            centerWidget: LoadingState(
              loading: viewModelState.isLoading,
              text: 'Continue',
            ),
          ),
        ],
      ),
    );
  }
}
