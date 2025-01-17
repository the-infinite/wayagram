import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';

class ManageShopState {
  final bool isLoading;
  final dynamic data;
  final bool hasShop;
  final List<ShopData> shop;
  final ShopData? singleShop;
  final bool isPersonalNotUpgradedToBusiness;

  const ManageShopState(
      {this.isLoading = false,
      this.data,
      this.hasShop = false,
      this.shop = const [],
      this.isPersonalNotUpgradedToBusiness = false,
      this.singleShop});

  factory ManageShopState.initial() => ManageShopState();

  ManageShopState copyWith(
      {bool? isLoading,
      dynamic data,
      bool? hasShop,
      List<ShopData>? shop,
      ShopData? singleShop,
      bool? isPersonalNotUpgradedToBusiness
      }) {
    return ManageShopState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        hasShop: hasShop ?? this.hasShop,
        singleShop: singleShop ?? this.singleShop,
        shop: shop ?? this.shop,
        isPersonalNotUpgradedToBusiness: isPersonalNotUpgradedToBusiness ?? this.isPersonalNotUpgradedToBusiness
        );
  }

  factory ManageShopState.fromJson(Map<String, dynamic> json) {
    return ManageShopState(
        isLoading: json["isLoading"],
        data: json["data"],
        hasShop: json["hasShop"],
        singleShop: json['singleShop'],
        isPersonalNotUpgradedToBusiness: json['isPersonalNotUpgradedToBusiness'],
        shop: json['shop']);
  }

  Map<String, dynamic> toJson() => {
        "isLoading": isLoading,
        "data": data,
        "hasShop": hasShop,
        "shop": shop,
        "singleShop": singleShop,
        "isPersonalNotUpgradedToBusiness":isPersonalNotUpgradedToBusiness
      };
}
