import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/discount_type_response_model.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

final addProductProvider =
    StateNotifierProvider.family<AddProductVm, AddProductState, String>(
        (ref, uniqueKey) => AddProductVm(ShopRepository(), ref));

class AddProductVm extends StateNotifier<AddProductState> {
  final ShopRepository _shopRepository;
  final Ref ref;
  AddProductVm(this._shopRepository, this.ref) : super(AddProductState()) {
    final shop = ref.watch(manageShopVmProvider).singleShop;
    if (shop != null) {
      state = state.copyWith(shopId: shop.id);
    }
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

  Future<SelectTypePaginatedResult?> getAllDiscounts(int page) async {
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

      return SelectTypePaginatedResult(
          items: allDiscounts, totalPages: state.totalNoOfDiscountPages);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> onSubmit(BuildContext context) async {
    try {
      if (state.uploadedDocuments.isEmpty) {
        WayaSnackBar.showToast("A product must have an image");
        return;
      }
      if (state.pickUpOption != 'Delivery' &&
          state.pickUpAddress.text.isEmpty) {
        WayaSnackBar.showToast("Pls add a pickup address");
        return;
      }
      state = state.copyWith(isLoading: true);

      List<MultipartFile> addedimages = [];

      for (DocType doc
          in state.uploadedDocuments.where((d) => d.file != null)) {
        final imgPartFile = await WayaHelpers.formattedImage(doc.file!);
        addedimages.add(imgPartFile);
      }
      state = state.copyWith(images: addedimages);

      final response = await _shopRepository.createProduct(
          payload: state.addProductModel, id: state.shopId);
      if (response.success && context.mounted) {
        if (state.isWayagramDeal != null && state.isWayagramDeal == true) {
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
          return;
        }
        WayaUtils.showNotice(
            context: context,
            title: state.isEditMode
                ? "Product Updated Successfully! 🎉"
                : "Product Added Successfully! 🎉",
            message: state.isEditMode
                ? "Your product has been updated and changes are now live."
                : "Your product is now live in your shop and ready for customers to discover.",
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

  Future<void> deleteProduct(
      {required String shopId, required String productId}) async {
    try {
      final response = _shopRepository.deleteProductRequest(
          shopId: shopId, productId: productId);
    } catch (e) {
      print(e);
    }
  }

  void initializeWayagramDeal() {
    state = state.copyWith(isWayagramDeal: true);
  }

  Future<void> initializeForEdit(SellerProduct product) async {
    try {
      state = state.copyWith(isLoadingEditingMode: true);
      final SelectTypePaginatedResult? catPage =
          await ref.watch(shopVmProvider.notifier).allCategories(1);
      if (catPage != null) {
        Select? prevCat =
            catPage.items.firstWhere((cat) => cat.value == product.categoryId);
        state = state.copyWith(selectedCategory: prevCat);
      }
      state = state.copyWith(
        isEditMode: true,
        productName: TextEditingController(text: product.name),
        productDescription: TextEditingController(text: product.description),
        materialType: TextEditingController(text: product.materialType),
        pricePerUnit: TextEditingController(text: product.price),
        pickUpAddress: TextEditingController(text: product.pickupAddress),
        productCategory: product.categoryId,
        shopId: product.shopId,
        productCondition: product.condition,
        pickUpOption: product.options,
        includeDeliveryFee: product.deliveryCharge,
        isWayagramDeal: product.wayagramDeal,
        includeMeasurement:
            product.height != 0 || product.width != 0 || product.depth != 0,
        productHeight: TextEditingController(text: product.height.toString()),
        productWidth: TextEditingController(text: product.height.toString()),
        productDepth: TextEditingController(text: product.height.toString()),
        discountPercentage:
            TextEditingController(text: product.discountPercentage.toString()),
        discountType: product.discountTypeId,
        applyDiscount:
            product.discountTypeId != null || product.discountPercentage > 0,
      );

      if (product.images.isNotEmpty) {
        // Convert existing images to DocType
        List<DocType> existingImages = product.images.map((url) {
          return DocType(
            file: null,
            type: 'image',
            name: url.split('/').last,
            url: url,
          );
        }).toList();

        state = state.copyWith(uploadedDocuments: existingImages);
      }
    } catch (e) {
      print(e);
      state = state.copyWith(isLoadingEditingMode: false);
    }
  }
}
