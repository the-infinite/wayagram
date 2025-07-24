import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/favorites_response_model.dart';
import 'package:wayagram/features/shop/vm/product_detail_vm.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

class FavoritesProducts extends ConsumerStatefulWidget {
  static const route = "/favorites-products";
  const FavoritesProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavoritesProductState();
}

class _FavoritesProductState extends ConsumerState<FavoritesProducts> {
  late final notifier = ref.read(productDetailVmProvider.notifier);
  late TextEditingController searchController;
  bool isLoading = false;
  List<FavoriteItem> favoriteItems = [];
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => isLoading = true);
      try {
        final favs = await notifier.getFavorites();

        if (favs != null) {
          setState(() {
            favoriteItems = favs;
          });
        }
      } catch (_) {}
      setState(() => isLoading = false);
    });

    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {}); // Rebuild when search text changes
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
     // search filter
    final searchFilteredProducts = WayaUtils.search<FavoriteItem>(
        favoriteItems,
        [
          'id',
          'deliveryAddress',
          'name',
          'options',
          'condition',
          'materialType',
          'description'
        ],
        searchController.text);

    // TODO: implement build
    return WayaScaffold(
        isScrollable: true,
        isLoading: isLoading,
        title: "Favorite Products",
        body: RefreshIndicator(
                onRefresh: () async {},
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilterWidget(
                        isPopFilter: false,
                        hintText: 'Search Product',
                        search: searchController,
                      ),
                      const Gap(5),
                      const Gap(25),
                      if (isLoading)
                        _favoriteProductLoadingState(context: context)
                      else
                        ProductsGrid(products: searchFilteredProducts)
                    ],
                  ),
                )));
  }

  Widget _favoriteProductLoadingState({required BuildContext context}) {
    return Column(
      children: [
        for (int i = 0; i < 4; i += 2)
          Row(
            children: [
              Expanded(
                child: ProductCardSekeleton(
                  isExplore: false,
                  canbeAddedTocart: true,
                ),
              ),
              if (i + 1 < 4) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCardSekeleton(
                    isExplore: false,
                    canbeAddedTocart: true,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

//? the builder
class ProductsGrid extends StatelessWidget {
  final List<FavoriteItem> products;
  final bool isWayaGramDeal;

  const ProductsGrid(
      {super.key, required this.products, this.isWayaGramDeal = false});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    if (products.isEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          "No Favorites Product",
          style: wayaTheme.textTheme.descriptionStyle
              .copyWith(color: wayaTheme.colorScheme.greyColor500),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < products.length; i += 2)
          Row(
            children: [
              Expanded(child: FavoriteProductCard(product: products[i])),
              if (i + 1 < products.length) ...[
                const SizedBox(width: 12),
                Expanded(child: FavoriteProductCard(product: products[i + 1])),
              ] else ...[
                const SizedBox(width: 12),
                Expanded(child: SizedBox()),
              ],
            ],
          ),
      ],
    );
  }
}

//? the card
class FavoriteProductCard extends ConsumerWidget {
  final FavoriteItem product;
  final bool isWayaGramDeal;
  final bool canbeAddedTocart;
  final bool isExplore;
  final bool sellerProduct;
  const FavoriteProductCard({
    super.key,
    required this.product,
    this.canbeAddedTocart = true,
    this.isExplore = false,
    this.sellerProduct = false,
    this.isWayaGramDeal = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final String image = product.images.isEmpty ? "" : product.images[0];
    debugPrint(
        "${product.discountPercentage} ${product.name} ${product.discountPercentage.toString() == "0"}");

    return GestureDetector(
      onTap: () {
        WayaNav.toNamed(WayaAppRoutes.getProductDetailScreen(product.id));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              WayaImage(
                imageUrl: image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(8),
                color: wayaTheme.colorScheme.transparent,
              ),
            ],
          ),
          if (product.discountPercentage == 0)
            SizedBox(
              height: 22,
            ),

          // Visibility(
          //     visible: isExplore,
          //     child: Column(
          //       children: [
          //         SizedBox(height: 3),
          //         Text(product.categoryName,
          //             style: wayaTheme.textTheme.hintStyle),
          //       ],
          //     )),
          SizedBox(height: 3),
          Text(product.name.capitalizeFirst!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: wayaTheme.textTheme.bodyXtraMedium),
          Visibility(
              visible: !isExplore,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: wayaTheme.colorScheme.customPrimary,
                        size: 18,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${product.rating ?? 0}",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 12.sp),
                      )
                    ],
                  )
                ],
              )),
          Visibility(
              visible: product.discountPercentage > 0,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Text(
                    WayaHelpers.formatPrice(
                        double.parse(product.price).toInt()),
                    style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: wayaTheme.colorScheme.greyColor400,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: wayaTheme.colorScheme.greyColor400),
                  ),
                ],
              )),
          SizedBox(height: 3),
          Text(
              product.discountPercentage > 0
                  ? WayaHelpers.calculatedDiscountPrice(
                      product.price, product.discountPercentage)
                  : WayaHelpers.formatPrice(
                      double.parse(product.price).toInt()),
              style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                  color: isExplore
                      ? wayaTheme.colorScheme.customPrimary
                      : wayaTheme.colorScheme.customBlack,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600)),
          Visibility(
              visible: canbeAddedTocart,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  WayaButton(
                    callback: () async {
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
                    height: 38,
                    radius: 6,
                    color: wayaTheme.colorScheme.primary50,
                    centerWidget: Text(
                      'Add To Cart',
                      style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                          color: wayaTheme.colorScheme.customPrimary,
                          fontSize: 14.sp),
                    ),
                    textColor: wayaTheme.colorScheme.customPrimary,
                  )
                ],
              )),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
