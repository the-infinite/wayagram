import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductImageState {
  int currentPage;

  ProductImageState({this.currentPage = 0});
}

class ProductImageWidgetVm extends StateNotifier<ProductImageState> {
  final Ref ref;
  ProductImageWidgetVm(this.ref) : super(ProductImageState());

  final _pageController = PageController();

  int get currentPage => state.currentPage;
  PageController get pageController => _pageController;
 
  void changePage(int page) {
    state = ProductImageState(currentPage: page);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


}

final productImageWidgetVmProvider = StateNotifierProvider<ProductImageWidgetVm, ProductImageState>(
    (ref) => ProductImageWidgetVm(ref));
