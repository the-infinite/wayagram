import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_state.dart';
import 'package:wayagram/features/shop/order/vm/order_vm.dart';
import 'package:wayagram/features/shop/order/widgets/contact_seller.dart';
import 'package:wayagram/features/shop/order/widgets/order_address_widget.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';
import 'package:wayagram/features/shop/widgets/copy_code.dart';
import 'package:wayagram/features/shop/order/widgets/order_tracking.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';

class OrderDetails extends ConsumerStatefulWidget {
  final String id;
  static const route = '/order-detail';
  const OrderDetails({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderDetails();
}

class _OrderDetails extends ConsumerState<OrderDetails> {
  Order? order;
  bool isLoading = false;
  late final notifier = ref.read(orderVmProvider.notifier);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      final response = await notifier.getSingleOrder(orderId: widget.id);
      setState(() {
        isLoading = false;
        if (response != null) {
          order = response;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    final notifier = ref.read(conversationProvider.notifier);

    if (isLoading) {
      return Container(
        width: context.width,
        height: context.height,
        color: wayaTheme.colorScheme.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (order == null) {
      return Container(
        width: context.width,
        height: context.height,
        color: wayaTheme.colorScheme.white,
        child: Center(
          child: Text("No Response"),
        ),
      );
    }

    void chatWithUser() async {
      //? This is fine.
      notifier.startChat(ChatType.personal, [order!.vendorId]).then(
        (chat) {
          //? Stop if we could not make this chat.
          if (chat == null) return;

          //? If we could make this chat...
          final chatNotifier = ref.read(chatProvider(chat.id).notifier);
          chatNotifier.setChat(chat);
          WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
        },
      ).catchError(
        (_) {
          //? Leave here.
          //   WayaNav.goBack();
        },
      );
    }

    //? The actual components.
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
                code: "#${order?.id.substring(0, 6)}", title: "Order Details"),
            const Gap(25),
            Text("Product Ordered", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order?.items.length,
                itemBuilder: (context, index) {
                  CartProduct cartOrder = CartProduct(
                      price: double.parse(order?.items[index].price ?? '0')
                          .toInt(),
                      quantity: order?.items[index].quantity ?? 0,
                      productId: order?.items[index].productId ?? '',
                      productName: order?.items[index].productName ?? '',
                      deliveryCharge: false,
                      unitPrice: "${order?.items[index].price ?? 0}",
                      productImage: order?.items[index].productImage ?? '',
                      deliveryOptions: '');
                  return OrderedProductCard(orders: cartOrder);
                }),
            const Gap(25),
            Visibility(
              visible: order?.pickupAddress != null,
              child: OrderAddressWidget(
                  type: 'Pickup Address', address: order?.pickupAddress ?? ''),
            ),
            Visibility(
              visible: order?.deliveryAddress != null,
              child: OrderAddressWidget(
                  type: 'Delivery Address',
                  address: order?.deliveryAddress ?? ''),
            ),
            Text("Token", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            CopyCode(
                code: order?.deliveryToken ?? '',
                title: "Delivery Confirmation Token"),
            const Gap(25),
            Text("Shop Details", style: wayaTheme.textTheme.bodyMedium),
            const Gap(15),
            OrderInfoWidget(
                title: "Shop Name", description: order?.shopName ?? ''),
            const Gap(8),
            OrderInfoWidget(
                title: "Date Ordered",
                description: WayaHelpers.formatDateString(
                    order?.updatedAt.toIso8601String())),
            const Gap(8),
            OrderInfoWidget(
                title: "Delivery Type", description: order?.deliveryType ?? ''),
            const Gap(25),
            WayaButton(
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 28,
                    color: wayaTheme.colorScheme.customPrimary,
                  ),
                  const Gap(8),
                  Text(
                    "Send Message",
                    style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ],
              ),
              callback: chatWithUser,
              color: wayaTheme.colorScheme.primary50,
            ),
            const Gap(25),
            Text(
                order?.deliveryType == 'Pickup'
                    ? "Pickup Progress"
                    : "Delivery Progress",
                style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            OrderTracking(
                statuses: order?.deliveryType == 'Pickup'
                    ? pickupStatus
                    : deliveryStatus,
                type: order?.deliveryType,
                currentStatuses: order?.deliveryType == 'Pickup'
                    ? order?.pickupStatusHistory
                    : order?.deliveryStatusHistory),
            const Gap(25),
            if (order?.status != 'cancelled') ...[
              Visibility(
                  visible: order?.status != 'completed' &&
                      ((order?.deliveryStatusHistory.isNotEmpty == true &&
                              order?.deliveryStatusHistory.last.status ==
                                  'completed') ||
                          (order?.pickupStatusHistory.isNotEmpty == true &&
                              order?.pickupStatusHistory.last.status ==
                                  'completed')),
                  child: WayaButton(
                    callback: () {
                      WayaNav.replaceNamed(ConfirmOrderDelivery.route,
                          arguments: order);
                    },
                    text: "Confirm Order Delivery",
                  )),
              const Gap(10),
              Visibility(
                  visible: order?.status == 'completed',
                  child: WayaButton(
                    callback: () async {
                      WayaUtils.showModalSheet(context,
                          child: ContactSeller(order: order!));
                    },
                    text: "Report a problem",
                  ))
            ]
          ],
        ));
  }
}
