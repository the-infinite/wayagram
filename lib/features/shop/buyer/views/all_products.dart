import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/data/model/product_detail_type.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_banner_response.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/views/products_view_page.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class AllProducts extends ConsumerStatefulWidget {
  const AllProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllProductsState();
}

class _AllProductsState extends ConsumerState<AllProducts> {
  late TextEditingController searchController;
  List<BannerDoc>? bannerLists;
  List<String> categories = [];
  int currentPage = 0;
  late Timer timer;

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(shopVmProvider.notifier)
          .getAllWayaDealProducts(page: 1, limit: 20);
      await ref.read(addProductProvider('filter').notifier).getAllDiscounts(1);

      final banners = await ref.read(shopVmProvider.notifier).getShopBanner();
      if (banners != null) {
        setState(() {
          bannerLists = banners;
        });
      }
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {}); // Rebuild when search text changes
    });
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopVmProvider);

    final allProducts = state.products;
    final allWayaDealProducts = state.wayaDealProducts;

    // search filter
    final searchFilteredProducts = WayaUtils.search<Product>(
        allProducts,
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

    final searchFilteredWayaProducts = WayaUtils.search<Product>(
        allWayaDealProducts,
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

    // category filter
    final categoriesFilteredProducts = searchFilteredProducts.where((prod) {
      if (categories.isNotEmpty && !categories.contains(prod.categoryId)) {
        return false;
      }

      return true;
    }).toList();

    final categoriesFilteredWayaProducts =
        searchFilteredWayaProducts.where((prod) {
      if (categories.isNotEmpty && !categories.contains(prod.categoryId)) {
        return false;
      }

      return true;
    }).toList();

    // wayagram deal products
    final wayagramProducts = categoriesFilteredWayaProducts;

    // Non - wayagram products
    final otherProducts = categoriesFilteredProducts.where((prod) {
      return prod.wayagramDeal == null;
    }).toList();

    return Expanded(
        child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(shopVmProvider.notifier)
                  .getAllProducts(page: 1, limit: 20);

              await ref
                  .read(shopVmProvider.notifier)
                  .getAllWayaDealProducts(page: 1, limit: 20);

              final banners =
                  await ref.read(shopVmProvider.notifier).getShopBanner();
              if (banners != null) {
                setState(() {
                  bannerLists = banners;
                });
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterWidget(
                    isPopFilter: true,
                    hintText: 'Search Product',
                    search: searchController,
                    products: allProducts,
                  ),
                  const Gap(5),
                  CategoriesFilterWidget(
                    setCategory: (value) => {
                      setState(() {
                        categories = value;
                      })
                    },
                    uniqueKey: 'all-product',
                  ),
                  const Gap(20),
                  if (bannerLists?.isNotEmpty == true) ...[
                    //? This is for the ads.
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 180.h,
                      child: PageView(
                        controller: pageController,
                        children: [
                          ...List.generate(bannerLists!.length, (index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: WayaImage(
                                    imageUrl: bannerLists?[index].image ?? '',
                                    height: 180.h));
                          }),
                        ],
                      ),
                    ),
                    //? This one is there too.
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.h, left: 20.w, right: 20.w, bottom: 30.h),
                      child: Center(
                        child: SmoothPageIndicator(
                          effect: ExpandingDotsEffect(
                            dotWidth: 16,
                            dotHeight: 6,
                            spacing: 4,
                            dotColor: WayaColors.greyColor200,
                            activeDotColor: WayaColors.primary,
                          ),
                          controller: pageController,
                          count: 3,
                        ),
                      ),
                    ),
                    const Gap(20),
                  ],
                  GroupedWidgetHeader(
                    onTap: () {
                      WayaNav.toNamed(ProductsViewPage.route,
                          arguments: ProductDetailType.wayagramdeal);
                    },
                    subTitle: 'Explore Categories & Best Offers',
                    title: 'Wayagram Deals',
                  ),
                  const Gap(10),
                  state.isLoading
                      ? _wayagramDealProductLoadingState(context: context)
                      : ProductsGrid(products: wayagramProducts),
                  const Gap(25),
                  GroupedWidgetHeader(
                    onTap: () {
                      WayaNav.toNamed(ProductsViewPage.route,
                          arguments: ProductDetailType.recommended);
                    },
                    subTitle: 'Explore Categories & Best Offers',
                    title: 'Recommended Products',
                  ),
                  const Gap(25),
                  state.isLoading
                      ? _recommendedProductLoadingState(context: context)
                      : ProductsGrid(products: otherProducts),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            )));
  }

  Widget _wayagramDealProductLoadingState({required BuildContext context}) {
    return Column(
      children: [
        for (int i = 0; i < 6; i += 2)
          Row(
            children: [
              Expanded(
                child: ProductCardSekeleton(
                  isExplore: false,
                  isWayaGramDeal: true,
                  canbeAddedTocart: true,
                ),
              ),
              if (i + 1 < 6) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCardSekeleton(
                    isExplore: false,
                    isWayaGramDeal: true,
                    canbeAddedTocart: true,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _recommendedProductLoadingState({required BuildContext context}) {
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
