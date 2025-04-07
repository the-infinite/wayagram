import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/shared/engagement/provider/product_engagement_monitor.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/vm/product_detail_vm.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/features/shop/widgets/product_description_widget.dart';
import 'package:wayagram/features/shop/widgets/product_image_widget.dart';
import 'package:wayagram/features/shop/widgets/product_review_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class ProductDetail extends ConsumerStatefulWidget {
  static const route = '/product-detail';
  final String id;
  const ProductDetail({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final product = await ref
          .read(productDetailVmProvider.notifier)
          .getCurrentProduct(id: widget.id);

      final provider = ref.read(productEngagementProvider.notifier);

      provider.startViewingProduct();

      if (product != null) {
        provider.addCategory(product.categoryId, ProductPoint.viewPoints.value);

        ref
            .read(shopVmProvider.notifier)
            .getProductReviews(productId: product.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(productDetailVmProvider);
    final shopState = ref.watch(shopVmProvider);
    final addState = ref.watch(addProductProvider('add-product'));
    final wayaTheme = Theme.of(context);

    if (viewModel.product == null && viewModel.isLoading) {
      return Container(
        height: context.height,
        width: context.width,
        decoration: BoxDecoration(color: wayaTheme.colorScheme.white),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                    viewModel.product!.name.capitalizeFirst!,
                    style: wayaTheme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      isLiked = true;
                    });
                    ref.read(productDetailVmProvider.notifier).likeProduct();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.secondaryColor2,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(7),
                    child: SvgPicture.asset(
                      isLiked
                          ? WayaAssets.icons.mSmallHeart.path
                          : WayaAssets.icons.heart.path,
                      fit: BoxFit.none,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Share.share(
                        subject: "Share Product",
                        WayaValueHelper.getShareableUrl(
                            WayaAppRoutes.getProductDetailScreen(widget.id)));
                  },
                  splashFactory: NoSplash.splashFactory,
                  child: Container(
                      decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.secondaryColor2,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(7),
                      child: SvgPicture.asset(
                          WayaAssets.icons.shareNetwork.path,
                          fit: BoxFit.none)),
                )
              ],
            ),
            const Gap(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: viewModel.product?.wayagramDeal != null,
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
                              fontSize: 12.sp)),
                    ),
                  ),
                ),
                const Gap(8),
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
            const Gap(10),
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
                            image: viewModel.product?.shopLogo ??
                                WayaConstants.shopLogo,
                          ),
                          const Gap(6),
                          Text(
                            viewModel.product!.shopName.capitalizeFirst!,
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
                      RatingStars(rating: viewModel.product?.shopRating ?? 0),
                      const Gap(2),
                      Text(
                        "${viewModel.product?.shopRating ?? 0}",
                        style: wayaTheme.textTheme.hintStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
            const Gap(25),
            Visibility(
                visible: shopState.reviews.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product Reviews",
                      style: wayaTheme.textTheme.titleMedium,
                    ),
                    const Gap(20),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shopState.reviews.length,
                        itemBuilder: (context, index) {
                          return ProductReviewWidget(
                              review: shopState.reviews[index]);
                        }),
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
          padding: EdgeInsets.fromLTRB(15, 6, 15, 25),
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
                        callback: !addState.isDeleting
                            ? () {
                                ref
                                    .read(productDetailVmProvider.notifier)
                                    .initiateDelete(
                                        context, viewModel.product!);
                              }
                            : null,
                        centerWidget: LoadingState(
                            loading: addState.isDeleting,
                            text: 'Delete Product'),
                        color: wayaTheme.colorScheme.error,
                      ),
                    )
                  ],
                )
              : SizedBox(
                  //alignment: Alignment.bottomCenter,
                  width: context.width * 0.95,
                  child: WayaButton(
                    callback: () {
                      final product = viewModel.product!;
                      final String image =
                          product.images.isEmpty ? "" : product.images[0];
                      int intPrice = double.parse(product.price).toInt();
                      int price = product.discountPercentage > 0
                          ? (intPrice -
                                  (intPrice * product.discountPercentage / 100))
                              .toInt()
                          : intPrice;
                      ref.read(cartVmProvider.notifier).addToCart(
                          count: 1,
                          productId: product.id,
                          productImage: image,
                          productName: product.name,
                          price: price,
                          shopId: product.shopId);

                      WayaSnackBar.showToast("Item added to cart");
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
                                  color: wayaTheme.colorScheme.customPrimary,
                                  fontSize: 15.sp,
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
        ));
  }
}
