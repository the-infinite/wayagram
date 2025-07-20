import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';

class TopSellingList extends ConsumerStatefulWidget {
  static const route = "/top-selling";
  const TopSellingList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopSellingState();
}

class _TopSellingState extends ConsumerState<TopSellingList> {
  late TextEditingController searchController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      await ref.read(shopVmProvider.notifier).topSelling();
      setState(() {
        isLoading = false;
      });
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {}); // Rebuild when search text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopVmProvider);

    final searchFilteredTopSellingProducts = WayaUtils.search<Product>(
        state.topSelling,
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

    return WayaScaffold(
      isScrollable: true,
      title: "Top Selling",
      body: Column(
        children: [
          FilterWidget(
            isPopFilter: false,
            hintText: 'Search Product',
            search: searchController,
          ),
          Gap(15.h),
          isLoading
              ? _recommendedProductLoadingState(context: context)
              : ProductsGrid(products: searchFilteredTopSellingProducts),
          SizedBox(height: 100.h),
        ],
      ),
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
