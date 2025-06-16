import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/transaction_pin/vm/transaction_pin_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/widget/pin_input_field.dart';
import 'package:wayagram/features/auth/transaction_pin/widget/pin_keyboard.dart';

class TransactionPinView extends ConsumerStatefulWidget {
  static const route = '/setup-pin';
  const TransactionPinView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionPinViewState();
}

class _TransactionPinViewState extends ConsumerState<TransactionPinView> {
  @override
  Widget build(BuildContext context) {
    final pin = ref.watch(pinProvider);
    final confirmPin = ref.watch(confirmPinProvider);
    final isInValid = ref.watch(isPinValidProvider);
    final loading = ref.watch(loadingProvider);
    final viewModel = ref.read(transactionPinProvider.notifier);
    final wayaTheme = Theme.of(context);

    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    return PopScope(
        onPopInvokedWithResult: (popping, _) {
          if (!popping) return;
          viewModel.handleClearField();
        },
        child: WayaScaffold(
            isLoading: loading,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    //height: context.height * 0.35,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Set Up Your Transaction Pin",
                        style: WayaTextStyles.titleLarge),
                    const Gap(5),
                    Text(
                        "For added security, please create a 4-digit PIN \n to confirm your transactions",
                        style: WayaTextStyles.hintStyle),
                    const Gap(30),
                    PinInputField(
                      pin: pin,
                      label: "Enter a 4-digit PIN",
                      digits: 4,
                      ratio: 0.17,
                      margin: 8,
                      height: 55,
                    ),
                    const Gap(10),
                    PinInputField(
                      pin: confirmPin,
                      label: "Re-enter your PIN",
                      digits: 4,
                      ratio: 0.17,
                      height: 55,
                      margin: 8,
                    ),
                    const Gap(10),
                    Visibility(
                        visible: pin.isNotEmpty &&
                            confirmPin.isNotEmpty &&
                            !isInValid,
                        child: Text("The PINs don't match. Pls try again",
                            style: TextStyle().wayaCopyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: wayaTheme.colorScheme.error500,
                            )))
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        // height: context.height * 0.40,
                        child: PinKeyboard(
                            onKeyTap: viewModel.handleKeyPress,
                            onSubmit: () => viewModel.submitPins(type: args),
                            onBackspace: viewModel.handleBackspace)),
                    const Gap(20),
                    if (args != "account-setting")
                      Align(
                          child: GestureDetector(
                        onTap: () {
                          WayaNav.toNamed('/set-notification');
                        },
                        child: Text(
                          "Skip for now",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                    const Gap(20),
                  ],
                )
              ],
            )));
  }
}
