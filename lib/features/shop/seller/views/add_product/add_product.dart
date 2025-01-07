import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/add_product_images.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/basic_product_info.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/preview_product.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/pricing_and_delivery.dart';

class AddProduct extends ConsumerStatefulWidget {
  static const route = '/add-product';
  const AddProduct({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    // TODO: implement build
    return WayaScaffoldWithProgressbar(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
        tabsView: [
          BasicProductInfo(gotoNextTab: _goToNextTab),
          PricingAndDelivery(
            gotoNextTab: _goToNextTab,
            gotoPreviousTab: _goToPreviousTab,
          ),
          AddProductImages(
            gotoNextTab: _goToNextTab,
            gotoPreviousTab: _goToPreviousTab,
          ),
          PreviewProduct(
            goBack: _goBack,
            gotoPreviousTab: _goToPreviousTab,
          )
        ],
        tabController: _tabController);
  }
}
