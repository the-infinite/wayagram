import 'package:flutter/material.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_model.dart';

class CreateShopState {
  final bool isLoading;
  final TextEditingController phone;
  final TextEditingController address;
  final TextEditingController email;
  final TextEditingController description;
  final TextEditingController name;

  CreateShopState({
    this.isLoading = false,
    TextEditingController? phone,
    TextEditingController? address,
    TextEditingController? email,
    TextEditingController? description,
    TextEditingController? name,
  })  : phone = phone ?? TextEditingController(),
        address = address ?? TextEditingController(),
        email = email ?? TextEditingController(),
        description = description ?? TextEditingController(),
        name= name ?? TextEditingController();

  CreateShopState copyWith({
    bool? isLoading,
    TextEditingController? phone,
    TextEditingController? address,
    TextEditingController? email,
    TextEditingController? description,
    TextEditingController? name,
  }) {
    return CreateShopState(
      isLoading: isLoading ?? this.isLoading,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      description: description ?? this.description,
      name: name ?? this.name,
    );
  }

  CreateShopModel get createShopModel {
    return CreateShopModel(
        phone:  "+234${phone.text}",
        address: address.text,
        email: email.text,
        description: description.text,
        name: name.text);
  }
}
