import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
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
  final bool isLoading;
  final bool isButtonEnabled;
  final List<DocType> uploadedDocuments;

  AddBusinessAccountState({
    required this.selected,
    required this.businessName,
    required this.businessAddress,
    required this.cac,
    this.isLoading = false,
    this.isButtonEnabled = false,
    this.uploadedDocuments = const [],
  });

  AddBusinessAccountState copyWith({
    String? selected,
    TextEditingController? businessName,
    TextEditingController? businessAddress,
    TextEditingController? cac,
    bool? isLoading,
    bool? isButtonEnabled,
    List<DocType>? uploadedDocuments,
  }) {
    return AddBusinessAccountState(
      selected: selected ?? this.selected,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      cac: cac ?? this.cac,
      isLoading: isLoading ?? this.isLoading,
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
        )) {
    state.businessName.addListener(validateInputs);
    state.businessAddress.addListener(validateInputs);
    state.cac.addListener(validateInputs);
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

  @override
  void dispose() {
    state.businessName.dispose();
    state.businessAddress.dispose();
    state.cac.dispose();
    super.dispose();
  }

  Future<void> submit(BuildContext context) async {
    Future<MultipartFile> formattedImage(File file) async {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      return await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
        contentType: MediaType.parse(mimeType),
      );
    }

    final businessId = await _secureDataSource.getBusinessId();
    print("feefer $businessId");
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
            'cacNumber': state.cac.text
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
      }
    } catch (e) {
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
