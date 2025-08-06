import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/shared/features/profile/repo/products_repository.dart';
import 'package:wayagram/shared/features/profile/state/product.dart';

class UserProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository repo;
  UserProductsNotifier(this.repo) : super(ProductsState.initial);

  Future<List<Product>> getProductsByShop(String id) async {
    final result = <Product>[];

    try {
      // This is fine too.
      final response = await repo.getShopProducts(
          id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => Product.fromJson(doc));

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? This is fine.
        state = state.copyWith(
          docs: result,
          totalSize: data['totalDocs'],
          totalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
          hasNextPage: data['hasNextPage'],
          page: int.tryParse(data['page'].toString()) ?? 1,
          nextPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          hasLoaded: true,
        );
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.shops,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  Future<List<Product>> getProductsByUser(String id) async {
    final result = <Product>[];

    try {
      // This is fine too.
      final response = await repo.getShopProducts(
          id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];
        final pagination = data["pagination"];

        //? Parse the posts as they are in the response object...
        final docs = (data['data'] as List).map((doc) => Product.fromJson(doc));

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? This is fine.
        state = state.copyWith(
          docs: result,
          totalSize: pagination['totalItems'],
          totalPages: int.tryParse(pagination['totalPages'].toString()) ?? 1,
          hasNextPage: pagination['hasNextPage'],
          page: int.tryParse(pagination['currentPage'].toString()) ?? 1,
          nextPage: (int.tryParse(pagination['currentPage'].toString()) ?? 1) +
              (pagination['hasNextPage'] == true ? 1 : 0),
          hasLoaded: true,
        );
      }

      //? After getting these posts...
    } catch (e) {
      state = state.copyWith(
        hasLoaded: true,
      );
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.shops,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  void reset() {
    state = ProductsState.initial;
  }
}

final userProductsProvider =
    StateNotifierProvider.family<UserProductsNotifier, ProductsState, String>(
        (ref, userId) {
  final repo = ref.watch(productsRepositoryProvider);
  return UserProductsNotifier(repo);
});
