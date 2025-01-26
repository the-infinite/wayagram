import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_model.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';

class AddProductState {
  final TextEditingController productName;
  final TextEditingController productDescription;
  final TextEditingController materialType;
  final TextEditingController pricePerUnit;
  final TextEditingController pickUpAddress;
  final TextEditingController deliveryPrice;
  final TextEditingController productWidth;
  final TextEditingController productHeight;
  final TextEditingController productDepth;
  final List<MultipartFile> images;
  final String shopId;
  final bool? isWayagramDeal;
  final bool includeMeasurement;
  final bool includeDeliveryFee;
  final bool applyDiscount;
  final String productCategory;
  final Select? selectedCategory;

  final String productType;

  final String productCondition;

  final String productColor;
  final String pickUpOption;
  final String discountType;
  final List<Select> categories;
  final List<Select> allDiscountTypes;
  final Select? selectedDiscountType;
  List<DocType> uploadedDocuments;
  File? productImage;
  final TextEditingController discountPercentage;
  final bool isLoading;
  int totalNoOfDiscountPages;
  final bool isEditMode;
  final bool isLoadingEditingMode;

  AddProductState(
      {TextEditingController? productName,
      TextEditingController? productDescription,
      TextEditingController? materialType,
      TextEditingController? pricePerUnit,
      TextEditingController? pickUpAddress,
      TextEditingController? deliveryPrice,
      this.productCategory = '',
      this.selectedCategory,
      this.productColor = '',
      this.productCondition = '',
      this.productType = '',
      this.selectedDiscountType,
      TextEditingController? productDepth,
      TextEditingController? productHeight,
      TextEditingController? productWidth,
      this.discountType = '',
      this.pickUpOption = '',
      this.includeMeasurement = false,
      this.applyDiscount = false,
      this.includeDeliveryFee = false,
      this.uploadedDocuments = const [],
      this.shopId = '',
      this.images = const [],
      this.totalNoOfDiscountPages = 1,
      this.productImage,
      this.categories = const [],
      this.allDiscountTypes = const [],
      TextEditingController? discountPercentage,
      this.isLoading = false,
      this.isEditMode = false,
      this.isLoadingEditingMode = false,
      this.isWayagramDeal})
      : productName = productName ?? TextEditingController(),
        productDescription = productDescription ?? TextEditingController(),
        materialType = materialType ?? TextEditingController(),
        pricePerUnit = pricePerUnit ?? TextEditingController(),
        pickUpAddress = pickUpAddress ?? TextEditingController(),
        deliveryPrice = deliveryPrice ?? TextEditingController(),
        productDepth = productDepth ?? TextEditingController(),
        productHeight = productHeight ?? TextEditingController(),
        discountPercentage = discountPercentage ?? TextEditingController(),
        productWidth = productWidth ?? TextEditingController();

  AddProductState copyWith(
      {TextEditingController? productName,
      TextEditingController? productDescription,
      TextEditingController? materialType,
      TextEditingController? pricePerUnit,
      TextEditingController? pickUpAddress,
      TextEditingController? deliveryPrice,
      TextEditingController? productWidth,
      TextEditingController? productHeight,
      TextEditingController? productDepth,
      TextEditingController? stockQuantity,
      String? productCategory,
      Select? selectedCategory,
      bool? isEditMode,
      String? productColor,
      String? productCondition,
      String? productType,
      String? pickUpOption,
      String? discountType,
      bool? includeMeasurement,
      bool? applyDiscount,
      bool? includeDeliveryFee,
      List<DocType>? uploadedDocuments,
      TextEditingController? discountPercentage,
      List<MultipartFile>? images,
      File? productImage,
      bool? isWayagramDeal,
      List<Select>? categories,
      List<Select>? allDiscountTypes,
      int? totalNoOfDiscountPages,
      Select? selectedDiscountType,
      bool? isLoading,
      bool? isLoadingEditingMode,
      String? shopId}) {
    return AddProductState(
        productName: productName ?? this.productName,
        productDescription: productDescription ?? this.productDescription,
        materialType: materialType ?? this.materialType,
        pricePerUnit: pricePerUnit ?? this.pricePerUnit,
        pickUpAddress: pickUpAddress ?? this.pickUpAddress,
        deliveryPrice: deliveryPrice ?? this.deliveryPrice,
        productCategory: productCategory ?? this.productCategory,
        productColor: productColor ?? this.productColor,
        productCondition: productCondition ?? this.productCondition,
        productType: productType ?? this.productType,
        productDepth: productDepth ?? this.productDepth,
        productHeight: productHeight ?? this.productHeight,
        productWidth: productWidth ?? this.productWidth,
        pickUpOption: pickUpOption ?? this.pickUpOption,
        discountType: discountType ?? this.discountType,
        includeMeasurement: includeMeasurement ?? this.includeMeasurement,
        applyDiscount: applyDiscount ?? this.applyDiscount,
        includeDeliveryFee: includeDeliveryFee ?? this.includeDeliveryFee,
        uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
        productImage: productImage ?? this.productImage,
        shopId: shopId ?? this.shopId,
        isWayagramDeal: isWayagramDeal ?? this.isWayagramDeal,
        categories: categories ?? this.categories,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        isLoading: isLoading ?? this.isLoading,
        allDiscountTypes: allDiscountTypes ?? this.allDiscountTypes,
        selectedDiscountType: selectedDiscountType ?? this.selectedDiscountType,
        totalNoOfDiscountPages:
            totalNoOfDiscountPages ?? this.totalNoOfDiscountPages,
        isLoadingEditingMode: isLoadingEditingMode ?? this.isLoadingEditingMode,
        isEditMode: isEditMode ?? this.isEditMode,
        images: images ?? this.images);
  }

  AddProductModel get addProductModel {
    return AddProductModel(
        name: productName.text,
        description: productDescription.text,
        shopId: shopId,
        categoryId: selectedCategory!.value,
        condition: productCondition,
        price: pricePerUnit.text,
        options: pickUpOption,
        wayagramDeal: isWayagramDeal,
        discountTypeId: selectedDiscountType?.value,
        height: productHeight.text,
        width: productWidth.text,
        depth: productDepth.text,
        pickupAddress: pickUpAddress.text,
        deliveryCharge: includeDeliveryFee,
        materialType: materialType.text,
        discountPercentage: discountPercentage.text,
        images: images);
  }
}

class UpdateProductArg {
  final SellerProduct product;
  final String uniqueKey;

  UpdateProductArg({required this.uniqueKey, required this.product});
}

class AddProductArg {
  final String uniqueKey;

  AddProductArg({required this.uniqueKey});
}

class AddWayagramArg {
  final bool isWayagram;
  final String uniqueKey;

  AddWayagramArg({required this.uniqueKey, required this.isWayagram});
}
