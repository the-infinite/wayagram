import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';

class CreateShopModel {
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final MultipartFile logo;
  final String vendorId;

  CreateShopModel(
      {required this.name,
      required this.description,
      required this.address,
      required this.phone,
      required this.email,
      required this.logo,
      required this.vendorId});

  factory CreateShopModel.fromJson(Map<String, dynamic> json) {
    return CreateShopModel(
        name: json['name'],
        description: json['description'],
        address: json['address'],
        phone: json['phone'],
        email: json['email'],
        vendorId: json['vendorId'],
        logo: json['logo']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'logo': logo,
      'vendorId': vendorId
    };
  }
}
