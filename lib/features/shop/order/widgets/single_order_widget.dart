import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_state.dart';

class SingleOrderWidget extends ConsumerWidget {
  final Order order;

  final bool isSeller;
  const SingleOrderWidget(
      {super.key, this.isSeller = false, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(singleOrderWigdetViewModelProvider);
    return GestureDetector(
      onTap: () {
        if (isSeller) {
          viewModel.sellerOrderAction(context);
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
                            context: context, status: order.deliveryStatus)
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "-${WayaHelpers.formatPrice(double.parse(order.total).toInt())}",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.error700, fontSize: 13),
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
      {required BuildContext context, required String status}) {
    final wayaTheme = Theme.of(context);

    // Map delivery status to color schemes
    final Map<String, Color> statusColors = {
      'pending': wayaTheme.colorScheme.pending50,
      'shipped': wayaTheme.colorScheme.info50,
      'delivered': wayaTheme.colorScheme.success50,
      'cancelled': wayaTheme.colorScheme.error200,
    };

    final Map<String, Color> textColors = {
      'pending': wayaTheme.colorScheme.pending,
      'shipped': wayaTheme.colorScheme.info,
      'delivered': wayaTheme.colorScheme.success,
      'cancelled': wayaTheme.colorScheme.error,
    };

    // Fallback to default colors if status is unknown
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
        status,
        style: TextStyle().wayaCopyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }
}

class SingleOrderWigdetViewModel extends ChangeNotifier {
  final Ref ref;
  SingleOrderWigdetViewModel(this.ref);

  Future<void> addDeliveryDetail(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container();
        });
  }

  Future<void> sellerOrderAction(BuildContext context) async {
    WayaUtils.showNotice(
        context: context,
        buttonText: 'Add Delivery Details',
        secondButtonText: 'See your Order Details',
        title: 'Populate Delivery Details',
        message:
            "Add the delivery price and date of delivery for this order so the \n customer can review and pay",
        onPress: () async {
          await addDeliveryDetail(context);
        },
        onCancel: () {
          WayaNav.toNamed('/seller-order-details', arguments: "id");
        },
        icon: Image.asset('assets/images/shop/delivery-van.png'));
  }
}

final singleOrderWigdetViewModelProvider =
    ChangeNotifierProvider<SingleOrderWigdetViewModel>(
        (ref) => SingleOrderWigdetViewModel(ref));
