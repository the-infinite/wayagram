import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/cart/widgets/cart_card_vm.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

class CartCard extends ConsumerStatefulWidget {
  const CartCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<CartCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(cartCardVmProvider);

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
                    ),
                    const Gap(6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Maleek Ventures",
                          style: TextStyle().wayaCopyWith(
                              fontSize: 18,
                              color: wayaTheme.colorScheme.customBlack),
                        ),
                        Text(
                          "Delivery Date: Jan 30th 2024",
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
                    GestureDetector(
                      onTap: () {
                        viewModel.deliveryRequest(context, products);
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
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return CartProductCard(cartProduct: products[index]);
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
                  child:
                      Text("N 800,000", style: wayaTheme.textTheme.titleLarge),
                ),
              ),
              SizedBox(
                width: context.width * 0.40,
                child: WayaButton(
                    callback: () {
                      WayaNav.toNamed('/checkout');
                    },
                    text: "Checkout"),
              )
            ],
          ),
        ),
        const Gap(20),
      ],
    );
  }
}

class CartProductCard extends StatelessWidget {
  final Product cartProduct;
  const CartProductCard({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  cartProduct.images.isEmpty
                      ? Container(
                          height: 70,
                          width: 50,
                          decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.scaffoldColor,
                              borderRadius: BorderRadius.circular(8)),
                        )
                      : WayaImage(imageUrl:  cartProduct.images[0], height: 70, width: 50, radius: BorderRadius.circular(8),fit: BoxFit.contain,),
                  const Gap(5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.width * 0.3,
                        child: Text(
                          "Itel Powerbank 60,000mah Fast charging",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        "Quantity: 1 x N5,000",
                        style: wayaTheme.textTheme.hintStyle,
                      ),
                      const Gap(5),
                      Text(
                        "N 300,000",
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
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/a-cart.svg'),
                  ),
                  const Gap(4),
                  Text(
                    "1",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  const Gap(6),
                  GestureDetector(
                    onTap: () {},
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
