import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/features/shop/filter/vm/filter_vm.dart';
import '../constants/filter_options.dart';

import '../widgets/filter_section.dart';
import '../widgets/price_range_input.dart';

class FilterView extends ConsumerWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterVmProvider);
    final viewModel = ref.read(filterVmProvider.notifier);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isScrollable: true,
      isLoading: false,
      title: "Filters",
      body: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    FilterSection(
          title: 'Category',
          options: FilterOptions.categories,
          selectedOption: filterState.selectedCategory,
          onOptionSelected: viewModel.updateCategory,
        ),
        const SizedBox(height: 24),
        PriceRangeInput(
          minPrice: filterState.minPrice,
          maxPrice: filterState.maxPrice,
          onPriceRangeChanged: viewModel.updatePriceRange,
        ),
        const SizedBox(height: 24),
        FilterSection(
          title: 'Delivery Type',
          options: FilterOptions.deliveryTypes,
          selectedOption: filterState.deliveryType,
          onOptionSelected: viewModel.updateDeliveryType,
        ),
        const SizedBox(height: 24),
        FilterSection(
          title: 'Discount Type',
          options: FilterOptions.discountTypes,
          selectedOption: filterState.discountType,
          onOptionSelected: viewModel.updateDiscountType,
        ),
        const SizedBox(height: 24),
        FilterSection(
          title: 'Height',
          options: FilterOptions.heightOptions,
          selectedOption: filterState.height,
          onOptionSelected: viewModel.updateHeight,
        ),
        const SizedBox(height: 24),
        FilterSection(
          title: 'Depth',
          options: FilterOptions.depthOptions,
          selectedOption: filterState.depth,
          onOptionSelected: viewModel.updateDepth,
        ),
        const SizedBox(height: 24),
        FilterSection(
          title: 'Location',
          options: FilterOptions.locationOptions,
          selectedOption: filterState.location,
          onOptionSelected: viewModel.updateLocation,
        ),
            
            
          ],
        ),
        bottomNavigationBar: Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: context.width * 0.45,
                  child: WayaButton(
                    callback: () {},
                    text: 'Rest',
                    color: wayaTheme.colorScheme.greyColor300,
                    textColor: wayaTheme.colorScheme.customBlack,
                    
                  ),
                ),
                SizedBox(
                  width: context.width * 0.45,
                  child: WayaButton(
                    callback: () {
                     
                    },
                    text: 'Show 3000+ results',
                  ),
                )
              ],
            ),
          ))
      );
  }




}