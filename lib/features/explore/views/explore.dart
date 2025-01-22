import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/features/explore/widgets/explore_header.dart';
import 'package:wayagram/features/explore/widgets/explore_our_services.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/quotation/widgets/quotation_card.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_card.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(shopVmProvider.notifier).allCategories(1);
      ref.read(shopVmProvider.notifier).getAllProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(exploreVmProvider.notifier);
    final state = ref.watch(shopVmProvider);
    final notifier = ref.read(shopVmProvider.notifier);

    return WayaScaffold(
        isLoading: false,
        backgroundColor: wayaTheme.colorScheme.scaffoldColor,
        appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: wayaTheme.colorScheme.white,
            title: ExploreHeader(),
            actions: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        WayaNav.toNamed('/notifications');
                      },
                    ),
                    const Gap(15),
                    WayaDp(
                      onTap: () {
                        WayaNav.toNamed('/general-settings');
                      },
                      radius: 18,
                    ),
                  ],
                ),
              )
            ],
            leading: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Image.asset(
                'assets/images/wayalogo_unlabelled.png',
              ),
            )),
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const ExploreHeader(),
            const Gap(20),
            ExploreOurServices(),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {}, subTitle: 'Have a buy request, just create a quote', title: 'Get Quotation'),
            const Gap(20),
            WayaButton(
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 28,
                    color: wayaTheme.colorScheme.primary600,
                  ),
                  const Gap(8),
                  Text(
                    "Create a Quote",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              callback: () {},
              color: wayaTheme.colorScheme.primar50,
            ),
            const Gap(25),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.quotations.length,
                itemBuilder: (context, index) {
                  return QuotationCard(quotation: viewModel.quotations[index]);
                }),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {
                  WayaNav.toNamed(BottomView.route, arguments: 1);
                },
                subTitle: 'Explore Categories & Best Offers',
                title: 'Shop'),
            const Gap(10),
            CategoriesFilterWidget(
              setCategory: (value) => ref.read(shopVmProvider.notifier).setCategory(value),
            ),
            const Gap(10),
            // WayaButton(
            //   callback: () {
            //     //    WayaNav.toNamed(AddProduct.route);
            //   },
            //   color: wayaTheme.colorScheme.primar50,
            //   centerWidget: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       SvgPicture.asset(
            //         WayaAssets.icons.buttonIcon.path,
            //         colorFilter: ColorFilter.mode(
            //             wayaTheme.colorScheme.customPrimary, BlendMode.srcIn),
            //       ),
            //       const Gap(6),
            //       Text(
            //         "Add New Product",
            //         style: TextStyle().wayaCopyWith(
            //             color: wayaTheme.colorScheme.customPrimary,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w500),
            //       )
            //     ],
            //   ),
            // ),
            const Gap(25),
            state.isLoading
                ? _buildProductLoadingState(context: context)
                : _buildProductGrid(notifier.filteredProducts),
            const Gap(25),
            GroupedWidgetHeader(onTap: () {}, subTitle: 'Join Upcoming Activities', title: 'University Got Talent'),
            const Gap(25),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.ugtList.length,
                itemBuilder: (context, index) {
                  return UgtCard(ugt: viewModel.ugtList[index]);
                }),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: WayaButton(
            callback: () {},
            height: 50,
            centerWidget: Center(
              child: Icon(
                Icons.add,
                color: wayaTheme.colorScheme.white,
                size: 40,
              ),
            ),
          ),
        ));
  }

  Widget _buildProductGrid(List<Product> products) {
    return Column(
      children: [
        for (int i = 0; i < products.length; i += 2)
          Row(
            children: [
              Expanded(
                child: ProductCard(
                  product: products[i],
                ),
              ),
              if (i + 1 < products.length) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCard(
                    product: products[i + 1],
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildProductLoadingState({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          child: ProductCardSekeleton(),
        ),
        Gap(12),
        Expanded(
          child: ProductCardSekeleton(),
        ),
      ],
    );
  }
}
