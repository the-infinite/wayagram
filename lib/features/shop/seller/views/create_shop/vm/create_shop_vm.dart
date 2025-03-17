import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';

class CreateShopVm extends StateNotifier<CreateShopState> {
  final ShopRepository _shopRepository;
  final ImagePicker _picker;
  final WayaSecureDataSource _secureDataSource;
  final SuccessfulSetUpState _setUpState;
  final Ref ref;

  final _logger = getLogger('CreateShopVm');
  CreateShopVm(this._shopRepository, this._picker, this._secureDataSource,
      this._setUpState, this.ref)
      : super(CreateShopState()) {
    state = state.copyWith(
        email: TextEditingController(text: _setUpState.user?.user?.email));
    state = state.copyWith(state: _setUpState.business?.state);
    state = state.copyWith(lga: _setUpState.business?.lga);
    state = state.copyWith(
        name: TextEditingController(text: _setUpState.business?.name));
    state = state.copyWith(
        phone:
            TextEditingController(text: _setUpState.user?.user?.phoneNumber));
    state = state.copyWith(
        address: TextEditingController(text: _setUpState.business?.address));
    state.copyWith(description: TextEditingController(text: 'Description'));
  }

  void reset() {
    state = CreateShopState();
  }

  Future<void> createSellerShop({bool? hasNoShop}) async {
    try {
      state = state.copyWith(isLoading: true);
      if (hasNoShop == true) {
        final String imageUrl =
            "https://res.cloudinary.com/dkdrbjfdt/image/upload/v1742170216/m-shop_jcpp32.svg";
        state = state.copyWith(logo: imageUrl);
      }

      state = state.copyWith(vendorId: ConversationState.self.id);
      final response = await _shopRepository.createShop(state.createShopModel);

      _logger.i(response.data);
      await ref.read(manageShopVmProvider.notifier).refreshShops();
    } catch (e) {
      _logger.e(e);
      return;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> uploadFile() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        final formatted = await WayaHelpers.formattedImage(file);
        state = state.copyWith(
          image: file,
        );
      } else {
        _logger.i('No image selected.');
      }
    } catch (e) {
      _logger.e('Error uploading file: $e');
    }
  }
}

final createShopVmProvider =
    StateNotifierProvider<CreateShopVm, CreateShopState>((ref) {
  final setUp = ref.watch(successfulSetupVmProvider);
  return CreateShopVm(ShopRepository.instance, ImagePicker(),
      WayaSecureDataSource(), setUp, ref);
});
