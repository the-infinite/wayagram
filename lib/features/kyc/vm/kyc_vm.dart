import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/model/kyc_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/kyc/data/repo/kyc_repository.dart';
import 'package:wayagram/features/kyc/state/kyc_state.dart';

class KycVm extends StateNotifier<KycState> {
  final Ref ref;
  final KycRepository _kycRepository;
  final ProfileRepo _profileRepo;
  final WayaSecureDataSource _secureDataSource;

  KycVm(
      this._kycRepository, this._profileRepo, this._secureDataSource, this.ref)
      : super(KycState());

  void reset() {
    state = KycState();
  }

  void addFile(File file) {
    state = state.copyWith(kycImage: [
      DocType(file: file, type: "kyc-image", name: file.path.split('/').last)
    ]);
  }

  void removeFile() {
    List<DocType> e = List.from(state.kycImage);
    e = e.where((i) => i.type != 'kyc-image').toList();
    state = state.copyWith(kycImage: e);
    debugPrint(state.toString());
  }

  Future<void> getMyKYC() async {
    BusinessAccountData? businessData;
    try {
      // API call
      state = state.copyWith(isLoading: true);

      final businessProfile = await _profileRepo.getBusinessDataRepo(
          userId: ConversationState.self.id);
      if (businessProfile.success) {
        businessData =
            BusinessAccountData.fromJson(businessProfile.data['data']);
        await _secureDataSource.saveBusinessId(businessData.id);
      } else {
        state = state.copyWith(notBusiness: true);

        return;
      }

      final response = await _kycRepository.getMyKYC(ConversationState.self.id);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        KycModel responseModel = KycModel.fromJson(response.data);
        state = state.copyWith(
            kycStatus: responseModel.data?.status,
            date: responseModel.data?.createdAt,
            notBusiness: false,
            reason: responseModel.data?.reasons ?? '');
      } else {
        state = state.copyWith(kycStatus: 'NO KYC');
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final kycVmProvider = StateNotifierProvider<KycVm, KycState>((ref) {
  return KycVm(KycRepository(), ProfileRepo(), WayaSecureDataSource(), ref);
});
