import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_model.dart';

class CreateShopState {
  final bool isLoading;
  final TextEditingController phone;
  final TextEditingController address;
  final TextEditingController email;
  final TextEditingController description;
  final TextEditingController name;
  final MultipartFile? logo;
  final File? image;
  final String vendorId;
  final String lga;
  final String state;
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
      MultipartFile? logo,
      File? image,
      String? vendorId}) {
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
        lga: lga ??  this.lga,
        state: state ?? this.state
        );
  }

  CreateShopModel get createShopModel {
    return CreateShopModel(
        phone: "+234${phone.text}",
        address: address.text,
        email: email.text,
        description: description.text,
        name: name.text,
        logo: logo!,
        vendorId: vendorId,
        state: state,
        lga: lga,
        );
  }
}
