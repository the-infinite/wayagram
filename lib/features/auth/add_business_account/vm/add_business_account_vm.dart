import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:mime/mime.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

class DocType {
  final File? file;
  final String name;
  final String type;
  final String url;

  DocType(
      {required this.file,
      required this.type,
      required this.name,
      this.url = ''});
}

class AddBusinessAccountState {
  final String selected;
  final TextEditingController businessName;
  final TextEditingController businessAddress;
  final TextEditingController cac;
  final TextEditingController bvn;
  final bool isLoading;
  final bool isCACVerify;
  final bool isBVNVerify;
  final bool isValidCAC;
  final bool isValidBVN;
  final bool isButtonEnabled;
  final List<DocType> uploadedDocuments;

  AddBusinessAccountState({
    required this.selected,
    required this.businessName,
    required this.businessAddress,
    required this.cac,
    required this.bvn,
    this.isLoading = false,
    this.isCACVerify = false,
    this.isBVNVerify = false,
    this.isValidCAC = false,
    this.isValidBVN = false,
    this.isButtonEnabled = false,
    this.uploadedDocuments = const [],
  });

  AddBusinessAccountState copyWith({
    String? selected,
    TextEditingController? businessName,
    TextEditingController? businessAddress,
    TextEditingController? cac,
    TextEditingController? bvn,
    bool? isLoading,
    bool? isCACVerify,
    bool? isBVNVerify,
    bool? isValidCAC,
    bool? isValidBVN,
    bool? isButtonEnabled,
    List<DocType>? uploadedDocuments,
  }) {
    return AddBusinessAccountState(
      selected: selected ?? this.selected,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      cac: cac ?? this.cac,
      bvn: bvn ?? this.bvn,
      isLoading: isLoading ?? this.isLoading,
      isCACVerify: isCACVerify ?? this.isCACVerify,
      isBVNVerify: isBVNVerify ?? this.isBVNVerify,
      isValidCAC: isValidCAC ?? this.isValidCAC,
      isValidBVN: isValidBVN ?? this.isValidBVN,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
    );
  }
}

class AddBusinessAccountVm extends StateNotifier<AddBusinessAccountState> {
  final WayaLocalDataSource localDataSource;
  final AuthRepository _authRepository;
  final WayaSecureDataSource _secureDataSource;
  final ProfileRepo _profileRepo;
  final SuccessfulSetupVm _setupVm;
  final Ref ref;
  final _logger = getLogger("AddBusinessAccountVm");

  AddBusinessAccountVm(this._authRepository, this.localDataSource,
      this._secureDataSource, this._profileRepo, this._setupVm, this.ref)
      : super(AddBusinessAccountState(
          selected: localDataSource.getSelectedBusinessType().label,
          businessName: TextEditingController(),
          businessAddress: TextEditingController(),
          cac: TextEditingController(),
          bvn: TextEditingController(),
        )) {
    state.businessName.addListener(validateInputs);
    state.businessAddress.addListener(validateInputs);
    state.cac.addListener(validateInputs);
    state.bvn.addListener(validateInputs);
  }

  void addFile(File? file, String type) {
    if (file != null) {
      state = state.copyWith(
        uploadedDocuments: [
          ...state.uploadedDocuments,
          DocType(file: file, type: type, name: file.path.split('/').last)
        ],
      );
    }
  }

  void removeFile(String type) {
    state = state.copyWith(
      uploadedDocuments: state.uploadedDocuments
          .where((element) => element.type != type)
          .toList(),
    );
  }

  void validateInputs() {
    bool isButtonEnabled;
    if (state.selected == 'CAC') {
      isButtonEnabled = state.businessName.text.isNotEmpty &&
          state.businessAddress.text.isNotEmpty &&
          state.cac.text.isNotEmpty;
    } else {
      isButtonEnabled = state.businessName.text.isNotEmpty &&
          state.businessAddress.text.isNotEmpty;
    }
    state = state.copyWith(isButtonEnabled: isButtonEnabled);
  }

  Future<bool> verifyBVN() async {
    //? change the state for loading and BVN verification
    state = state.copyWith(isLoading: true, isBVNVerify: true);
    try {
      final response = await _authRepository.verifyBVN(state.bvn.text);

      //? check for is successful response
      if (response.data["statusCode"] == 200) {
        state = state.copyWith(
          isValidBVN: true,
          isLoading: false,
        );
        return true;
      }
      //? Tell that isValidCAC is false not verifying BVN again
      state = state.copyWith(isValidBVN: false);
      return false;
    } catch (e) {
      //? Tell that isValidCAC is false not verifying BVN again
      state = state.copyWith(isValidBVN: false);
      _logger.e(e);
    } finally {
      //? close off all on the verification of BVN
      state = state.copyWith(isLoading: false, isBVNVerify: false);
    }

    return false;
  }

