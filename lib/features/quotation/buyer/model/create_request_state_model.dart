import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/quotation/data/model/model.dart';

class CreateRequestState {
  final TextEditingController productName;
  final TextEditingController brandName;
  final TextEditingController productDescription;
  final TextEditingController startTime;
  final TextEditingController endTime;
  final TextEditingController pricePerUnit;
  final TextEditingController pickUpAddress;
  final TextEditingController deliveryPrice;
  final TextEditingController quantity;
  final TextEditingController minDistance;
  final TextEditingController maxDistance;
  final TextEditingController productWidth;
  final TextEditingController productHeight;
  final TextEditingController productDepth;

  final bool includeMeasurement;
  final bool includeDeliveryFee;
  final bool applyDiscount;
  final String productCategory;

  final String productType;

  final String productCondition;
  final String state;
  final String lga;
  final String biddingStartTime;

  final String productColor;
  final String pickUpOption;
  final String discountType;
  List<DocType> uploadedDocuments;
  File? productImage;

  CreateRequestState({
    TextEditingController? productName,
    TextEditingController? brandName,
    TextEditingController? productDescription,
    TextEditingController? startTime,
    TextEditingController? endTime,
    TextEditingController? pricePerUnit,
    TextEditingController? pickUpAddress,
    TextEditingController? deliveryPrice,
    this.productCategory = '',
    this.productColor = '',
    this.productCondition = '',
    this.state = '',
    this.lga = '',
    this.biddingStartTime = '',
    this.productType = '',
    TextEditingController? productDepth,
    TextEditingController? productHeight,
    TextEditingController? quantity,
    TextEditingController? minDistance,
    TextEditingController? maxDistance,
    TextEditingController? productWidth,
    this.discountType = '',
    this.pickUpOption = '',
    this.includeMeasurement = false,
    this.applyDiscount = false,
    this.includeDeliveryFee = false,
    this.uploadedDocuments = const [],
    this.productImage,
  })  : productName = productName ?? TextEditingController(),
        brandName = brandName ?? TextEditingController(),
        productDescription = productDescription ?? TextEditingController(),
        startTime = startTime ?? TextEditingController(),
        endTime = endTime ?? TextEditingController(),
        pricePerUnit = pricePerUnit ?? TextEditingController(),
        pickUpAddress = pickUpAddress ?? TextEditingController(),
        deliveryPrice = deliveryPrice ?? TextEditingController(),
        productDepth = productDepth ?? TextEditingController(),
        productHeight = productHeight ?? TextEditingController(),
        quantity = quantity ?? TextEditingController(),
        minDistance = minDistance ?? TextEditingController(),
        maxDistance = maxDistance ?? TextEditingController(),
        productWidth = productWidth ?? TextEditingController();

  CreateRequestState copyWith({
    TextEditingController? productName,
    TextEditingController? brandName,
    TextEditingController? productDescription,
    TextEditingController? startTime,
    TextEditingController? endTime,
    TextEditingController? pricePerUnit,
    TextEditingController? pickUpAddress,
    TextEditingController? deliveryPrice,
    TextEditingController? productWidth,
    TextEditingController? productHeight,
    TextEditingController? quantity,
    TextEditingController? minDistance,
    TextEditingController? maxDistance,
    TextEditingController? productDepth,
    String? productCategory,
    String? productColor,
    String? productCondition,
    String? state,
    String? lga,
    String? biddingStartTime,
    String? productType,
    String? pickUpOption,
    String? discountType,
    bool? includeMeasurement,
    bool? applyDiscount,
    bool? includeDeliveryFee,
    List<DocType>? uploadedDocuments,
    File? productImage,
  }) {
    return CreateRequestState(
      productName: productName ?? this.productName,
      brandName: brandName ?? this.brandName,
      productDescription: productDescription ?? this.productDescription,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      pickUpAddress: pickUpAddress ?? this.pickUpAddress,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      productCategory: productCategory ?? this.productCategory,
      productColor: productColor ?? this.productColor,
      productCondition: productCondition ?? this.productCondition,
      state: state ?? this.state,
      lga: lga ?? this.lga,
      biddingStartTime: biddingStartTime ?? this.biddingStartTime,
      productType: productType ?? this.productType,
      productDepth: productDepth ?? this.productDepth,
      productHeight: productHeight ?? this.productHeight,
      quantity: quantity ?? this.quantity,
      minDistance: quantity ?? this.minDistance,
      maxDistance: quantity ?? this.maxDistance,
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

final createRequestProvider =
    StateNotifierProvider<CreateRequestVm, CreateRequestState>(
        (ref) => CreateRequestVm(ref));

class CreateRequestVm extends StateNotifier<CreateRequestState> {
  final Ref ref;
  CreateRequestVm(this.ref) : super(CreateRequestState());
  final ImagePicker _picker = ImagePicker();

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

  List<Select> restructuredState() {
    return states.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.state);
    }).toList();
  }

  List<Select> restructuredLga() {
    return lgas.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.lga);
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
      case "biddingStartTime":
        state = state.copyWith(discountType: value.value);
      case "state":
        state = state.copyWith(state: value.value);
      case "lga":
        state = state.copyWith(lga: value.value);
      case "biddingStartTime":
        state = state.copyWith(biddingStartTime: value.value);
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
        onCancel: () => WayaNav.toNamed(BottomView.route, arguments: 1),
      );
    }
  }
}
