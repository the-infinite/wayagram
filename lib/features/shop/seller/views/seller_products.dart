import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/seller/views/add_product/add_product.dart';
import 'package:wayagram/features/shop/seller/vm/seller_products_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';

class SellerProducts extends ConsumerStatefulWidget {
  static const route = '/seller-product';
  const SellerProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SellerProductsState();
}

class _SellerProductsState extends ConsumerState<SellerProducts> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final String shopId =
          ModalRoute.of(context)!.settings.arguments as String;
      ref
          .read(sellerProductsVmProvider.notifier)
          .sellerProducts(shopId: shopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(sellerProductsVmProvider);
    return WayaScaffold(
        isLoading: state.isLoading,
        isScrollable: true,
        title: 'My Products',
        onRefresh: () async {
          final String shopId =
              ModalRoute.of(context)!.settings.arguments as String;
          ref
              .read(sellerProductsVmProvider.notifier)
              .sellerProducts(shopId: shopId);
        },
        body: state.products.isEmpty
            ? SellerProductEmptyState()
            : Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaButton(
                        callback: () {
                          WayaNav.toNamed(AddProduct.route,
                              arguments:
                                  AddProductArg(uniqueKey: Uuid().v4()));
                        },
                        color: wayaTheme.colorScheme.primar50,
                        centerWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              WayaAssets.icons.buttonIcon.path,
                              colorFilter: ColorFilter.mode(
                                  wayaTheme.colorScheme.customPrimary,
                                  BlendMode.srcIn),
                            ),
                            const Gap(6),
                            Text(
                              "Add New Product",
                              style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.customPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      const Gap(10),
                      FilterWidget(
                        search: state.search,
                      ),
                      const Gap(10),
                      
                    GroupedWidgetHeader(
                          isVisible: true,
                          onTap: () {},
                          subTitle:
                              "Extensive view of all the products you have created",
                          title: "My Products"),
                           const Gap(10),
                      CategoriesFilterWidget(
                        setCategory: (value) => {
                          ref
                              .read(sellerProductsVmProvider.notifier)
                              .setCategory(value)
                        },
                      ),
                      const Gap(25),
                      _buildProductGrid(ref
                          .watch(sellerProductsVmProvider.notifier)
                          .filteredProducts)
                    ],
                  )
                ],
              ));
  }

  Widget _buildProductGrid(List<SellerProduct> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 3 / 5,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return SellerProductCard(
          product: products[index],
          isExplore: false,
          isWayaGramDeal: false,
          canbeAddedTocart: false,
          sellerProduct: true,
        );
      },
    );
  }

  Widget _productLoadingState({required BuildContext context}) {
    return Column(
      children: [
        for (int i = 0; i < 6; i += 2)
          Row(
            children: [
              Expanded(
                child: ProductCardSekeleton(
                  isExplore: false,
                  isWayaGramDeal: false,
                  canbeAddedTocart: false,
                  sellerProduct: true,
                ),
              ),
              if (i + 1 < 6) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCardSekeleton(
                    isExplore: false,
                    isWayaGramDeal: false,
                    canbeAddedTocart: false,
                    sellerProduct: true,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

class SellerProductEmptyState extends StatelessWidget {
  const SellerProductEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(40),
        SvgPicture.asset('assets/icons/empty-state.svg'),
        const Gap(30),
        Text(
          "No Product Added",
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.titleLarge,
        ),
        const Gap(25),
        Text(
          "Your shop is empty. Start adding products to \n showcase your items.",
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.descriptionStyle,
        ),
        const Gap(25),
        WayaButton(
          callback: () {
            WayaNav.toNamed(AddProduct.route,
                arguments: AddProductArg(uniqueKey: Uuid().v4()));
          },
          centerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/button-icon.svg'),
              const Gap(6),
              Text(
                "Add New Product",
                style: TextStyle().wayaCopyWith(
                    color: wayaTheme.colorScheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        )
      ],
    );
  }
}

class SellerShopEmptyState extends StatelessWidget {
  const SellerShopEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(40),
        SvgPicture.asset('assets/icons/empty-state.svg'),
        // const Gap(30),
        Text(
          "No Shop Created",
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.titleLarge,
        ),
        const Gap(25),
        Text(
          "Start by creating a shop.",
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.descriptionStyle,
        ),
        const Gap(25),
        SizedBox(
          width: 250,
          child: WayaButton(
            callback: () {
              WayaNav.toNamed('/create-shop');
            },
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/button-icon.svg'),
                const Gap(6),
                Text(
                  "Create Shop",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
