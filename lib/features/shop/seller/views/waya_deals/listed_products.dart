import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

class ListedProducts extends ConsumerWidget {
  const ListedProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WayaButton(
              callback: () {
                WayaNav.toNamed('/waya_product_listing');
              },
              color: wayaTheme.colorScheme.primar50,
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/button-icon.svg',
                    colorFilter: ColorFilter.mode(
                        wayaTheme.colorScheme.customPrimary, BlendMode.srcIn),
                  ),
                  const Gap(6),
                  Text(
                    "List New Product",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            const Gap(25),
            FilterWidget(
              search: TextEditingController(),
            ),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {},
                subTitle: "Extensive view of all the products you have created",
                title: "Your Listed Wayagram Deals"),
            const Gap(10),
            CategoriesFilterWidget(setCategory: (value) => {}),
            const Gap(25),
            // productState.when(
            //     data: (products) => GridView.builder(
            //         physics: const NeverScrollableScrollPhysics(),
            //         shrinkWrap: true,
            //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 2,
            //             mainAxisSpacing: 0,
            //             childAspectRatio: 0.52,
            //             crossAxisSpacing: 12),
            //         itemCount: products.length,
            //         itemBuilder: (context, index) {
            //           return ProductCard(
            //             product: products[index],
            //             isExplore: false,
            //             isWayaGramDeal: false,
            //             canbeAddedTocart: false,
            //             sellerProduct: true,
            //           );
            //         }),
            //     error: (e, stack) => _productLoadingState(context: context),
            //     loading: () => _productLoadingState(context: context))
          ],
        )

        // SellerProductEmptyState()
      ],
    );
  }

  Widget _productLoadingState({required BuildContext context}) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            childAspectRatio: 0.52,
            crossAxisSpacing: 12),
        itemCount: 6,
        itemBuilder: (context, index) {
          return ProductCardSekeleton(
              isExplore: false,
              isWayaGramDeal: false,
              canbeAddedTocart: false,
              sellerProduct: true);
        });
  }
}

class SellerProductEmptyState extends StatelessWidget {
  const SellerProductEmptyState({super.key});

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
          callback: () {},
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
