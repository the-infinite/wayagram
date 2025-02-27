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
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/seller/views/add_product/add_product.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

class ListedProducts extends ConsumerStatefulWidget {
  const ListedProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListedProductState();
}

class _ListedProductState extends ConsumerState<ListedProducts> {
  late TextEditingController searchController;
  List<String> categories = [];
  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {}); // Rebuild when search text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Expanded(
        child: PaginatedDataView<SellerProduct>(
            uniqueKey: 'listed-products',
            emptyState: SellerProductEmptyState(),
            trailingWidget: _buildTrailing(context: context),
            fetchData:
                ref.read(manageShopVmProvider.notifier).approvedWayaDeals,
            result: (data, s) {
              return SellerProductGrid(products: data);
            }));
  }

  Widget _buildTrailing({required BuildContext context}) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WayaButton(
          callback: () {
            WayaNav.toNamed(AddProduct.route,
                arguments: AddWayagramArg(
                    uniqueKey: 'add-waya-product', isWayagram: true));
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
          search: searchController,
        ),
        const Gap(25),
        GroupedWidgetHeader(
            // onTap: () {},
            subTitle: "Extensive view of all the products you have created",
            title: "Your Listed Wayagram Deals"),
        const Gap(10),
        CategoriesFilterWidget(
            setCategory: (value) => {
                  setState(() {
                    categories = value;
                  })
                }),
        const Gap(25),
      ],
    );
  }
}

class SellerProductEmptyState extends StatelessWidget {
  const SellerProductEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
          " Start adding products to showcase your items.",
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.descriptionStyle,
        ),
        const Gap(25),
        WayaButton(
          callback: () {
            WayaNav.toNamed(AddProduct.route,
                arguments: AddWayagramArg(
                    uniqueKey: 'add-waya-product', isWayagram: true));
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
