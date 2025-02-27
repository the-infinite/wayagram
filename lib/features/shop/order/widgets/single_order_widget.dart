import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_state.dart';
import 'package:wayagram/features/shop/seller/views/orders/seller_order_details.dart';

class SingleOrderWidget extends ConsumerWidget {
  final Order order;

  final bool isSeller;
  const SingleOrderWidget(
      {super.key, this.isSeller = false, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    // final viewModel = ref.watch(singleOrderWigdetViewModelProvider);
    return GestureDetector(
      onTap: () {
        if (isSeller) {
          WayaNav.toNamed(SellerOrderDetails.route, arguments: order);
        } else {
          WayaNav.toNamed(OrderDetails.route,
              arguments: OrderDetailArg(type: 'buyer', order: order));
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/order-van.svg'),
                    const Gap(4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order #${order.id.substring(0, 6)}",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14),
                        ),
                        const Gap(8),
                        _buildOrderStatus(
                            context: context,
                            status: 'pending',
                            deliveryType: order.deliveryType!)
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${isSeller ? '+' : '-'}${WayaHelpers.formatPrice(double.parse(order.total).toInt())}",
                      style: TextStyle().wayaCopyWith(
                          color:isSeller ? wayaTheme.colorScheme.success: wayaTheme.colorScheme.error700, fontSize: 13),
                    ),
                    const Gap(8),
                    Text(
                      WayaHelpers.formatDateString(
                          order.updatedAt.toIso8601String()),
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor400,
                          fontSize: 13),
                    )
                  ],
                )
              ],
            ),
          ),
          const Gap(10)
        ],
      ),
    );
  }

  Widget _buildOrderStatus(
      {required BuildContext context,
      required String status,
      required String deliveryType}) {
    final wayaTheme = Theme.of(context);

    Map<String, Color> statusColors = {
      'pending': wayaTheme.colorScheme.pending50,
      deliveryType == 'Delivery' ? 'processing' : 'readyForPickup':
          wayaTheme.colorScheme.info50,
      'completed': wayaTheme.colorScheme.success50,
      deliveryType == 'Delivery' ? 'onTransit' : 'pickUpScheduled':
          wayaTheme.colorScheme.info50,
    };

    Map<String, Color> textColors = {
      'pending': wayaTheme.colorScheme.pending,
      deliveryType == 'Delivery' ? 'processing' : 'readyForPickup':
          wayaTheme.colorScheme.info,
      'completed': wayaTheme.colorScheme.success,
      deliveryType == 'Delivery' ? 'onTransit' : 'pickUpScheduled':
          wayaTheme.colorScheme.info,
    };

    final backgroundColor =
        statusColors[status] ?? wayaTheme.colorScheme.greyColor300;
    final textColor = textColors[status] ?? wayaTheme.colorScheme.customBlack;

    return Container(
      padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        WayaHelpers.removeCamelCaseAndUnderscore(status),
        style: TextStyle().wayaCopyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }
}
