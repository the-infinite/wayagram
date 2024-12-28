

import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/product_service.dart';
final List<Product> products = [
  Product(
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374175/product1_owvv1d.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
      ],
      price: 'N 200,032',
      discountPrice: 'N 20,000',
      seller: "Maleek"),
  Product(
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374172/product2_na4de1.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
      ],
      price: 'N 200,032',
      discountPrice: 'N 20,000',
      seller: "Emeka"),
  Product(
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374172/product2_na4de1.png',
      ],
      price: 'N 200,032',
      discountPrice: 'N 20,000',
      seller: "Emeka"),
  Product(
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
      ],
      price: 'N 200,032',
      discountPrice: 'N 20,000',
      seller: "Emeka"),
];


//provider for service
final productServiceProvider = Provider((ref) => ProductService());


class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _productService;

  ProductsNotifier(this._productService) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      state = const AsyncValue.loading();
      final products = await _productService.fetchProducts();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
    Future<void> refresh() async {
    await loadProducts();
  }
}

// povider notifier
final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductsNotifier(productService);
});