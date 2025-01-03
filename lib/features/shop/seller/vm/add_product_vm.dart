import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/model.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/shop/data/model/model.dart';

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

  final bool includeMeasurement;
  final bool includeDeliveryFee;
  final bool applyDiscount;
  final String productCategory;

  final String productType;

  final String productCondition;

  final String productColor;
  final String pickUpOption;
  final String discountType;
  List<DocType> uploadedDocuments;
  File? productImage;

  AddProductState({
    TextEditingController? productName,
    TextEditingController? productDescription,
    TextEditingController? materialType,
    TextEditingController? pricePerUnit,
    TextEditingController? pickUpAddress,
    TextEditingController? deliveryPrice,
    this.productCategory = '',
    this.productColor = '',
    this.productCondition = '',
    this.productType = '',
    TextEditingController? productDepth,
    TextEditingController? productHeight,
    TextEditingController? productWidth,
    this.discountType = '',
    this.pickUpOption = '',
    this.includeMeasurement = false,
    this.applyDiscount = false,
    this.includeDeliveryFee = false,
    this.uploadedDocuments = const [],
    this.productImage,
  })  : productName = productName ?? TextEditingController(),
        productDescription = productDescription ?? TextEditingController(),
        materialType = materialType ?? TextEditingController(),
        pricePerUnit = pricePerUnit ?? TextEditingController(),
        pickUpAddress = pickUpAddress ?? TextEditingController(),
        deliveryPrice = deliveryPrice ?? TextEditingController(),
        productDepth = productDepth ?? TextEditingController(),
        productHeight = productHeight ?? TextEditingController(),
        productWidth = productWidth ?? TextEditingController();

  AddProductState copyWith({
    TextEditingController? productName,
    TextEditingController? productDescription,
    TextEditingController? materialType,
    TextEditingController? pricePerUnit,
    TextEditingController? pickUpAddress,
    TextEditingController? deliveryPrice,
    TextEditingController? productWidth,
    TextEditingController? productHeight,
    TextEditingController? productDepth,
    String? productCategory,
    String? productColor,
    String? productCondition,
    String? productType,
    String? pickUpOption,
    String? discountType,
    bool? includeMeasurement,
    bool? applyDiscount,
    bool? includeDeliveryFee,
    List<DocType>? uploadedDocuments,
    File? productImage,
  }) {
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
    );
  }
}

final addProductProvider = StateNotifierProvider<AddProductVm, AddProductState>(
    (ref) => AddProductVm(ref));

class AddProductVm extends StateNotifier<AddProductState> {
  final Ref ref;
  AddProductVm(this.ref) : super(AddProductState());
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

  void addFile(File? file, String type) {
    if (file != null) {
      state.uploadedDocuments.add(
          DocType(file: file, type: type, name: file.path.split('/').last));
    }
    state = state.copyWith(uploadedDocuments: state.uploadedDocuments);
  }

  void removeFile(String type) {
    state.uploadedDocuments.removeWhere((doc) => doc.type == type);
    state = state.copyWith(uploadedDocuments: state.uploadedDocuments);
  }

  void uploadImage() {
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        File file = File(value.path);
        state = state.copyWith(productImage: file);
      }
    });
  }

  List<Select> restructuredCategory() {
    return categories.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.category);
    }).toList();
  }

  void update(Select value, String name) {
    switch (name) {
      case "productCategory":
        state = state.copyWith(productCategory: value.value);
      case "productCondition":
        state = state.copyWith(productCondition: value.value);
      case "productType":
        state = state.copyWith(productType: value.value);
      case "pickUpOption":
        state = state.copyWith(pickUpOption: value.value);
      case "discountType":
        state = state.copyWith(discountType: value.value);
      default:
        state = state.copyWith(productColor: value.value);
    }
  }

  void submit(BuildContext context)  async{
     //final addProductData = ref.watch(addProductProvider.notifier);

    // print("$addProductData");
    WayaHelpers.showNotice(
        context: context,
        title: "Product Added Successfully! 🎉",
        message:
            "Your product is now live in your shop and ready \n for customers to discover.",
        onPress: () => WayaNav.toNamed('/add-product'),
        icon: Image.asset('assets/images/shop/add-product-success.png'),
        buttonText: 'Add Another Product',
        secondButtonText: 'Go to Dashboard',
        onCancel: () => WayaNav.to(const BottomView(
              index: 1,
            )));
  }
}
