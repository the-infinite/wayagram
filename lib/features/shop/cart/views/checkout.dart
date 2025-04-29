import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:wayagram/features/shop/cart/vm/checkout_vm.dart';
import 'package:wayagram/features/shop/cart/widgets/cart_card_vm.dart';
import 'package:wayagram/features/shop/order/widgets/order_address_widget.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';
import 'package:wayagram/shared/components/radio_select.dart';

class Checkout extends ConsumerStatefulWidget {
  static const route = '/checkout';
  const Checkout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckoutState();
}

class _CheckoutState extends ConsumerState<Checkout> {
  int pickUpindex = -1;
  String sellerId = '';
  bool isLoading = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final CheckoutArg? arg = ModalRoute.of(context)?.settings.arguments as CheckoutArg?;

      final pIndex = arg?.cartItem.products
          .indexWhere((prod) => prod.deliveryOptions == 'Pickup' || prod.deliveryOptions == 'Both');

      setState(() {
        pickUpindex = pIndex ?? -1;
      });

      final shopId = arg?.cartItem.shopId;
      getCurrentShop(shopId);
    });
    super.initState();
  }

  Future<void> getCurrentShop(String? shop) async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await ref.read(manageShopVmProvider.notifier).getShopDetails(id: shop!);
      ShopData shopData = ShopData.fromJson(result!.shop.toJson());

      setState(() {
        sellerId = shopData.vendorId;
      });
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final key = "checkout";
    final viewModel = ref.watch(checkoutVmProvider);
    final notifier = ref.read(conversationProvider.notifier);
    final selectedOption = ref.watch(radioSelectProvider(key));
    final CheckoutArg? arg = ModalRoute.of(context)?.settings.arguments as CheckoutArg?;

    final subTotal = arg?.cartItem == null
        ? 0
        : arg?.cartItem.products.fold(
            0,
            (prodSum, prod) => prodSum + (double.parse(prod.unitPrice).toInt() * prod.quantity),
          );
    final int deliveryCharge = arg?.cartItem.deliveryFee ?? 0;

    final isBothDeliveryOption = arg?.cartItem.products.any((prod) => prod.deliveryOptions == 'Both');

    // final pickUpindex = arg?.cartItem.products
    //     .indexWhere((prod) => prod.deliveryOptions == 'Pickup');
    // debugPrint(pickUpindex);
    // if (pickUpindex != -1) {
    //   debugPrint(arg?.cartItem.products[pickUpindex!].pickUpAddress);
    // }

    void chatWithUser() async {
      //? This is fine.
      notifier.startChat(ChatType.personal, [sellerId]).then(
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

    debugPrint(isBothDeliveryOption.toString());
    debugPrint(selectedOption);
    return WayaScaffold(
      title: "Checkout",
      isLoading: viewModel.isLoading || isLoading,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          if (isBothDeliveryOption == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Delivery Option", style: wayaTheme.textTheme.bodyMedium),
                const Gap(6),
                RadioSelect(
                  title: Text("Delivery",
                      style: wayaTheme.textTheme.titleMedium!
                          .wayaCopyWith(fontSize: 14.sp, color: wayaTheme.colorScheme.customBlack)),
                  value: 'Delivery',
                  groupedValue: selectedOption,
                  onChanged: (value) => ref.read(radioSelectProvider(key).notifier).state = value,
                ),
                //      const Gap(10),
                RadioSelect(
                  title: Text("Pick-up",
                      style: wayaTheme.textTheme.titleMedium!
                          .wayaCopyWith(fontSize: 14.sp, color: wayaTheme.colorScheme.customBlack)),
                  value: 'Pickup',
                  groupedValue: selectedOption,
                  onChanged: (value) => ref.read(radioSelectProvider(key).notifier).state = value,
                ),
              ],
            ),
          const Gap(25),
          if (isBothDeliveryOption == false ||
              (isBothDeliveryOption == true &&
                  selectedOption == 'Delivery' &&
                  arg?.cartItem.deliveryAddress != null)) ...[
            OrderAddressWidget(address: arg?.cartItem.deliveryAddress, type: "Delivery Address"),
          ],
          if ((pickUpindex != -1 && isBothDeliveryOption == false) || (pickUpindex != -1 && selectedOption == 'Pickup'))
            OrderAddressWidget(address: arg?.cartItem.products[pickUpindex].pickUpAddress, type: "Pickup Address"),
          if (selectedOption == 'Delivery' && arg?.cartItem.deliveryAddress == null)
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
                    "Request Delivery Cost",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
                  ),
                ],
              ),
              callback: () {
                if (arg != null) {
                  ref.read(cartCardVmProvider.notifier).deliveryRequest(context, arg.cartItem.products,
                      arg.cartItem.shopId, arg.cartItem.shopName, arg.cartItem.shopLogo);
                }
              },
              color: wayaTheme.colorScheme.primary50,
            ),
          const Gap(10),
          Text("Product Ordered", style: wayaTheme.textTheme.bodyMedium),
          const Gap(10),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: arg?.cartItem.products.length,
              itemBuilder: (context, index) {
                return OrderedProductCard(orders: arg!.cartItem.products[index]);
              }),
          const Gap(25),
          Text("Cost Breakdown", style: wayaTheme.textTheme.bodyMedium),
          const Gap(10),
          DottedBorder(
            borderType: BorderType.RRect,
            color: wayaTheme.colorScheme.greyColor300,
            radius: Radius.circular(8),
            padding: EdgeInsets.all(14),
            dashPattern: [5, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sub Total",
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 13.sp),
                    ),
                    const Gap(6),
                    Text(
                      WayaHelpers.formatPrice(subTotal ?? 0),
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14.sp),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Gap(10),
          DottedBorder(
            borderType: BorderType.RRect,
            color: wayaTheme.colorScheme.greyColor300,
            radius: Radius.circular(8),
            padding: EdgeInsets.all(14),
            dashPattern: [5, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Delivery Charges",
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 13.sp),
                    ),
                    const Gap(6),
                    Text(
                      WayaHelpers.formatPrice(deliveryCharge),
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14.sp),
                    )
                  ],
                ),
              ),
            ),
          ),
          if ((isBothDeliveryOption == true &&
              selectedOption == 'Delivery' &&
              arg?.cartItem.deliveryAddress != null)) ...[
            const Gap(8),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                  onTap: chatWithUser,
                  child: Text(
                    "Need a delivery fee review?",
                    style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary, fontSize: 12.sp, fontWeight: FontWeight.w500),
                  )),
            ),
          ],
          const Gap(10),
          DottedBorder(
            borderType: BorderType.RRect,
            color: wayaTheme.colorScheme.greyColor300,
            radius: Radius.circular(8),
            padding: EdgeInsets.all(14),
            dashPattern: [5, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 13.sp),
                    ),
                    const Gap(6),
                    Text(
                      WayaHelpers.formatPrice(subTotal! + deliveryCharge),
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 18.sp),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Gap(25),
          Text("Payment Method", style: wayaTheme.textTheme.bodyMedium),
          const Gap(10),
          Container(
            padding: EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: wayaTheme.colorScheme.scaffoldColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/wallet-icon.svg'),
                    const Gap(8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wayagram Wallet",
                          style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 16.sp),
                        ),
                        const Gap(6),
                        Text(
                          "This transaction will be deducted from \n your wallet  balance",
                          style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 14.sp),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, border: Border.all(width: 1, color: wayaTheme.colorScheme.customPrimary)),
                  child: Center(
                      child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.customPrimary,
                      shape: BoxShape.circle,
                    ),
                  )),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: context.width * 0.35,
                height: 50,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      top: 8,
                      child: Text(
                        "Total",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor500, fontWeight: FontWeight.normal, fontSize: 14.sp),
                      ),
                    ),
                    Positioned(
                        top: 25,
                        child: Text(
                          WayaHelpers.formatPrice(subTotal + deliveryCharge),
                          style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 18.sp),
                        ))
                  ],
                )),
            SizedBox(
              width: context.width * 0.45,
              child: WayaButton(
                callback: (selectedOption == 'Delivery' && arg?.cartItem.deliveryAddress == null)
                    ? null
                    : () {
                        // arg?.cartId
                        if (isBothDeliveryOption == true && selectedOption == null) {
                          WayaSnackBar.showToast("Pls select a delivery option");
                          return;
                        }
                        if (isBothDeliveryOption == true &&
                            arg?.cartItem.deliveryAddress == null &&
                            selectedOption == 'Delivery') {
                          WayaSnackBar.showToast("Pls add a delivery address");
                          return;
                        }
                        if (arg != null) {
                          ref.read(checkoutVmProvider.notifier).checkout(
                              context: context,
                              cartId: arg.cartId,
                              shopId: arg.cartItem.shopId,
                              amount: subTotal + deliveryCharge,
                              pickupAddress: arg.cartItem.deliveryAddress == null
                                  ? arg.cartItem.products[pickUpindex].pickUpAddress
                                  : null);
                        }
                      },
                text: 'CheckOut',
              ),
            )
          ],
        ),
      ),
    );
  }
}
