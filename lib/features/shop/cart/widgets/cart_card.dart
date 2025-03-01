import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/cart/widgets/cart_card_vm.dart';

class CartCard extends ConsumerStatefulWidget {
  final CartItem cartItem;
  final String cartId;
  const CartCard({super.key, required this.cartItem, required this.cartId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<CartCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final wayaTheme = Theme.of(context);
    //  final viewModel = ref.watch(cartCardVmProvider);

    final bool isDeliveryCharge = widget.cartItem.products.any((prod) =>
        (prod.deliveryCharge && widget.cartItem.deliveryFee == null) ||
        (prod.deliveryOptions == 'Delivery' &&
            widget.cartItem.deliveryAddress == null));

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WayaDp(
                      radius: 20,
                      image: widget.cartItem.shopLogo,
                    ),
                    const Gap(6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cartItem.shopName,
                          style: TextStyle().wayaCopyWith(
                              fontSize: 18,
                              color: wayaTheme.colorScheme.customBlack),
                        ),
                        Text(
                          "Delivery Date: ${(widget.cartItem.deliveryDate != null && widget.cartItem.deliveryDate!.isNotEmpty) ? WayaHelpers.formatDateString(widget.cartItem.deliveryDate) : ''}",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.greyColor400,
                              fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isDeliveryCharge)
                      GestureDetector(
                        onTap: () {
                          ref.read(cartCardVmProvider.notifier).deliveryRequest(
                              context,
                              widget.cartItem.products,
                              widget.cartItem.shopId,
                              widget.cartItem.shopName,
                              widget.cartItem.shopLogo);
                        },
                        child: SvgPicture.asset('assets/icons/chat.svg'),
                      ),
                    const Gap(10),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: wayaTheme.colorScheme.customPrimary,
                        size: 22,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        const Gap(10),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.cartItem.products.length,
                  itemBuilder: (context, index) {
                    return CartProductCard(
                        shopId: widget.cartItem.shopId,
                        cartProduct: widget.cartItem.products[index]);
                  })
              : SizedBox.shrink(),
        ),
        // const Gap(10),
        Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
              border: Border.all(
                  color: wayaTheme.colorScheme.greyColor300, width: 1),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width * 0.40,
                child: Center(
                  child: Text(
                      WayaHelpers.formatPrice(widget.cartItem.totalFee ?? 0),
                      style: wayaTheme.textTheme.titleLarge),
                ),
              ),
              SizedBox(
                width: context.width * 0.40,
                child: WayaButton(
                    callback: () {
                      if (isDeliveryCharge) {
                        return ref
                            .read(cartCardVmProvider.notifier)
                            .deliveryRequest(
                                context,
                                widget.cartItem.products,
                                widget.cartItem.shopId,
                                widget.cartItem.shopName,
                                widget.cartItem.shopLogo);
                      }
                      WayaNav.toNamed(Checkout.route,
                          arguments: CheckoutArg(
                              cartId: widget.cartId,
                              cartItem: widget.cartItem));
                    },
                    text: isDeliveryCharge ? "Request Delivery" : "Checkout"),
              )
            ],
          ),
        ),
        const Gap(30),
      ],
    );
  }
}

class CartProductCard extends ConsumerWidget {
  final CartProduct cartProduct;
  final String shopId;
  const CartProductCard(
      {super.key, required this.cartProduct, required this.shopId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //)
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
              border: Border.all(
                  color: wayaTheme.colorScheme.greyColor300, width: 1),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  WayaImage(
                    imageUrl: cartProduct.productImage ?? '',
                    height: 70,
                    width: 50,
                    radius: BorderRadius.circular(8),
                    fit: BoxFit.contain,
                  ),
                  const Gap(5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.width * 0.3,
                        child: Text(
                          cartProduct.productName,
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        "Quantity: ${cartProduct.quantity} x ${WayaHelpers.formatPrice((double.parse(cartProduct.unitPrice)).toInt())}",
                        style: wayaTheme.textTheme.hintStyle,
                      ),
                      const Gap(5),
                      Text(
                        WayaHelpers.formatPrice(double.parse(cartProduct.unitPrice).toInt() * cartProduct.quantity),
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ref.read(cartVmProvider.notifier).addToCart(
                          count: 1,
                          productId: cartProduct.productId,
                          shopId: shopId,
                          price: double.parse(cartProduct.unitPrice).toInt(),
                          productImage: cartProduct.productImage ?? '',
                          productName: cartProduct.productName);
                    },
                    child: SvgPicture.asset('assets/icons/a-cart.svg'),
                  ),
                  const Gap(4),
                  Text(
                    "${cartProduct.quantity}",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  const Gap(6),
                  GestureDetector(
                    onTap: () {
                      ref.read(cartVmProvider.notifier).removeFromCart(
                          productId: cartProduct.productId, shopId: shopId);
                    },
                    child: SvgPicture.asset('assets/icons/r-cart.svg'),
                  ),
                ],
              )
            ],
          ),
        ),
        const Gap(10),
      ],
    );
  }
}
