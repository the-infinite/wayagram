
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/model/kyc_model.dart';
import 'package:wayagram/features/kyc/data/repo/kyc_repository.dart';
import 'package:wayagram/features/kyc/state/kyc_state.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';


class KycVm extends StateNotifier<KycState> {
  final Ref ref;
  final KycRepository _kycRepository;
  final WayaSecureDataSource _secureDataSource;
  final UploadFileRepository _uploadFileRepository;
  final SuccessfulSetUpState _setupState;
  final _logger = getLogger('KycVm');
  KycVm(this._secureDataSource, this._kycRepository,
      this.ref, this._uploadFileRepository, this._setupState)
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

    print("efwefw");
    print(state);
  }


  Future<void> getMyKYC() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _kycRepository.getMyKYC(ConversationState.self.id);
      state = state.copyWith(isLoading: false);
      print('API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.success) {
        KycModel responseModel = KycModel.fromJson(response.data);
        state = state.copyWith(kycStatus: responseModel.data?.status,
        date: responseModel.data?.createdAt);
      }  else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }





}

final kycVmProvider =
StateNotifierProvider<KycVm, KycState>((ref) {
  return KycVm(WayaSecureDataSource(), KycRepository(), ref, UploadFileRepository(), SuccessfulSetUpState());
});
