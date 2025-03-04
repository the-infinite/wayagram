import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/data/repo/donation_repository.dart';
import 'package:wayagram/features/donation/donation_modal/donation_modal.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/create_donation_response.dart';
import 'package:wayagram/features/donation/model/kyc_model.dart';
import 'package:wayagram/features/donation/model/login_response.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/state/donation_state.dart';
import 'package:wayagram/features/kyc/state/kyc_state.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

import '../../auth/transaction_pin/vm/transaction_pin_vm.dart';

class KycVm extends StateNotifier<KycState> {
  final Ref ref;
  final DonationRepository _kycRepository;
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
    state = state.copyWith(
        kycImage: DocType(
            file: file, type: "donation-image", name: file.path.split('/').last));
  }

  void removeFile() {
    state = state.copyWith(kycImage: null);
  }







}

final kycVmProvider =
StateNotifierProvider<KycVm, KycState>((ref) {
  return KycVm(WayaSecureDataSource(), DonationRepository(), ref, UploadFileRepository(), SuccessfulSetUpState());
});
