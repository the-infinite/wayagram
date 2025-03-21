import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/quotation/buyer/model/buyer_request_model.dart';

class CreateRequestState {
  final TextEditingController productName;
  final TextEditingController brandName;
  final TextEditingController productDescription;
  final ValueNotifier<TimeOfDay?> startTime;
  final ValueNotifier<TimeOfDay?> endTime;
  final ValueNotifier<DateTime?> bidDate;
  final TextEditingController deliveryAddress;
  final TextEditingController deliveryPrice;
  final TextEditingController quantity;
  final TextEditingController minDistance;
  final TextEditingController maxDistance;
  final TextEditingController bidStartingAmount;
  final TextEditingController maxBidAmount;
  final double rangeStart;
  final double rangeEnd;

  final bool vendorSeeBuyRequest;
  final bool skipAddress;
  final bool includeDeliveryFee;
  final bool applyDiscount;
  final bool isLoading;
  final bool isFocused;
  final String startDate;
  final String endDate;
  final String dateIsoFormat;
  final String productCategory;
  final String productType;
  final String productCondition;
  final String stateOfPurchase;
  final String lga;
  final String deliveryLga;
  final String deliveryState;
  final String biddingStartTime;
  final String productColor;
  final String pickUpOption;
  final String discountType;
  List<DocType> uploadedDocuments;
  File? productImage;

  List<BuyerRequests> buyerRequest;

  CreateRequestState({
    TextEditingController? productName,
    TextEditingController? brandName,
    TextEditingController? productDescription,
    ValueNotifier<TimeOfDay?>? startTime,
    ValueNotifier<TimeOfDay?>? endTime,
    ValueNotifier<DateTime?>? bidDate,
    TextEditingController? pricePerUnit,
    TextEditingController? deliveryAddress,
    TextEditingController? deliveryPrice,
    this.rangeStart = 0.1,
    this.rangeEnd = 0.7,
    this.productCategory = '',
    this.productColor = '',
    this.productCondition = '',
    this.stateOfPurchase = '',
    this.startDate = '',
    this.endDate = '',
    this.dateIsoFormat = '',
    this.lga = '',
    this.deliveryState = '',
    this.deliveryLga = '',
    this.biddingStartTime = '',
    this.productType = '',
    this.isLoading = false,
    this.isFocused = false,
    TextEditingController? quantity,
    TextEditingController? minDistance,
    TextEditingController? maxDistance,
    TextEditingController? bidStartingAmount,
    TextEditingController? maxBidAmount,
    this.discountType = '',
    this.pickUpOption = 'delivery',
    this.vendorSeeBuyRequest = false,
    this.skipAddress = false,
    this.applyDiscount = false,
    this.includeDeliveryFee = false,
    this.uploadedDocuments = const [],
    this.buyerRequest = const [],
    this.productImage,
  })  : productName = productName ?? TextEditingController(),
        brandName = brandName ?? TextEditingController(),
        productDescription = productDescription ?? TextEditingController(),
        startTime = startTime ?? ValueNotifier<TimeOfDay?>(null),
        endTime = endTime ?? ValueNotifier<TimeOfDay?>(null),
        bidDate = bidDate ?? ValueNotifier<DateTime?>(null),
        deliveryAddress = deliveryAddress ?? TextEditingController(),
        deliveryPrice = deliveryPrice ?? TextEditingController(),
        quantity = quantity ?? TextEditingController(),
        minDistance = minDistance ?? TextEditingController(),
        maxDistance = maxDistance ?? TextEditingController(),
        bidStartingAmount = bidStartingAmount ?? TextEditingController(),
        maxBidAmount = maxBidAmount ?? TextEditingController();

  CreateRequestState copyWith({
    TextEditingController? productName,
    TextEditingController? brandName,
    TextEditingController? productDescription,
    ValueNotifier<TimeOfDay?>? startTime,
    ValueNotifier<TimeOfDay?>? endTime,
    ValueNotifier<DateTime?>? bidDate,
    double? rangeStart,
    double? rangeEnd,
    TextEditingController? pricePerUnit,
    TextEditingController? deliveryAddress,
    TextEditingController? deliveryPrice,
    TextEditingController? quantity,
    TextEditingController? minDistance,
    TextEditingController? maxDistance,
    TextEditingController? bidStartingAmount,
    TextEditingController? maxBidAmount,
    String? productCategory,
    String? productColor,
    String? productCondition,
    String? stateOfPurchase,
    String? startDate,
    String? endDate,
    String? dateIsoFormat,
    String? lga,
    String? deliveryLga,
    String? deliveryState,
    String? biddingStartTime,
    String? productType,
    String? pickUpOption,
    String? discountType,
    bool? isLoading,
    bool? isFocused,
    bool? vendorSeeBuyRequest,
    bool? skipAddress,
    bool? applyDiscount,
    bool? includeDeliveryFee,
    List<DocType>? uploadedDocuments,
    List<BuyerRequests>? buyerRequest,
    File? productImage,
  }) {
    return CreateRequestState(
      rangeEnd: rangeEnd ?? this.rangeEnd,
      rangeStart: rangeStart ?? this.rangeStart,
      productName: productName ?? this.productName,
      brandName: brandName ?? this.brandName,
      productDescription: productDescription ?? this.productDescription,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      bidDate: bidDate ?? this.bidDate,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      productCategory: productCategory ?? this.productCategory,
      productColor: productColor ?? this.productColor,
      productCondition: productCondition ?? this.productCondition,
      stateOfPurchase: stateOfPurchase ?? this.stateOfPurchase,
      lga: lga ?? this.lga,
      deliveryState: deliveryState ?? this.deliveryState,
      deliveryLga: deliveryLga ?? this.deliveryLga,
      biddingStartTime: biddingStartTime ?? this.biddingStartTime,
      productType: productType ?? this.productType,
      quantity: quantity ?? this.quantity,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      bidStartingAmount: bidStartingAmount ?? this.bidStartingAmount,
      maxBidAmount: maxBidAmount ?? this.maxBidAmount,
      pickUpOption: pickUpOption ?? this.pickUpOption,
      discountType: discountType ?? this.discountType,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dateIsoFormat: dateIsoFormat ?? this.dateIsoFormat,
      vendorSeeBuyRequest: vendorSeeBuyRequest ?? this.vendorSeeBuyRequest,
      skipAddress: skipAddress ?? this.skipAddress,
      applyDiscount: applyDiscount ?? this.applyDiscount,
      includeDeliveryFee: includeDeliveryFee ?? this.includeDeliveryFee,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      buyerRequest: buyerRequest ?? this.buyerRequest,
      productImage: productImage ?? this.productImage,
      isFocused: isFocused ?? this.isFocused,
    );
  }

  bool get canDeliver => pickUpOption == 'delivery' && !skipAddress;
}
