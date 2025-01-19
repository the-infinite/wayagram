import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/discount_type_response_model.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';

final addProductProvider = StateNotifierProvider<AddProductVm, AddProductState>(
    (ref) => AddProductVm(ShopRepository(), ref));

class AddProductVm extends StateNotifier<AddProductState> {
  final ShopRepository _shopRepository;
  final Ref ref;
  AddProductVm(this._shopRepository, this.ref) : super(AddProductState()) {
    state = state.copyWith(isWayagramDeal: false);
    state =
        state.copyWith(shopId: ref.watch(manageShopVmProvider).singleShop!.id);
  }
  final ImagePicker _picker = ImagePicker();

  void updateIncludeMeasurement(bool value) {
    state = state.copyWith(includeMeasurement: value);
  }

  void updateApplyDiscount(bool value) {
    state = state.copyWith(applyDiscount: value);
  }

  void updateIncludeDeliveryFee(bool value) {
    state = state.copyWith(includeDeliveryFee: value);
  }

  void removeFile(int index) {
    state.uploadedDocuments.removeAt(index);
    state = state.copyWith(uploadedDocuments: state.uploadedDocuments);
  }

  // void uploadImage() {
  //   _picker.pickImage(source: ImageSource.gallery).then((value) {
  //     if (value != null) {
  //       File file = File(value.path);
  //       state = state.copyWith(productImage: file);
  //     }
  //   });
  // }

  void uploadImages() {
    _picker.pickMultiImage().then((value) {
      if (value.isNotEmpty) {
        List<DocType> updatedDocuments = List.from(state.uploadedDocuments);
        for (var image in value) {
          File file = File(image.path);
          updatedDocuments.add(DocType(
              file: file, type: 'image', name: file.path.split('/').last));
        }
        state = state.copyWith(uploadedDocuments: updatedDocuments);
      } else {
        print("No images were selected.");
      }
    }).catchError((error) {
      print("Error picking images: $error");
    });
  }

  List<Select> options = [
    Select(label: 'Delivery', value: 'Delivery'),
    Select(label: 'Pickup', value: 'Pickup'),
    Select(label: 'Both', value: 'Both')
  ];

  List<Select> conditions = [
    Select(label: 'New', value: 'New'),
    Select(label: 'Used', value: 'Used'),
  ];

  List<Select> restructuredCategory() {
    return categories.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.category);
    }).toList();
  }

  Future<void> getAllCategories() async {
    // final categories = await ref.read(shopVmProvider.notifier).allCategories("1");

    // if (categories != null) {
    //   state = state.copyWith(categories: categories);
    // }
  }

  Future<PaginatedResult?> getAllDiscounts(int page) async {
    try {
      final response = await _shopRepository.getAllDiscounts(page);
      List<Select> allDiscounts = [];
      if (response.success) {
        DiscountsResponse responseModel =
            DiscountsResponse.fromJson(response.data);
        final filtered =
            responseModel.discounts.where((v) => v.active).toList();
        allDiscounts = filtered.map((val) {
          return Select(label: "${val.type} ${val.percentage}%", value: val.id);
        }).toList();
        state = state.copyWith(allDiscountTypes: allDiscounts);
        state = state.copyWith(
            totalNoOfDiscountPages: responseModel.pagination.totalPages);
      }

      return PaginatedResult(
          items: allDiscounts, totalPages: state.totalNoOfDiscountPages);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> onSubmit(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      List<MultipartFile> addedimages = [];

      for (DocType doc in state.uploadedDocuments) {
        final imgPartFile = await WayaHelpers.formattedImage(doc.file);
        addedimages.add(imgPartFile);
      }
      state = state.copyWith(images: addedimages);

      final response = await _shopRepository.createProduct(
          payload: state.addProductModel, id: state.shopId);
      if (response.success && context.mounted) {
        WayaUtils.showNotice(
            context: context,
            title: "Product Added Successfully! 🎉",
            message:
                "Your product is now live in your shop and ready \n for customers to discover.",
            onPress: () => WayaNav.toNamed(ManageShop.route),
            icon: Image.asset('assets/images/shop/add-product-success.png'),
            buttonText: 'Add Another Product',
            secondButtonText: 'Go to Shop',
            onCancel: () => WayaNav.toNamed(BottomView.route, arguments: 1));
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void update(Select value, String name) {
    switch (name) {
      case "productCategory":
        state = state.copyWith(productCategory: value.label);
        state = state.copyWith(selectedCategory: value);

      case "productCondition":
        state = state.copyWith(productCondition: value.value);
      case "productType":
        state = state.copyWith(productType: value.value);
      case "pickUpOption":
        state = state.copyWith(pickUpOption: value.value);
      case "discountType":
        state = state.copyWith(discountType: value.label);
        state = state.copyWith(selectedDiscountType: value);
      default:
        state = state.copyWith(productColor: value.value);
    }
  }

  void submit(BuildContext context, bool isWayagramDeal) async {
    //final addProductData = ref.watch(addProductProvider.notifier);

    if (isWayagramDeal) {
      // print("$addProductData");
      WayaUtils.showNotice(
          context: context,
          title: "Your Application has been submitted Successfully! 🎉",
          message:
              "Your product has been submitted. We'll notify you \n once it's reviewed.",
          onPress: () => WayaNav.toNamed('/wayagram-deal'),
          icon: Image.asset('assets/images/shop/add-product-success.png'),
          buttonText: 'View Application Status',
          secondButtonText: 'Go to Dashboard',
          onCancel: () => WayaNav.toNamed('/wayagram-deal'));
    } else {
      // print("$addProductData");
      WayaUtils.showNotice(
          context: context,
          title: "Product Added Successfully! 🎉",
          message:
              "Your product is now live in your shop and ready \n for customers to discover.",
          onPress: () => WayaNav.toNamed('/add-product'),
          icon: Image.asset('assets/images/shop/add-product-success.png'),
          buttonText: 'Add Another Product',
          secondButtonText: 'Go to Dashboard',
          onCancel: () => WayaNav.toNamed(BottomView.route, arguments: 1));
    }
  }
}
