import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/shop/order/vm/order_vm.dart';

class RejectionReason extends ConsumerWidget {
  final String orderId;

  const RejectionReason({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _controller = TextEditingController();
    final wayaTheme = Theme.of(context);
    final state = ref.watch(orderVmProvider);

    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(16), right: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Reject Order",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(24),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: wayaTheme.colorScheme.greyColor200,
                      thickness: 1,
                    ),
                  ),
                  Gap(10),
                  Text(
                    "Enter Rejection Reason",
                    style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor600,
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: Divider(
                      color: wayaTheme.colorScheme.greyColor200,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              WayaTextFormField(
                controller: _controller,
                hintText: "Write something ...",
                line: 5,
                padding: const EdgeInsets.all(12),
                label: "",
              ),
              const Gap(24),
              WayaButton(
                callback: !state.isRejecting
                    ? () {
                        if (_controller.text.isEmpty) {
                          return WayaSnackBar.showToast(
                              "Enter rejection reason");
                        }

                        ref.read(orderVmProvider.notifier).declineOrder(
                            orderId: orderId,
                            reason: _controller.text,
                            context: context);
                      }
                    : null,
                centerWidget: LoadingState(
                    loading: state.isRejecting, text: "Reject Order"),
              ),
              const Gap(10),
              WayaButton(
                  callback: () {
                     WayaNav.goBack();
                
                  },
                  textColor: wayaTheme.colorScheme.greyColor500,
                  color: wayaTheme.colorScheme.transparent,
                  border: Border.all(
                      color: wayaTheme.colorScheme.greyColor500, width: 1),
                  text: 'Cancel')
            ],
          ),
        ));
  }
}
