import 'package:flutter/material.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
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
  final int numberOfRequests;
  final int numberOfPendingOrders;
  final int numberOfOrders;
  final bool isLoadingOrder;
  final List<Order> orders;

  const ManageShopState(
      {this.isLoading = false,
      this.data,
      this.hasShop = false,
      this.shop = const [],
      this.orders = const [],
      this.numberOfOrders = 0,
      this.numberOfPendingOrders = 0,
      this.isPersonalNotUpgradedToBusiness = false,
      this.salesMetric = const [],
      this.numberOfProducts = 0,
      this.numberOfRequests = 0,
      this.isLoadingOrder = false,
      this.singleShop});

  factory ManageShopState.initial() => ManageShopState();

  ManageShopState copyWith(
      {bool? isLoading,
      dynamic data,
      bool? hasShop,
      List<ShopData>? shop,
      List<SalesMetric>? salesMetric,
      ShopData? singleShop,
      int? numberOfRequests,
      int? numberOfPendingOrders,
      List<Order>? orders,
      int? numberOfProducts,
      bool? isLoadingOrder,
      int? numberOfOrders,
      bool? isPersonalNotUpgradedToBusiness}) {
    return ManageShopState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        hasShop: hasShop ?? this.hasShop,
        singleShop: singleShop ?? this.singleShop,
        shop: shop ?? this.shop,
        numberOfProducts: numberOfProducts ?? this.numberOfProducts,
        numberOfRequests: numberOfRequests ?? this.numberOfRequests,
        salesMetric: salesMetric ?? this.salesMetric,
        numberOfPendingOrders:
            numberOfPendingOrders ?? this.numberOfPendingOrders,
        isLoadingOrder: isLoadingOrder ?? this.isLoadingOrder,
        orders: orders ?? this.orders,
        numberOfOrders :numberOfOrders?? this.numberOfOrders,
        isPersonalNotUpgradedToBusiness: isPersonalNotUpgradedToBusiness ??
            this.isPersonalNotUpgradedToBusiness);
  }

  factory ManageShopState.fromJson(Map<String, dynamic> json) {
    return ManageShopState(
        isLoading: json["isLoading"],
        data: json["data"],
        isLoadingOrder: json['isLoadingOrder'],
        hasShop: json["hasShop"],
        numberOfPendingOrders: json['numberOfPendingOrders'],
        orders: json['orders'],
        singleShop: json['singleShop'],
        isPersonalNotUpgradedToBusiness:
            json['isPersonalNotUpgradedToBusiness'],
        salesMetric: json['salesMetric'],
        numberOfRequests: json['numberOfRequests'],
        numberOfProducts: json['numberOfProducts'],
        numberOfOrders: json['numberOfOrders'],
        shop: json['shop']);
  }

  Map<String, dynamic> toJson() => {
        "isLoading": isLoading,
        "data": data,
        'salesMetric': salesMetric,
        'isLoadingOrder': isLoadingOrder,
        "hasShop": hasShop,
        'numberOfProducts': numberOfProducts,
        'numberOfRequests': numberOfRequests,
        'numberOfPendingOrders': numberOfPendingOrders,
        'orders': orders,
        'numberOfOrders':numberOfOrders,
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
