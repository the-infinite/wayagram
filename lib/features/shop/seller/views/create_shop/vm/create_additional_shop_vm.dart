import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/location_response_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';

class CreateAdditionalShopVm extends StateNotifier<CreateShopState> {
  final ShopRepository _shopRepository;
  final AuthRepository _authRepository;
  final ImagePicker _picker;
  final WayaSecureDataSource _secureDataSource;

  final Ref ref;

  final _logger = getLogger('CreateAdditionalShopVm');
  CreateAdditionalShopVm(this._shopRepository, this._authRepository, this._picker, this._secureDataSource, this.ref)
      : super(CreateShopState());

  Future<void> selectState(Select value) async {
    String finalState = state.state;
    state = state.copyWith(state: value.label);
    if (finalState.isNotEmpty && value.label != finalState) {
      state.copyWith(lgas: []);
      state = state.copyWith(lga: '');
    }
    await fetchLGA(value.value, 'NG');
  }

  void selectLGA(Select value) {
    state = state.copyWith(lga: value.value);
  }

  void reset() {
    state = CreateShopState();
  }

  Future<void> createSellerShop() async {
    try {
      if ((state.image == null && !state.isEditingMode) || state.isEditingMode && state.url == null) {
        return WayaSnackBar.showToast('Pls add a Logo');
      }
      state = state.copyWith(isLoading: true);
      if (state.image != null) {
        String? url = await WayaFileRepository.instance.uploadFile(state.image!);
        state = state.copyWith(logo: url);
      }
      state = state.copyWith(vendorId: ConversationState.self.id);
      final response = state.isEditingMode
          ? await _shopRepository.editShop(state.createShopModel, state.shopId)
          : await _shopRepository.createShop(state.createShopModel);

      _logger.i(response.data);
      if (response.success) {
        reset();
        ref.read(manageShopVmProvider.notifier).getSellerShops();
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
        StatesResponseModel responseModel = StatesResponseModel.fromJson(response.data);

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
      final response = await _authRepository.getAllLGA(stateCode: stateCode, countryCode: countryCode);

      if (response.success) {
        LGAResponseModel responseModel = LGAResponseModel.fromJson(response.data);

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

        if (state.isEditingMode) {
          state = state.copyWith(url: null);
        }
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
        isEditingMode: true,
        phone: TextEditingController(text: singleShop.phone),
        email: TextEditingController(text: singleShop.email),
        description: TextEditingController(text: singleShop.description),
        name: TextEditingController(text: singleShop.name),
        lga: singleShop.lga,
        shopId: singleShop.id,
        state: singleShop.state,
        url: singleShop.logo,
        logo: singleShop.logo,
        address: TextEditingController(text: singleShop.address));
  }
}

final createAdditionalShopVmProvider =
    StateNotifierProvider.family<CreateAdditionalShopVm, CreateShopState, String>((ref, uniqueKey) {
  return CreateAdditionalShopVm(ShopRepository.instance, AuthRepository(), ImagePicker(), WayaSecureDataSource(), ref);
});
