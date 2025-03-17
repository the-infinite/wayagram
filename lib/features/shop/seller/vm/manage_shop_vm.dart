import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/delivery_request_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/vm/create_shop_vm.dart';
import 'package:wayagram/features/shop/seller/vm/delivery_request_vm.dart';
import 'package:wayagram/features/shop/seller/vm/seller_products_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

List<SalesMetric> salesMetrics = [
  SalesMetric(title: "Total Sales", metrics: "0", color: Color(0xffE3EFFC)),
  SalesMetric(title: "Total Products", metrics: "0", color: Color(0xffE7F6EC)),
  SalesMetric(title: "Pending Orders", metrics: "0", color: Color(0xffFEF6E7))
];

class ManageShopVm extends StateNotifier<ManageShopState> {
  final ShopRepository _shopRepository;
  final ProfileRepo _profileRepo;

  final Ref ref;

  final _logger = getLogger('ManageShopVm');

  ManageShopVm(this._profileRepo, this._shopRepository, this.ref)
      : super(ManageShopState.initial());

  Future<void> getSellerShops() async {
    try {
      state = state.copyWith(isLoading: true);

      final businessProfile = await _profileRepo.getBusinessDataRepo(
          userId: ConversationState.self.id);

      if (businessProfile.success) {
        print("dsffsefffdsvdvfvdfvdfvdfv");
        print(businessProfile.data);
        state = state.copyWith(isPersonalNotUpgradedToBusiness: false);
      } else {
        state = state.copyWith(isPersonalNotUpgradedToBusiness: true);
        state = state.copyWith(isLoading: false);
        return;
      }

      final response =
          await _shopRepository.getShopBySellerId(ConversationState.self.id);

      if (response.success) {
        ShopResponseModel responseModel =
            ShopResponseModel.fromJson(response.data);

        state = state.copyWith(hasShop: responseModel.data.shops.isNotEmpty);
        // state = state.copyWith(shop: responseModel.data);

        if (responseModel.data.shops.isEmpty) {
          await ref
              .read(createShopVmProvider.notifier)
              .createSellerShop(hasNoShop: true);
          return;
        } else {
          state = state.copyWith(shop: responseModel.data.shops);
        }
      }
    } catch (e) {
      _logger.e(" $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshShops() async {
    await getSellerShops();
  }

  void getCurrentShop(ShopData? shop) {
    state = state.copyWith(singleShop: shop);
  }

  void fetchData() async {
    state = state.copyWith(isLoadingOrder: true);

    final List<SellerProduct>? products = await ref
        .read(sellerProductsVmProvider.notifier)
        .sellerProducts(shopId: state.singleShop!.id);
    await ref
        .read(shopVmProvider.notifier)
        .getShopMetrics(shopId: state.singleShop!.id);
    final List<DeliveryRequestData>? requests =
        await ref.read(deliveryRequestVmProvider.notifier).getRequests();

    state = state.copyWith(isLoadingOrder: false);
    updateMetrics(products: products, requests: requests);
  }

  void updateMetrics(
      {required List<SellerProduct>? products,
      required List<DeliveryRequestData>? requests}) {
    if (requests != null) {
      state = state.copyWith(numberOfRequests: requests.length);
    }
  }

  // main endpoint to get seller paginated poduct --others will later be removed

  Future<PaginatedResult<SellerProduct>?> approvedWayaDeals(
      {required int page}) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _shopRepository.getSellerProducts(
          shopId: state.singleShop!.id, page: page);
      List<SellerProduct> sellerProducts = [];
      bool hasNextPage = false;
      if (response.success) {
        SellerProductResponseModel responseModel =
            SellerProductResponseModel.fromJson(response.data);
        sellerProducts = responseModel.data.products
            .where((c) => c.wayagramDealApprove == true)
            .toList();
        hasNextPage = responseModel.data.pagination.hasNextPage;
      }
      return PaginatedResult(hasNextPage: hasNextPage, items: sellerProducts);
    } catch (e) {
      print(e);
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<PaginatedResult<SellerProduct>?> appliedWayaDeals(
      {required int page}) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _shopRepository.getSellerProducts(
          shopId: state.singleShop!.id, page: page);
      List<SellerProduct> sellerProducts = [];
      bool hasNextPage = false;
      if (response.success) {
        SellerProductResponseModel responseModel =
            SellerProductResponseModel.fromJson(response.data);
        sellerProducts = responseModel.data.products
            .where((c) => c.wayagramDeal != null)
            .toList();
        hasNextPage = responseModel.data.pagination.hasNextPage;
      }
      return PaginatedResult(hasNextPage: hasNextPage, items: sellerProducts);
    } catch (e) {
      print(e);
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final manageShopVmProvider =
    StateNotifierProvider.autoDispose<ManageShopVm, ManageShopState>((ref) {
  return ManageShopVm(ProfileRepo(), ShopRepository.instance, ref);
});
