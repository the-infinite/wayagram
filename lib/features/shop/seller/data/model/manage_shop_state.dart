import 'package:flutter/material.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';

class ManageShopState {
  final bool isLoading;
  final dynamic data;
  final bool hasShop;
  final List<ShopData> shop;
  final ShopData? singleShop;
  final bool isPersonalNotUpgradedToBusiness;
  final List<SalesMetric> salesMetric;
  final int numberOfProducts;

  const ManageShopState(
      {this.isLoading = false,
      this.data,
      this.hasShop = false,
      this.shop = const [],
      this.isPersonalNotUpgradedToBusiness = false,
      this.salesMetric = const [],
      this.numberOfProducts = 0,
      this.singleShop});

  factory ManageShopState.initial() => ManageShopState();

  ManageShopState copyWith(
      {bool? isLoading,
      dynamic data,
      bool? hasShop,
      List<ShopData>? shop,
      List<SalesMetric>? salesMetric,
      ShopData? singleShop,
      int? numberOfProducts,
      bool? isPersonalNotUpgradedToBusiness}) {
    return ManageShopState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        hasShop: hasShop ?? this.hasShop,
        singleShop: singleShop ?? this.singleShop,
        shop: shop ?? this.shop,
        numberOfProducts: numberOfProducts ?? this.numberOfProducts,
        salesMetric: salesMetric ?? this.salesMetric,
        isPersonalNotUpgradedToBusiness: isPersonalNotUpgradedToBusiness ??
            this.isPersonalNotUpgradedToBusiness);
  }

  factory ManageShopState.fromJson(Map<String, dynamic> json) {
    return ManageShopState(
        isLoading: json["isLoading"],
        data: json["data"],
        hasShop: json["hasShop"],
        singleShop: json['singleShop'],
        isPersonalNotUpgradedToBusiness:
            json['isPersonalNotUpgradedToBusiness'],
        salesMetric: json['salesMetric'],
        numberOfProducts: json['numberOfProducts'],
        shop: json['shop']);
  }

  Map<String, dynamic> toJson() => {
        "isLoading": isLoading,
        "data": data,
        'salesMetric': salesMetric,
        "hasShop": hasShop,
        'numberOfProducts': numberOfProducts,
        "shop": shop,
        "singleShop": singleShop,
        "isPersonalNotUpgradedToBusiness": isPersonalNotUpgradedToBusiness
      };
}

class SalesMetric {
  final String title;
  final String metrics;
  final Color? color;

  SalesMetric({this.title = '', this.metrics = '', this.color});

  SalesMetric copyWith({String? title, String? metrics, Color? color}) {
    return SalesMetric(
        title: title ?? this.title,
        metrics: metrics ?? this.metrics,
        color: color ?? this.color);
  }
}
