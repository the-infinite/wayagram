import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';

class CreateShopVm extends StateNotifier<CreateShopState> {
  final ShopRepository _shopRepository;
  final ImagePicker _picker;
  final Ref ref;

  final _logger = getLogger('CreateShopVm');
  CreateShopVm(this._shopRepository, this._picker, this.ref)
      : super(CreateShopState());

  void reset() {
    state = CreateShopState();
  }

  Future<void> createSellerShop(
      {bool? hasNoShop, BusinessAccountData? business}) async {
    try {
      state = state.copyWith(isLoading: true);
      if (hasNoShop == true && business != null) {
        state = state.copyWith(
            email: TextEditingController(text: ConversationState.self.email));
        state = state.copyWith(state: business.state);
        state = state.copyWith(lga: business.lga);
        state =
            state.copyWith(name: TextEditingController(text: business.name));
        state = state.copyWith(
            phone: TextEditingController(
                text: ConversationState.self.phoneNumber));
        state = state.copyWith(
            address: TextEditingController(text: business.address));
        state.copyWith(description: TextEditingController(text: 'Description'));
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
  return CreateShopVm(ShopRepository.instance, ImagePicker(), ref);
});
