import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shared/engagement/provider/product_engagement_monitor.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/vm/product_detail_vm.dart';

import 'package:wayagram/features/shop/widgets/product_description_widget.dart';
import 'package:wayagram/features/shop/widgets/product_image_widget.dart';
import 'package:wayagram/features/shop/widgets/product_review_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class ProductDetail extends ConsumerStatefulWidget {
  static const route = '/product-detail';
  const ProductDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Product product =
          ModalRoute.of(context)!.settings.arguments as Product;
      ref
          .read(productDetailVmProvider.notifier)
          .getCurrentProduct(product: product);

      final provider = ref.read(productEngagementProvider.notifier);

      provider.startViewingProduct();

      provider.addCategory(product.categoryId, ProductPoint.viewPoints.value );
    });
  }

// Stop tracking when the page is closed
  @override
  void dispose() {
    ref.read(productEngagementProvider.notifier).stopViewingProduct();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(productDetailVmProvider);
    final wayaTheme = Theme.of(context);

    if (viewModel.product == null) {
      return CircularProgressIndicator();
    }

    return WayaScaffold(
        title: "Product Details",
        isScrollable: true,
        isLoading: viewModel.isLoading,
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
                    viewModel.product!.name.capitalizeFirst!,
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
                    child: SvgPicture.asset(WayaAssets.icons.heart.path,
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
                    child: SvgPicture.asset(WayaAssets.icons.shareNetwork.path,
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
                Visibility(
                  visible: viewModel.product!.wayagramDeal,
                  child: Container(
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
                ),
                const Gap(8),
                // Container(
                //   width: 60,
                //   padding: EdgeInsets.fromLTRB(4, 3, 4, 3),
                //   decoration: BoxDecoration(
                //       color: wayaTheme.colorScheme.primar50,
                //       borderRadius: BorderRadius.circular(6)),
                //   child: Center(
                //     child: Text("12 Left",
                //         style: TextStyle().wayaCopyWith(
                //             color: wayaTheme.colorScheme.customPrimary,
                //             fontWeight: FontWeight.w600,
                //             fontSize: 12)),
                //   ),
                // ),
              ],
            ),
            const Gap(25),
            ProductImageWidget(
                images: viewModel.product == null ||
                        viewModel.product!.images.isEmpty
                    ? ['']
                    : viewModel.product!.images),
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
                  "₦${viewModel.product!.price}",
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
                description: viewModel.product!.description),
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
                          WayaDp(
                            radius: 18,
                          ),
                          const Gap(6),
                          Text(
                            viewModel.product!.shopName,
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
            Visibility(
                visible: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product Reviews",
                      style: wayaTheme.textTheme.titleMedium,
                    ),
                    const Gap(20),
                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: reviews.length,
                    //     itemBuilder: (context, index) {
                    //       return ProductReviewWidget(review: reviews[index]);
                    //     }),
                    const Gap(25),
                  ],
                )),
            // Visibility(
            //     visible: viewModel.similarProduct != null &&
            //         viewModel.similarProduct!.isNotEmpty,
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Similar Products",
            //           style: wayaTheme.textTheme.titleMedium,
            //         ),
            //         const Gap(25),
            //         ProductsGrid(products: viewModel.similarProduct ?? [])
            //       ],
            //     ))
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: viewModel.isProductOwner
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: context.width * 0.45,
                        child: SizedBox(
                          width: context.width * 0.45,
                          child: WayaButton(
                            callback: () {},
                            text: 'Edit Product',
                          ),
                        )),
                    SizedBox(
                      width: context.width * 0.45,
                      child: WayaButton(
                        callback: () {
                          ref
                              .read(productDetailVmProvider.notifier)
                              .initiateDelete(context, viewModel.product!);
                        },
                        text: 'Delete Product',
                        color: wayaTheme.colorScheme.error,
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: context.width * 0.45,
                      child: WayaButton(
                        callback: () {
                          final product = viewModel.product!;
                          final String image =
                              product.images.isEmpty ? "" : product.images[0];
                          int intPrice = double.parse(product.price).toInt();
                          int price = product.discountPercentage > 0
                              ? (intPrice -
                                      (intPrice *
                                          product.discountPercentage /
                                          100))
                                  .toInt()
                              : intPrice;
                          ref.read(cartVmProvider.notifier).addToCart(
                              count: 1,
                              productId: product.id,
                              productImage: image,
                              productName: product.name,
                              price: price,
                              shopId: product.shopId);
                        },
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
                                      color:
                                          wayaTheme.colorScheme.customPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        color: wayaTheme.colorScheme.transparent,
                        textColor: wayaTheme.colorScheme.customPrimary,
                        border: Border.all(
                            color: wayaTheme.colorScheme.customPrimary,
                            width: 1),
                      ),
                    ),
                    SizedBox(
                      width: context.width * 0.45,
                      child: WayaButton(
                        callback: () {},
                        text: 'Buy Now',
                      ),
                    )
                  ],
                ),
        ));
  }
}
