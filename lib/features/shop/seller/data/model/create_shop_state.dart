import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_model.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';

class CreateShopState {
  final bool isLoading;
  final TextEditingController phone;
  final TextEditingController address;
  final TextEditingController email;
  final TextEditingController description;
  final TextEditingController name;
  final String? logo;
  final File? image;
  final String vendorId;
  final String lga;
  final String state;
  final List<Select> lgas;
  final List<Select> states;
  final bool isEditingMode;
  final String? url;
  final String shopId;

  CreateShopState(
      {this.isLoading = false,
      TextEditingController? phone,
      TextEditingController? address,
      TextEditingController? email,
      TextEditingController? description,
      TextEditingController? name,
      this.image,
      this.logo,
      this.lga = '',
      this.state = '',
      this.states = const [],
      this.lgas = const [],
      this.shopId = "",
      this.isEditingMode = false,
      this.url,
      this.vendorId = ''})
      : phone = phone ?? TextEditingController(),
        address = address ?? TextEditingController(),
        email = email ?? TextEditingController(),
        description = description ?? TextEditingController(),
        name = name ?? TextEditingController();

  CreateShopState copyWith(
      {bool? isLoading,
      TextEditingController? phone,
      TextEditingController? address,
      TextEditingController? email,
      TextEditingController? description,
      TextEditingController? name,
      String? lga,
      String? state,
      List<Select>? states,
      List<Select>? lgas,
      bool? isEditingMode,
      String? logo,
      String? url,
      File? image,
      String? vendorId,
      String? shopId
      }) {
    return CreateShopState(
      isLoading: isLoading ?? this.isLoading,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      description: description ?? this.description,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      image: image ?? this.image,
      vendorId: vendorId ?? this.vendorId,
      lga: lga ?? this.lga,
      state: state ?? this.state,
      states: states ?? this.states,
      url: url ?? this.url,
      isEditingMode: isEditingMode ?? this.isEditingMode,
      lgas: lgas ?? this.lgas,
      shopId: shopId ?? this.shopId
    );
  }

  CreateShopModel get createShopModel {
    return CreateShopModel(
        phone: "+234${phone.text}",
        address: address.text,
        email: email.text,
        description: description.text,
        name: name.text,
        logo: logo,
        vendorId: vendorId,
        state: state,
        lga: lga,
        country: "Nigeria");
  }
}

class UpdateShopArg {
  final String uniqueKey;
  final ShopData singleShop;

  UpdateShopArg({required this.uniqueKey, required this.singleShop});
}

class CreateShopArg {
  final String uniqueKey;

  CreateShopArg({required this.uniqueKey});
}
