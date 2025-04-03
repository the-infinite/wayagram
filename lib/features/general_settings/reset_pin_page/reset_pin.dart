import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/auth/transaction_pin/vm/transaction_pin_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/widget/pin_input_field.dart';
import 'package:wayagram/features/auth/transaction_pin/widget/pin_keyboard.dart';

class ResetPinPage extends ConsumerStatefulWidget {

  static const route = '/reset-pin-page';
  const ResetPinPage({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPinPageState();
}

class _ResetPinPageState extends ConsumerState<ResetPinPage> {
  @override
  Widget build(BuildContext context) {
    final confirmPin = ref.watch(confirmPinProvider);
    final confirmNewPin = ref.watch(newPinConfirmationProvider);
    final isInValid = ref.watch(isChangePinValidProvider);
    final viewModel = ref.read(transactionPinProvider.notifier);

    final dynamic args  = ModalRoute.of(context)?.settings.arguments;
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: ref.watch(loadingProvider),
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
                    Text("Reset PIN", style: WayaTextStyles.titleLarge),
                    const Gap(5),
                    Text("For added security, please create a 4-digit PIN \n to confirm your transactions",
                        style: WayaTextStyles.hintStyle),
                    const Gap(10),
                  /*  PinInputField(
                      pin: pin,
                      label: "Enter your New 4-digit PIN",
                      digits: 4,
                      ratio: 0.17,
                      margin: 8,
                      height: 55,
                    ),*/
                    const Gap(10),
                    PinInputField(
                      pin: confirmPin,
                      label: "Enter your New 4-digit PIN",
                      digits: 4,
                      ratio: 0.17,
                      height: 55,
                      margin: 8,
                    ),
                    const Gap(10),
                    PinInputField(
                      pin: confirmNewPin,
                      label: "Re-enter your New PIN",
                      digits: 4,
                      ratio: 0.17,
                      height: 55,
                      margin: 8,
                    ),
                    const Gap(10),
                    Visibility(
                        visible: confirmNewPin.isNotEmpty && confirmPin.isNotEmpty && !isInValid,
                        child: Text("The PINs don't match. Pls try again",
                            style: TextStyle().wayaCopyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: wayaTheme.colorScheme.error500,
                            )))
                  ],
                )),
            SizedBox(
                child: PinKeyboard(
                    onKeyTap: viewModel.handleKeyPress,
                    onSubmit: (){
                      viewModel.resetPin('${args['code']}');
                    },
                    onBackspace: viewModel.handleBackspace)),
          ],
        ));
  }
}
