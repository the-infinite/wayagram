import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/seller_order_detail_vm.dart';
import 'package:wayagram/features/shop/seller/vm/seller_orders_vm.dart';
import 'package:wayagram/features/shop/widgets/dotted_border_order_info_widget.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

class SellerOrderDetails extends ConsumerStatefulWidget {
  final String id;
  static const route = '/seller-order-details';
  const SellerOrderDetails({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SellerOrderDetails();
}

class _SellerOrderDetails extends ConsumerState<SellerOrderDetails> {
  String userName = "";
  final ProfileRepo repo = ProfileRepo();
  late final notifier = ref.read(sellerOrdersVmProvider.notifier);
  Order? order;
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      final response = await notifier.getSellerSingleOrder(orderId: widget.id);
      setState(() {
        isLoading = false;
        if (response != null) {
          order = response;
          getUser(userId: response.userId);
        }
      });

     
    });
    super.initState();
  }

  void getUser({required String userId}) async {
    final response = await repo.getUserDataRepo(userId: userId);
    if (response.success) {
      UserAccountModel responseModel = UserAccountModel.fromJson(response.data);
      String? firstName = responseModel.data?.userdata?.user?.firstName ?? '';
      String? lastName = responseModel.data?.userdata?.user?.lastName ?? '';
      setState(() {
        userName = "$firstName $lastName";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(sellerOrderDetailVmProvider);
    final notifier = ref.read(conversationProvider.notifier);

    final wayaTheme = Theme.of(context);

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

    if (order == null)  {
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
      notifier.startChat(ChatType.personal, [order!.userId]).then(
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
                itemCount: order?.items.length,
                itemBuilder: (context, index) {
                  CartProduct cartOrder = CartProduct(
                      price:
                          double.parse(order?.items[index].price ?? '0').toInt(),
                      quantity: order?.items[index].quantity ?? 0,
                      productId: order?.items[index].productId ?? '',
                      productName: order?.items[index].productName ?? '',
                      deliveryCharge: false,
                      unitPrice: "${order?.items[index].price ?? 0}",
                      productImage: order?.items[index].productImage ?? '',
                      deliveryOptions: '');
                  return OrderedProductCard(orders: cartOrder);
                }),
            const Gap(10),
            DottedBorderOrderInfoWidget(
                title: "Sub Total",
                description: WayaHelpers.formatPrice(
                    double.parse(order?.total ?? '0').toInt())),
            const Gap(25),
            Text("Customer Details", style: wayaTheme.textTheme.bodyMedium),
            const Gap(15),
            OrderInfoWidget(
                title: "Customer's Name",
                description: userName.capitalizeFirst!),
            const Gap(8),
            OrderInfoWidget(
                title: "Order ID", description: '#${order?.id.substring(0, 6)}'),
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
            Visibility(
              visible: order?.deliveryType == 'Delivery',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(25),
                  Text("Delivery Details",
                      style: wayaTheme.textTheme.bodyMedium),
                  const Gap(25),
                  OrderInfoWidget(
                      title: "Delivery Address",
                      description: order?.deliveryAddress ?? '-'),
                  const Gap(8),
                  // OrderInfoWidget(
                  //     title: "Delivery Status",
                  //     description: arg?.deliveryStatus ?? '-'),
                  const Gap(8),
                  OrderInfoWidget(
                      title: "Delivery Price",
                      description:
                          WayaHelpers.formatPrice(order?.deliveryFee ?? 0)),
                  const Gap(8),
                  OrderInfoWidget(
                      title: "Delivery Date",
                      description: WayaHelpers.formatDateString(
                          order?.deliveryDate?.toIso8601String())),
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
            if (order?.status == 'cancelled' ||
                ((order?.deliveryStatusHistory.isNotEmpty == true &&
                        order?.deliveryStatusHistory.last.status ==
                            'completed') ||
                    (order?.pickupStatusHistory.isNotEmpty == true &&
                        order?.pickupStatusHistory.last.status ==
                            'completed'))) ...[
              SizedBox.shrink()
            ] else ...[
              if (order?.deliveryType == 'Delivery')
                WayaButton(
                  color: wayaTheme.colorScheme.transparent,
                  textColor: wayaTheme.colorScheme.greyColor900,
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor300),
                  callback: () {
                   viewModel.updateDeliveryStatus(
                          shopId: order!.shopId,
                          current: order!.deliveryStatusHistory.last.status,
                          context: context,
                          orderId: order!.id);
                  },
                  text: "Change Delivery Status",
                  leadingIcon: SvgPicture.asset(
                    'assets/icons/van-icon.svg',
                    colorFilter: ColorFilter.mode(
                        wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                    width: 20,
                  ),
                ),
              if (order?.deliveryType == 'Pickup')
                WayaButton(
                  color: wayaTheme.colorScheme.transparent,
                  textColor: wayaTheme.colorScheme.greyColor900,
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor300),
                  callback: () {
                    viewModel.updateOrderStatus(
                        shopId: order?.shopId ?? '',
                        current:
                            order?.pickupStatusHistory.last.status ?? 'pending',
                        context: context,
                        orderId: order!.id);
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
                  viewModel.rejectOrder(
                    context,
                    order!.id,
                    order!.shopId,
                  );
                },
                text: "Reject Order",
              )
            ]
          ],
        ));
  }
}
