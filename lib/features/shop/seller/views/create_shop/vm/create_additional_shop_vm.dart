import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/location_response_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';

class CreateAdditionalShopVm extends StateNotifier<CreateShopState> {
  final ShopRepository _shopRepository;
  final AuthRepository _authRepository;
  final ImagePicker _picker;
  final WayaSecureDataSource _secureDataSource;
  final SuccessfulSetUpState _setUpState;
  final Ref ref;

  final _logger = getLogger('CreateAdditionalShopVm');
  CreateAdditionalShopVm(this._shopRepository, this._authRepository,
      this._picker, this._secureDataSource, this._setUpState, this.ref)
      : super(CreateShopState()) {
    state = state.copyWith(vendorId: _setUpState.business?.id);
  }

  Future<void> selectState(Select value) async {
    String _state = state.state;
    state = state.copyWith(state: value.label);

    if (_state.isNotEmpty && value.label != _state) {
      state.copyWith(lgas: []);
      state = state.copyWith(lga: '');
    }

    await fetchLGA(value.value, 'NG');
  }

  void selectLGA(Select value) {
    state = state.copyWith(lga: value.value);
  }

  Future<void> createSellerShop() async {
    try {
      if (state.logo == null) {
        return WayaSnackBar.showToast('Pls add a Logo');
      }
      state = state.copyWith(isLoading: true);

      final response = await _shopRepository.createShop(state.createShopModel);
      print('ffefef');
      _logger.i(response.data);
      if (response.success) {
        WayaNav.goBack();
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchStates() async {
    try {
      final response = await _authRepository.getAllStates();

      if (response.success) {
        StatesResponseModel responseModel =
            StatesResponseModel.fromJson(response.data);

        final List<Select> allStates = responseModel.data.map((val) {
          return Select(label: val.name, value: val.isoCode);
        }).toList();
        state = state.copyWith(states: allStates);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> fetchLGA(String stateCode, String countryCode) async {
    try {
      final response = await _authRepository.getAllLGA(
          stateCode: stateCode, countryCode: countryCode);

      if (response.success) {
        LGAResponseModel responseModel =
            LGAResponseModel.fromJson(response.data);

        final List<Select> lgas = responseModel.data.lgas.map((val) {
          return Select(label: val, value: val);
        }).toList();
        state = state.copyWith(lgas: lgas);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> uploadFile() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        state = state.copyWith(
          image: file,
        );
        final formatted = await WayaHelpers.formattedImage(file);
        state = state.copyWith(logo: formatted);
      } else {
        _logger.i('No image selected.');
      }
    } catch (e) {
      _logger.e('Error uploading file: $e');
    }
  }

  void initializeEdit(ShopData singleShop) {
    //initializeEdit
    state = state.copyWith(
      phone: TextEditingController(text: singleShop.phone),
      email: TextEditingController(text: singleShop.email),
      description: TextEditingController(text: singleShop.description),
      name: TextEditingController(text: singleShop.name),
      address: TextEditingController(text: singleShop.address)
    );
  }
}

final createAdditionalShopVmProvider =
    StateNotifierProvider.family<CreateAdditionalShopVm, CreateShopState, String>((ref, uniqueKey) {
  final setUp = ref.watch(successfulSetupVmProvider);
  return CreateAdditionalShopVm(ShopRepository(), AuthRepository(),
      ImagePicker(), WayaSecureDataSource(), setUp, ref);
});
