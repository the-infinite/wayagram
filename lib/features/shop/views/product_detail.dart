import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/vm/product_detail_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/shop/widgets/product_description_widget.dart';
import 'package:wayagram/features/shop/widgets/product_image_widget.dart';
import 'package:wayagram/features/shop/widgets/product_review_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class ProductDetail extends ConsumerWidget {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final viewModel = ref.watch(productDetailVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      title: "Product Details",
      isScrollable: true,
      isLoading: false,
      appBarTrailing: WayaCartIcon(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.width * 0.7,
                child: Text(
                  "Dr Teal's Body Wash Glow & Radiance Vitamin C 24oz",
                  style: wayaTheme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.secondaryColor2,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(7),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                  },
                  child: SvgPicture.asset('assets/icons/heart.svg',
                      fit: BoxFit.none),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.secondaryColor2,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(7),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                  },
                  child: SvgPicture.asset('assets/icons/share-network.svg',
                      fit: BoxFit.none),
                ),
              )
            ],
          ),
          const Gap(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.customPrimary,
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Text("WAYAGRAM DEAL",
                      style: TextStyle().wayaCopyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ),
              ),
              const Gap(8),
              Container(
                width: 60,
                padding: EdgeInsets.fromLTRB(4, 3, 4, 3),
                decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.primar50,
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Text("12 Left",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ),
              ),
            ],
          ),
          const Gap(25),
          ProductImageWidget(images: [
           'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
          ]),
          const Gap(25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Price",
                style: wayaTheme.textTheme.titleMedium,
              ),
              Text(
                "N 200,023",
                style: wayaTheme.textTheme.titleLarge,
              )
            ],
          ),
          const Gap(25),
          Text(
            textAlign: TextAlign.start,
            "Product Description",
            style: wayaTheme.textTheme.titleMedium,
          ),
          const Gap(20),
          ProductDescriptionWidget(
              description:
                  "Dr Teal’s Ultra Moisturizing Body Wash hydrates, conditions and moisturizes skin with Aloe Vera, Shea Butter and Vitamin E, while Pure Epsom Salt helps revitalize tired, achy muscles. Vitamin C promotes youthful, glowing, skin. Citrus essential oils help uplift mood. Made with Pure Epsom Salt to help revitalize tired, achy muscles Vitamin C promotes youthful, glowing, skin. Citrus essential oils help uplift mood."),
          const Gap(25),
          // Text(
          //   "Select Color Type",
          //   style: wayaTheme.textTheme.titleMedium,
          // ),
          //  const Gap(25),
          //  ----------- vendor details ---------
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vendor Details",
                      style: wayaTheme.textTheme.hintStyle,
                    ),
                    const Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/avatars.png",
                          width: 26,
                          height: 26,
                        ),
                        const Gap(6),
                        Text(
                          "Maleek Ventures",
                          style: wayaTheme.textTheme.labelMedium,
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingStars(rating: 4),
                    const Gap(2),
                    Text(
                      "4.0",
                      style: wayaTheme.textTheme.hintStyle,
                    )
                  ],
                )
              ],
            ),
          ),
          const Gap(25),
          Text(
            "Product Reviews",
            style: wayaTheme.textTheme.titleMedium,
          ),
          const Gap(20),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ProductReviewWidget(review: reviews[index]);
              }),
          const Gap(25),
          Text(
            "Similar Products",
            style: wayaTheme.textTheme.titleMedium,
          ),
          const Gap(25),
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              }),
        ],
      ),
      bottomNavigationBar:Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: context.width * 0.45,
                  child: WayaButton(
                    callback: () {},
                    centerWidget: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: wayaTheme.colorScheme.customPrimary,
                          ),
                          const Gap(6),
                          Text('Add To Cart',
                              style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.customPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    color: wayaTheme.colorScheme.transparent,
                    textColor: wayaTheme.colorScheme.customPrimary,
                    border: Border.all(
                        color: wayaTheme.colorScheme.customPrimary, width: 1),
                  ),
                ),
                SizedBox(
                  width: context.width * 0.45,
                  child: WayaButton(
                    callback: () {
                      viewModel.testRequest(context);
                    },
                    text: 'Buy Now',
                  ),
                )
              ],
            ),
          )
    );
  }
}
