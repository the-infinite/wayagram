
import 'dart:convert';

class CreateShopModel {
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;

  CreateShopModel({
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory CreateShopModel.fromJson(Map<String, dynamic> json) {
    return CreateShopModel(
      name: json['name'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}