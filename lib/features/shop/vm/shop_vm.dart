import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';

import '../services/product_service.dart';

final List<Product> products = [
  Product(
      id: "1",
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374175/product1_owvv1d.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
      ],
      quantity: 3,
      price: 20000,
      discountPrice: 19000,
      seller: "Maleek"),
  Product(
      id: "2",
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374172/product2_na4de1.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
      ],
      quantity: 3,
      price: 20000,
      discountPrice: 19000,
      seller: "Emeka"),
  Product(
      id: "3",
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374172/product2_na4de1.png',
      ],
      price: 20000,
      discountPrice: 19000,
      quantity: 3,
      seller: "Maleek"),
  Product(
      id: "4",
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
      ],
      price: 20000,
      discountPrice: 19000,
      quantity: 3,
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

// provider notifier
final productsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductsNotifier(productService);
});

class ShopVm extends StateNotifier<ShopState> {
  final ShopRepository _repository;
  final Ref ref;
  ShopVm(this._repository, this.ref) : super(ShopState());

  Future<List<Select>?> allCategories() async {
    try {
      final response = await _repository.getAllCategories();

      List<Select> selectCategories = [];
      if (response.success) {
        CategoryResponseModel responseModel =
            CategoryResponseModel.fromJson(response.data);

        final List<CategoryData?> categories = responseModel.data;
        selectCategories = categories.map((val) {
          return Select(label: val!.name, value: val.id);
        }).toList();

        state = state.copyWith(categories: selectCategories);
        if (selectCategories.isNotEmpty) {
          state = state.copyWith(selectedCategoryId: selectCategories[0].value);
        }
      }
      return selectCategories;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> getAllProducts() async {
    try {
      final response =
          await _repository.getProducts(categoryId: state.selectedCategoryId!);

      if (response.success) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }
}

final shopVmProvider = StateNotifierProvider<ShopVm, ShopState>((ref) {
  return ShopVm(ShopRepository(), ref);
});
