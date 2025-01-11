import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/repo/seller_repository.dart';

class CreateShopVm extends StateNotifier<CreateShopState> {
  final SellerRepository _sellerRepository;
  final ImagePicker _picker;
  final WayaSecureDataSource _secureDataSource;
  final SuccessfulSetUpState _setUpState;

  final _logger = getLogger('CreateShopVm');
  CreateShopVm(this._sellerRepository, this._picker, this._secureDataSource,
      this._setUpState)
      : super(CreateShopState()) {
    state = state.copyWith(vendorId: _setUpState.business?.id);
    state = state.copyWith(
        email: TextEditingController(text: _setUpState.business?.contactEmail));
  }

  Future<void> createSellerShop(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await _sellerRepository.createShop(state.createShopModel);

      if (response.success && context.mounted) {
        _logger.i(response.data['data']);
        Navigator.pushNamed(context, BottomView.route, arguments: 1);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> uploadFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      MultipartFile formatted = await WayaHelpers.formattedImage(file);
      state = state.copyWith(image: file);
      state = state.copyWith(logo: formatted);
    } else {
      print('No image selected.');
    }
  }
}

final createShopVmProvider =
    StateNotifierProvider<CreateShopVm, CreateShopState>((ref) {
  final setUp = ref.watch(successfulSetupVmProvider);
  return CreateShopVm(
      SellerRepository(), ImagePicker(), WayaSecureDataSource(), setUp);
});
