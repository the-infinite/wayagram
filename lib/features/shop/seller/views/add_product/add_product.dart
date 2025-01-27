import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/add_product_images.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/basic_product_info.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/preview_product.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/pricing_and_delivery.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';

class AddProduct extends ConsumerStatefulWidget {
  static const route = '/add-product';
  const AddProduct({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String uniqueKey = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeArgs());
  }

  void _initializeArgs() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is UpdateProductArg) {
      uniqueKey = args.uniqueKey;
      ref
          .read(addProductProvider(uniqueKey).notifier)
          .initializeForEdit(args.product);
    } else if (args is AddWayagramArg) {
      uniqueKey = args.uniqueKey;
      ref.read(addProductProvider(uniqueKey).notifier).initializeWayagramDeal();
    } else if (args is AddProductArg) {
      uniqueKey = args.uniqueKey;
    } else {
      throw ArgumentError('Unsupported arguments: $args');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(addProductProvider(uniqueKey)).isLoadingEditingMode;
    print("cscscsc $uniqueKey");
    return WayaScaffoldWithProgressBar(
      isLoading: isLoading,
      isScrollable: true,
      padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
      tabsView: [
        BasicProductInfo(
          gotoNextTab: _goToNextTab,
          uniqueKey: uniqueKey,
        ),
        PricingAndDelivery(
          gotoNextTab: _goToNextTab,
          gotoPreviousTab: _goToPreviousTab,
          uniqueKey: uniqueKey,
        ),
        AddProductImages(
          gotoNextTab: _goToNextTab,
          gotoPreviousTab: _goToPreviousTab,
          uniqueKey: uniqueKey,
        ),
        PreviewProduct(
          goBack: _goBack,
          gotoPreviousTab: _goToPreviousTab,
          uniqueKey: uniqueKey,
        ),
      ],
      tabController: _tabController,
    );
  }

  void _goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _goToPreviousTab() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void _goBack(int index) {
    _tabController.animateTo(index);
  }
}
