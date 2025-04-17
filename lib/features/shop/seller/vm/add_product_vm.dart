import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/shop/filter/constants/filter_options.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/discount_type_response_model.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_gram_deals.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

final addProductProvider =
    StateNotifierProvider.family<AddProductVm, AddProductState, String>(
        (ref, uniqueKey) =>
            AddProductVm(UploadFileRepository(), ShopRepository.instance, ref));

class AddProductVm extends StateNotifier<AddProductState> {
  final ShopRepository _shopRepository;
  final Ref ref;
  final UploadFileRepository _uploadRepository;
  AddProductVm(this._uploadRepository, this._shopRepository, this.ref)
      : super(AddProductState()) {
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
  void reset() {
    state = AddProductState();
  }

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
            responseModel.discounts.where((v) => v.active && !v.deal).toList();
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

  Future<SelectTypePaginatedResult?> getDealsDiscounts(int page) async {
    try {
      final response = await _shopRepository.getAllDiscounts(page);
      List<Select> allDiscounts = [];
      if (response.success) {
        DiscountsResponse responseModel =
            DiscountsResponse.fromJson(response.data);
        final filtered =
            responseModel.discounts.where((v) => v.active && v.deal).toList();
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

  bool validateFields() {
    if (state.productName.text.trim().isEmpty) {
      WayaSnackBar.showToast("Product name is required");
      return false;
    }
    if (state.productDescription.text.trim().isEmpty) {
      WayaSnackBar.showToast("Product description is required");
      return false;
    }
    if (state.pricePerUnit.text.trim().isEmpty) {
      WayaSnackBar.showToast("Price is required");
      return false;
    }
    if (state.selectedCategory == null) {
      WayaSnackBar.showToast("Please select a category");
      return false;
    }

    if (state.productCondition.trim().isEmpty) {
      WayaSnackBar.showToast("Product condition is required");
      return false;
    }

    return true;
  }

  Future<void> onSubmit(BuildContext context) async {
    try {
      if (state.uploadedDocuments.isEmpty) {
        WayaSnackBar.showToast("A product must have an image");
        return;
      }
      if (state.pickUpOption != 'Delivery' &&
          state.pickUpAddress.text.isEmpty) {
        WayaSnackBar.showToast("Kindly add a pickup address");
        return;
      }

      if (state.pickUpOption == "Delivery") {
        state = state.copyWith(pickUpAddress: TextEditingController(text: ''));
      }

      if (state.isWayagramDeal == true && state.discountType.isEmpty) {
        WayaSnackBar.showToast(
            "Kindly select your preferred deal in the discount section");
        return;
      }

      if (state.pricePerUnit.text.isEmpty) {
        WayaSnackBar.showToast("Kindly add a price");
        return;
      }
      state = state.copyWith(isLoading: true);

      List<String> addedimages = [];

      for (DocType doc in state.uploadedDocuments) {
        if (doc.file != null) {
          final imgPartFile = await WayaUtils.uploadFile(
              repository: _uploadRepository, file: doc.file!);
          if (imgPartFile != null) {
            addedimages.add(imgPartFile);
          }
        } else if (doc.url.isNotEmpty) {
          addedimages.add(doc.url);
        }
      }
      state = state.copyWith(images: addedimages);

      final response = state.isEditMode
          ? await _shopRepository.editProductRequest(
              payload: state.addProductModel, productId: state.productId)
          : await _shopRepository.createProduct(
              payload: state.addProductModel, id: state.shopId);
      if (response.success && context.mounted) {
        if (state.isWayagramDeal != null && state.isWayagramDeal == true) {
          WayaUtils.showNotice(
            context: context,
            title: "Your Application has been submitted Successfully! 🎉",
            message:
                "Your product has been submitted. We'll notify you \n once it's reviewed.",
            onPress: () {
              WayaNav.goBack();
              WayaNav.replaceNamed(WayaGramDeals.route);
              // reset();
            },
            icon: Image.asset('assets/images/shop/add-product-success.png'),
            buttonText: 'View Application Status',
            secondButtonText: 'Go to Dashboard',
            onCancel: () {
               WayaNav.goBack();
              WayaNav.replaceNamed(ManageShop.route, arguments: state.shopId);
              // reset();
            },
          );
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
            onPress: () {
               WayaNav.goBack();
              WayaNav.replaceNamed(ManageShop.route, arguments: state.shopId);
              //reset();
            },
            icon: Image.asset('assets/images/shop/add-product-success.png'),
            buttonText: 'Add Another Product',
            secondButtonText: 'Go to Shop',
            onCancel: () {
               WayaNav.goBack();
              WayaNav.removeUntilNamed(BottomView.route, arguments: 1);
              //reset();
            });
      } else {
        WayaSnackBar.showToast("${response.data["data"]}");
        //print(response.data);
      }
      //
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void update(Select? value, String name) {
    switch (name) {
      case "productCategory":
        state =
            state.copyWith(productCategory: value != null ? value.label : '');
        state = state.copyWith(selectedCategory: value);

      case "productCondition":
        state =
            state.copyWith(productCondition: value != null ? value.value : '');
      case "productType":
        state = state.copyWith(productType: value != null ? value.value : '');
      case "pickUpOption":
        state = state.copyWith(pickUpOption: value != null ? value.value : '');
        updatePackageOption(value != null ? value.value : '');
      case "discountType":
        state = state.copyWith(discountType: value != null ? value.label : '');
        state = state.copyWith(selectedDiscountType: value);
      default:
    }
  }

  void updateColor(List<Select> select) {
    state = state.copyWith(productColor: select);
    state = state.copyWith(selectedColor: select.map((e) => e.value).join(','));
  }

  void updatePackageOption(String value) {
    if (value == 'Pickup') {
      state = state.copyWith(includeDeliveryFee: false);
      return;
    }
    if (value == 'Delivery') {
      state = state.copyWith(pickUpAddress: TextEditingController(text: ''));
      return;
    }
  }

  Future<void> deleteProduct(
      {required String shopId, required String productId}) async {
    try {
      state = state.copyWith(isDeleting: true);
      final response = await _shopRepository.deleteProductRequest(
          shopId: shopId, productId: productId);
      if (response.success) {
           await ref
                  .read(shopVmProvider.notifier)
                  .getAllProducts(page: 1, limit: 20);
        WayaNav.replaceNamed(ManageShop.route, arguments: shopId);
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isDeleting: true);
    }
  }

  void initializeWayagramDeal() {
    state = state.copyWith(isWayagramDeal: true);
    updateApplyDiscount(true);
  }

  void initializeAddProduct() {
    state = state.copyWith(isWayagramDeal: null);
    updateApplyDiscount(false);
  }

  Future<void> initializeForEdit(SellerProduct product) async {
    try {
      state = state.copyWith(isLoadingEditingMode: true);

      state = state.copyWith(
        isEditMode: true,
        productId: product.id,
        productName: TextEditingController(text: product.name),
        productDescription: TextEditingController(text: product.description),
        materialType: TextEditingController(text: product.materialType),
        selectedColor: product.color,
        pricePerUnit: TextEditingController(
            text: double.parse(product.price).toInt().toString()),
        pickUpAddress: TextEditingController(text: product.pickupAddress),
        productCategory: product.categoryId,
        shopId: product.shopId,
        productCondition: product.condition,
        pickUpOption: product.options,
        selectedCategory:
            Select(label: product.categoryName, value: product.categoryId),
        includeDeliveryFee: product.deliveryCharge,
        isWayagramDeal: product.wayagramDeal == null ? false : true,
        includeMeasurement:
            product.height != 0 || product.width != 0 || product.depth != 0,
        productHeight: TextEditingController(text: product.height?.toString() ?? ''),
        productWidth: TextEditingController(text: product.width?.toString() ?? ''),
        productDepth: TextEditingController(text: product.depth?.toString() ?? ''),
        discountPercentage: TextEditingController(
            text: product.discountPercentage.toInt().toString()),
        discountType: product.discountTypeId,
        applyDiscount:
            product.discountTypeId != null || product.discountPercentage > 0,
      );

      if (product.color.isNotEmpty) {
        bool isHasComma = product.color.contains(',');
        if (isHasComma) {
          List<String> colorList = product.color.split(",");
          List<Select> colors = FilterOptions.colorOptions.where((c) {
            return colorList.contains(c.value);
          }).toList();

          state = state.copyWith(productColor: colors);
        } else {
          List<Select> color = FilterOptions.colorOptions
              .where((c) => c.value == product.color)
              .toList();
          state = state.copyWith(productColor: color);
        }
      }

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
