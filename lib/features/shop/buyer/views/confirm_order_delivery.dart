import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/auth/transaction_pin/widget/pin_input_field.dart';
import 'package:wayagram/features/auth/transaction_pin/widget/pin_keyboard.dart';
import 'package:wayagram/features/shop/buyer/vm/confirm_order_delivery_vm.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/widgets/copy_code.dart';

class ConfirmOrderDelivery extends ConsumerStatefulWidget {
  static const route = '/confirm-order-delivery';
  const ConfirmOrderDelivery({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmOrderDeliveryState();
}

class _ConfirmOrderDeliveryState extends ConsumerState<ConfirmOrderDelivery> {
  @override
  Widget build(BuildContext context) {
    final pin = ref.watch(orderPinProvider);
    final viewModel = ref.read(confirmOrderDeliveryVmProvider.notifier);
    final wayaTheme = Theme.of(context);
    final state = ref.watch(confirmOrderDeliveryVmProvider);

    final Order? arg = ModalRoute.of(context)?.settings.arguments as Order?;

    return WayaScaffold(
        title: 'Confirm Order Delivery',
        isLoading: state.isLoading,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(30),
                Text("Enter 10 Digits Code", style: WayaTextStyles.titleLarge),
                const Gap(5),
                Text("Enter 10 digits code to complete the handover",
                    style: WayaTextStyles.hintStyle),
                const Gap(30),
                CopyCode(code: arg!.deliveryToken!, title: "Delivery Confirmation Token"),
                const Gap(2),
                PinInputField(
                  pin: pin,
                  digits: 10,
                  margin: 2.5,
                  ratio: 0.08,
                  height: 48,
                ),
                const Gap(25),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: 200,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.primary75,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: RichText(
                          text:  TextSpan(children: [
                        TextSpan(
                            text: "Having issue? ",
                            style: WayaTextStyles.bodySmall),
                        TextSpan(
                            text: "Contact Support",
                            style: WayaTextStyles.smallActiveLinkStyle),
                  
                      ]))),
                ),
              ],
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    child: PinKeyboard(
                        onKeyTap: viewModel.handleKeyPress,
                        onSubmit: () => viewModel.submitPins(context, arg.shopId),
                        onBackspace: viewModel.handleBackspace)),
                const Gap(20),
              ],
            )
          ],
        ));
  }
}
