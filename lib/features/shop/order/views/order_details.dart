import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_state.dart';
import 'package:wayagram/features/shop/order/widgets/order_address_widget.dart';
import 'package:wayagram/features/shop/widgets/copy_code.dart';
import 'package:wayagram/features/shop/order/widgets/order_tracking.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';

class OrderDetails extends ConsumerWidget {
  static const route = '/order-detail';
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    final OrderDetailArg? arg =
        ModalRoute.of(context)?.settings.arguments as OrderDetailArg?;

    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: "Order Details",
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Details", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            CopyCode(
                code: "#${arg?.order.id.substring(0, 6)}",
                title: "Order Details"),
            const Gap(25),
            Text("Product Ordered", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: arg?.order.items.length,
                itemBuilder: (context, index) {
                  CartProduct order = CartProduct(
                      price: double.parse(arg?.order.items[index].price ?? '0')
                          .toInt(),
                      quantity: arg?.order.items[index].quantity ?? 0,
                      productId: arg?.order.items[index].productId ?? '',
                      productName: arg?.order.items[index].productName ?? '',
                      deliveryCharge: false,
                      unitPrice: "${arg?.order.items[index].price ?? 0}",
                      productImage: arg?.order.items[index].productImage ?? '',
                      deliveryOptions: '');
                  return OrderedProductCard(orders: order);
                }),
            const Gap(25),
            Visibility(
              visible: arg?.order.pickupAddress != null,
              child: OrderAddressWidget(
                  type: 'Pickup Address',
                  address: arg?.order.pickupAddress ?? ''),
            ),
            Visibility(
              visible: arg?.order.deliveryAddress != null,
              child: OrderAddressWidget(
                  type: 'Delivery Address',
                  address: arg?.order.deliveryAddress ?? ''),
            ),
            Text("Token", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            CopyCode(
                code: arg?.order.deliveryToken ?? '',
                title: "Delivery Confirmation Token"),
            const Gap(25),
            Text(
                arg?.order.deliveryType == 'Pickup'
                    ? "Pickup Progress"
                    : "Delivery Progress",
                style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            OrderTracking(
                statuses: arg?.order.deliveryType == 'Pickup'
                    ? pickupStatus
                    : deliveryStatus,
                type: arg?.order.deliveryType,
                currentStatuses: arg?.order.deliveryType == 'Pickup'
                    ? arg?.order.pickupStatusHistory
                    : arg?.order.deliveryStatusHistory),
            const Gap(25),
            Visibility(
                visible: (arg?.order.deliveryStatusHistory.isNotEmpty == true &&
                        arg?.order.deliveryStatusHistory.last.status ==
                            'completed') ||
                    (arg?.order.pickupStatusHistory.isNotEmpty == true &&
                        arg?.order.pickupStatusHistory.last.status ==
                            'completed'),
                child: WayaButton(
                  callback: () {
                    WayaNav.toNamed(ConfirmOrderDelivery.route,
                        arguments: arg?.order);
                  },
                  text: "Confirm Order Delivery",
                ))
          ],
        ));
  }
}

/**
 
 */
