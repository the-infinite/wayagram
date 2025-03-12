import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';

class DeliveryCostRequest extends ConsumerWidget {
  final List<CartProduct> orders;
  final String shopId;
  final String shopName;
  final String shopLogo;
  final VoidCallback onPress;

  const DeliveryCostRequest(
      {super.key,
      required this.onPress,
      required this.orders,
      required this.shopId,
      required this.shopLogo,
      required this.shopName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _controller = TextEditingController();
    final wayaTheme = Theme.of(context);
    final state = ref.watch(cartVmProvider);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(16), right: Radius.circular(16)),

        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Delivery Cost Request",
                textAlign: TextAlign.start,
                style: wayaTheme.textTheme.headlineMedium
              ),
              const Gap(12),
              Text(
                "Add delivery address this to order so the seller can review and send the delivery cost for it.",
                textAlign: TextAlign.start,
                style: WayaTextStyles.descriptionStyle,
              ),
              const Gap(24),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.greyColor100,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WayaDp(
                      radius: 24,
                      image: shopLogo,
                    ),
                    const Gap(6),
                    Text(
                      shopName.capitalizeFirst!,
                      style: wayaTheme.textTheme.labelMedium,
                    )
                  ],
                ),
              ),
              const Gap(24),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrderedProductCard(orders: orders[index]);
                  }),
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
                    "Enter Delivery Details",
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
                hintText: "Enter delivery address for this order",
                line: 5,
                padding: const EdgeInsets.all(12),
                label: "Delivery Address",
              ),
              const Gap(24),
              WayaButton(
                  callback: !state.isRequestingDelivery
                      ? () {
                          if (_controller.text.isEmpty) {
                            return WayaSnackBar.showToast(
                                "Enter a delivery address");
                          }

                          ref.read(cartVmProvider.notifier).deliveryRequest(
                              shopId: shopId, address: _controller.text);
                          Navigator.pop(context);
                        }
                      : null,
                  text: "Request Delivery Cost"),
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
