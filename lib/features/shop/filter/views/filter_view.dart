import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/upgrade_to_business/vm/upgrade_to_business_vm.dart';
import 'package:wayagram/features/shop/filter/vm/filter_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/filter/views/product_search_result.dart';
import '../constants/filter_options.dart';
import '../widgets/filter_section.dart';
import '../widgets/price_range_input.dart';
import '../widgets/measurement_range.dart';
import '../widgets/color_filter.dart';

//********* */
// NB: This filter view is for shop use only.
//********* */

class FilterView extends ConsumerStatefulWidget {
  static const route = '/filter';
  const FilterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterViewState();
}

class _FilterViewState extends ConsumerState<FilterView> {
  late final statesNotifier = ref.read(upgradeToBusinessProvider.notifier);
  List<Product> filteredProducts = [];
  List<Product> allProducts = [];
  List<Select> allStates = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final listOfStates = await statesNotifier.fetchStates();

      if (listOfStates != null) {
        setState(() {
          allStates = listOfStates
              .map((d) => Select(label: d.label, value: d.label))
              .toList();
        });
      }

      if (mounted) {
        final products =
            ModalRoute.of(context)!.settings.arguments as List<Product>;
        allProducts = products;
      }
    });
    applyFilter(); // Run filter initially to set the correct state
    super.initState();
  }

  void applyFilter() {
    final filterState = ref.read(filterVmProvider);
    // final allProducts = ref.read(shopVmProvider).products;

    setState(() {
      filteredProducts = allProducts.where((product) {
        return (filterState.selectedCategory.isEmpty ||
                filterState.selectedCategory.contains(product.categoryId)) &&
            (filterState.minPrice.isEmpty ||
                double.tryParse(product.price.toString())! >=
                    double.tryParse(filterState.minPrice)!) &&
            (filterState.maxPrice.isEmpty ||
                double.tryParse(product.price.toString())! <=
                    double.tryParse(filterState.maxPrice)!) &&
            (filterState.deliveryType.isEmpty ||
                filterState.deliveryType.contains(product.options)) &&
            (filterState.discountType.isEmpty ||
                filterState.discountType.contains(product.discountTypeId)) &&
            (filterState.condition.isEmpty ||
                filterState.condition.contains(product.condition)) &&
            (filterState.chosenStates.isEmpty ||
                filterState.chosenStates.contains(product.state)) &&
            ((product.height ?? 0) >= filterState.minHeight &&
                (product.height ?? 0) <= filterState.maxHeight) &&
            ((product.width ?? 0) >= filterState.minWidth &&
                (product.width ?? 0) <= filterState.maxWidth) &&
            ((product.depth ?? 0) >= filterState.minDepth &&
                (product.depth ?? 0) <= filterState.maxDepth) &&
            (filterState.colors.isEmpty ||
                (product.color != null &&
                    filterState.colors.contains(product.color))) &&
            (product.wayagramDeal == null);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterVmProvider);
    final viewModel = ref.read(filterVmProvider.notifier);
    final categories = ref.watch(shopVmProvider).categories;
    final deliveryTypes =
        ref.watch(addProductProvider('filter')).allDiscountTypes;
    final wayaTheme = Theme.of(context);

    return WayaScaffold(
      isScrollable: true,
      isLoading: false,
      title: "Filters",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterSection(
            title: 'Category',
            options: categories!,
            selectedOption: filterState.selectedCategory,
            onOptionSelected: (value) {
              viewModel.updateCategory(value);
              applyFilter(); // Trigger filtering
            },
          ),
          const SizedBox(height: 24),
          PriceRangeInput(
            minPrice: filterState.minPrice,
            maxPrice: filterState.maxPrice,
            onPriceRangeChanged: (min, max) {
              viewModel.updatePriceRange(min, max);
              applyFilter(); // Trigger filtering
            },
          ),
          const SizedBox(height: 24),
          FilterSection(
            title: 'Delivery Type',
            options: FilterOptions.deliveryTypes,
            selectedOption: filterState.deliveryType,
            onOptionSelected: (value) {
              viewModel.updateDeliveryType(value);
              applyFilter(); // Trigger filtering
            },
          ),
          FilterSection(
            title: 'Condition',
            options: FilterOptions.conditions,
            selectedOption: filterState.condition,
            onOptionSelected: (value) {
              viewModel.updateCondition(value);
              applyFilter(); // Trigger filtering
            },
          ),
          const SizedBox(height: 24),
          FilterSection(
            title: 'Discount Type',
            options: deliveryTypes,
            selectedOption: filterState.discountType,
            onOptionSelected: (value) {
              viewModel.updateDiscountType(value);
              applyFilter(); // Trigger filtering
            },
          ),
          const SizedBox(height: 24),
          ColorFilter(
            onChanged: (colors) {
              viewModel.updateColors(colors);
              applyFilter(); // Trigger filtering
            },
            colors: filterState.colors,
          ),
          const SizedBox(height: 24),
          MeasurementRange(
            maxValue: filterState.maxHeight,
            minValue: filterState.minHeight,
            title: 'Height',
            onChanged: (min, max) {
              viewModel.updateHeight(min, max);
              applyFilter(); // Trigger filtering
            },
          ),
          const SizedBox(height: 24),
          MeasurementRange(
            maxValue: filterState.maxWidth,
            minValue: filterState.minWidth,
            title: 'Width',
            onChanged: (min, max) {
              viewModel.updateWidth(min, max);
              applyFilter(); // Trigger filtering
            },
          ),
          const SizedBox(height: 24),
          MeasurementRange(
            maxValue: filterState.maxDepth,
            minValue: filterState.minDepth,
            title: 'Depth',
            onChanged: (min, max) {
              viewModel.updateDepth(min, max);
              applyFilter(); // Trigger filtering
            },
          ),
          const SizedBox(height: 24),
          FilterSection(
            title: 'Location',
            options: allStates,
            selectedOption: filterState.chosenStates,
            onOptionSelected: (value) {
              viewModel.updateStates(value);
              applyFilter(); // Trigger filtering
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: context.width * 0.45,
              child: WayaButton(
                callback: () {
                  viewModel.reset();
                  applyFilter(); // Reset filtering
                },
                text: 'Reset',
                color: wayaTheme.colorScheme.greyColor100,
                textColor: wayaTheme.colorScheme.customBlack,
              ),
            ),
            SizedBox(
              width: context.width * 0.45,
              child: WayaButton(
                callback: filteredProducts.isNotEmpty
                    ? () {
                        WayaNav.toNamed(ProductSearchResult.route,
                            arguments: filteredProducts);
                      }
                    : null, // Disable if no results
                text: 'Show ${filteredProducts.length} results',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
