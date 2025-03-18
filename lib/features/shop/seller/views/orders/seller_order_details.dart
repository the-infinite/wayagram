import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/seller_order_detail_vm.dart';
import 'package:wayagram/features/shop/widgets/dotted_border_order_info_widget.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';

class SellerOrderDetails extends ConsumerWidget {
  static const route = '/seller-order-details';
  const SellerOrderDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(sellerOrderDetailVmProvider);
    final notifier = ref.read(conversationProvider.notifier);
    final chatNotifier = ref.read(chatProvider.notifier);

    final wayaTheme = Theme.of(context);

    final Order? arg = ModalRoute.of(context)?.settings.arguments as Order?;

    void chatWithUser() async {
      //? This is fine.
      notifier.startChat(ChatType.personal, [arg!.userId]).then(
        (chat) {
          //? Stop if we could not make this chat.
          if (chat == null) return;

          //? If we could make this chat...
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

    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Orders',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Details", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'View and Manage the order',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(30),
            Text("Product Ordered", style: wayaTheme.textTheme.bodyMedium),
            const Gap(15),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: arg?.items.length,
                itemBuilder: (context, index) {
                  CartProduct order = CartProduct(
                      price:
                          double.parse(arg?.items[index].price ?? '0').toInt(),
                      quantity: arg?.items[index].quantity ?? 0,
                      productId: arg?.items[index].productId ?? '',
                      productName: arg?.items[index].productName ?? '',
                      deliveryCharge: false,
                      unitPrice: "${arg?.items[index].price ?? 0}",
                      productImage: arg?.items[index].productImage ?? '',
                      deliveryOptions: '');
                  return OrderedProductCard(orders: order);
                }),
            const Gap(10),
            DottedBorderOrderInfoWidget(
                title: "Sub Total",
                description: WayaHelpers.formatPrice(
                    double.parse(arg?.total ?? '0').toInt())),
            const Gap(25),
            Text("Customer Details", style: wayaTheme.textTheme.bodyMedium),
            const Gap(15),
            OrderInfoWidget(
                title: "Customer's Name", description: 'Fasas Oyewole'),
            const Gap(8),
            OrderInfoWidget(
                title: "Order ID", description: '#${arg?.id.substring(0, 6)}'),
            const Gap(8),
            OrderInfoWidget(
                title: "Date Ordered",
                description: WayaHelpers.formatDateString(
                    arg?.updatedAt.toIso8601String())),
            const Gap(8),

            OrderInfoWidget(
                title: "Delivery Type", description: arg?.deliveryType ?? ''),
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
            Visibility(
              visible: arg?.deliveryType == 'Delivery',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(25),
                  Text("Delivery Details",
                      style: wayaTheme.textTheme.bodyMedium),
                  const Gap(25),
                  OrderInfoWidget(
                      title: "Delivery Address",
                      description: arg?.deliveryAddress ?? '-'),
                  const Gap(8),
                  // OrderInfoWidget(
                  //     title: "Delivery Status",
                  //     description: arg?.deliveryStatus ?? '-'),
                  const Gap(8),
                  OrderInfoWidget(
                      title: "Delivery Price",
                      description:
                          WayaHelpers.formatPrice(arg?.deliveryFee ?? 0)),
                  const Gap(8),
                  OrderInfoWidget(
                      title: "Delivery Date",
                      description: WayaHelpers.formatDateString(
                          arg?.deliveryDate?.toIso8601String())),
                ],
              ),
            ),
            const Gap(30),
            // WayaButton(
            //   callback: () {
            //     viewModel.acceptOrder(context);
            //   },
            //   text: "Accept Order",
            // ),
            if (arg?.deliveryType == 'Delivery')
              WayaButton(
                color: wayaTheme.colorScheme.transparent,
                textColor: wayaTheme.colorScheme.greyColor900,
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {
                  viewModel.updateDeliveryStatus(
                      context: context, orderId: arg!.id);
                },
                text: "Change Delivery Status",
                leadingIcon: SvgPicture.asset(
                  'assets/icons/van-icon.svg',
                  colorFilter: ColorFilter.mode(
                      wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                  width: 20,
                ),
              ),

            if (arg?.deliveryType == 'Pickup')
              WayaButton(
                color: wayaTheme.colorScheme.transparent,
                textColor: wayaTheme.colorScheme.greyColor900,
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {
                  viewModel.updateOrderStatus(
                      context: context, orderId: arg!.id);
                },
                text: "Change Pickup Status",
                leadingIcon: SvgPicture.asset(
                  'assets/icons/button-icon.svg',
                  colorFilter: ColorFilter.mode(
                      wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                  width: 20,
                ),
              ),
            const Gap(10),
            WayaButton(
              color: wayaTheme.colorScheme.transparent,
              textColor: wayaTheme.colorScheme.greyColor900,
              border: Border.all(
                  width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                viewModel.rejectOrder(context, arg!.id);
              },
              text: "Reject Order",
            )
          ],
        ));
  }
}
