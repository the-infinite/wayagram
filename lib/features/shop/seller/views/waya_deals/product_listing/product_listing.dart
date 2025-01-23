import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/add_product_images.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/preview_product.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/product_listing/steps/add_product_for_listing.dart';

class ProductListing extends ConsumerStatefulWidget {
  static const route = '/waya_product_listing';
  const ProductListing({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductListingState();
}

class _ProductListingState extends ConsumerState<ProductListing> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _goToPreviousTab() {
    if (_tabController.index > 1) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void _goBack(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return WayaScaffoldWithProgressBar(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
        tabsView: [
          AddProductForListing(gotoNextTab: _goToNextTab),
          AddProductImages(
            gotoNextTab: _goToNextTab,
            gotoPreviousTab: _goToPreviousTab,
          ),
          PreviewProduct(
            goBack: _goBack,
            gotoPreviousTab: _goToPreviousTab,
            isWayagramDeal: true,
          )
        ],
        tabController: _tabController);
  }
}