  Future<bool> verifyCAC() async {
    //? change the state for loading and CAC verification
    state = state.copyWith(isLoading: true, isCACVerify: true);
    try {
      final response = await _authRepository.verifyCAC(state.cac.text);

      //? check for is successful response
      if (response.data["statusCode"] == 200) {
        state = state.copyWith(
          isValidCAC: true,
          isLoading: false,
        );
        return true;
      }
      //? Tell that isValidCAC is false not verifying CAC again
      state = state.copyWith(isValidCAC: false);
      return true;
    } catch (e) {
      //? an error occurred
      state = state.copyWith(isValidCAC: false);
      _logger.e(e);
    } finally {
      //? close off all on the verification of CAC
      state = state.copyWith(isLoading: false, isCACVerify: false);
    }
    return true;
  }

  @override
  void dispose() {
    state.businessName.dispose();
    state.businessAddress.dispose();
    state.cac.dispose();
    super.dispose();
  }

  Future<void> submit(BuildContext context) async {
    //? check if bvn has been validated to continue
    if (!state.isValidBVN) {
      //?Display an error message
      WayaSnackBar.showToast("Please Enter a valid BVN number ");
      return;
    }

    //? check if CAC has been validated to continue
    if (state.cac.text.trim().isNotEmpty) {
      if (!state.isValidCAC) {
        //?Display an error message
        WayaSnackBar.showToast("Please Enter a valid CAC number ");

        return;
      }
    }
    //? method for upload file
    Future<MultipartFile> formattedImage(File file) async {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      return await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
        contentType: MediaType.parse(mimeType),
      );
    }

    final businessId = await _secureDataSource.getBusinessId();
    debugPrint("feefer $businessId");
    final formdata = state.selected == 'CAC'
        ? {
            'nin': await formattedImage(state.uploadedDocuments
                .firstWhere((element) => element.type == 'nin')
                .file!),
            'cacDocument': await formattedImage(state.uploadedDocuments
                .firstWhere((element) => element.type == 'cac')
                .file!),
            'utilityBill': await formattedImage(state.uploadedDocuments
                .firstWhere((element) => element.type == 'bill')
                .file!),
            'passport': await formattedImage(state.uploadedDocuments
                .firstWhere((element) => element.type == 'passport')
                .file!),
            'businessId': businessId,
            'cacNumber': state.cac.text,
            "bvn": state.bvn.text,
          }
        : {
            'nin': await formattedImage(state.uploadedDocuments
                .firstWhere((element) => element.type == 'nin')
                .file!),
            'utilityBill': await formattedImage(state.uploadedDocuments
                .firstWhere((element) => element.type == 'bill')
                .file!),
            'passport': await formattedImage(state.uploadedDocuments
                .firstWhere((element) => element.type == 'passport')
                .file!),
            'businessId': businessId,
          };

    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.businessKyc(formdata);
      if (response.data['statusCode'] == 200) {
        final userId = await _secureDataSource.getUserId();
        final bizResponse =
            await _profileRepo.getBusinessDataRepo(userId: userId!);
        if (bizResponse.success) {
          BusinessAccountData bizData =
              BusinessAccountData.fromJson(bizResponse.data);
          _setupVm.state.copyWith(business: bizData);
        }
        if (context.mounted) {
          WayaUtils.showNotice(
              context: context,
              title: 'KYC Documents Submitted Successfully',
              message:
                  'Your documents are under review. We’ll notify you once the verification process is complete',
              onPress: () => WayaNav.toNamed("/explore"),
              icon: Image.asset('assets/images/auth/doc-success.png'),
              buttonText: 'Go To HomePage');
        }
      } else {
        throw response.data;
      }
    } catch (e) {
      WayaSnackBar.showToast(e is String ? e : (e as dynamic)['message']);
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final addBusinessAccountProvider = StateNotifierProvider.autoDispose<
    AddBusinessAccountVm, AddBusinessAccountState>((ref) {
  final successfulSetupVm = ref.read(successfulSetupVmProvider.notifier);
  return AddBusinessAccountVm(AuthRepository(), WayaLocalDataSource(),
      WayaSecureDataSource(), ProfileRepo(), successfulSetupVm, ref);
});
