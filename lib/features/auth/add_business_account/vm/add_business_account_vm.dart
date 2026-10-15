import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:mime/mime.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

part 'add_business_account_vm.g.dart';

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

  final bool isLoading;
  final bool isCACVerify;
  final bool isBVNVerify;
  final bool isValidCAC;
  final bool isValidBVN;
  final bool isButtonEnabled;
  final List<DocType> uploadedDocuments;

  AddBusinessAccountState({
    this.selected = '',
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

@riverpod
class AddBusinessAccount extends _$AddBusinessAccount {
  final WayaLocalDataSource localDataSource = WayaLocalDataSource();
  final WayaSecureDataSource _secureDataSource = WayaSecureDataSource();

  @override
  AddBusinessAccountState build() {
    return AddBusinessAccountState();
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

  Future<String?> getBusiness() async {
    BusinessAccountData? businessData;

    final businessProfile = await ref
        .read(profileRepositoryProvider)
        .getBusinessDataRepo(userId: ConversationState.self.id);

    if (businessProfile.success) {
      businessData = BusinessAccountData.fromJson(businessProfile.data['data']);
      final biz = await fetchBusinessTypes();
      Select? nnn =
          biz?.firstWhere((d) => d.value == businessData?.businessTypeId);
      state = state.copyWith(selected: nnn?.label);

      return businessData.id;
    } else {
      return "";
    }
  }

  Future<List<Select>?> fetchBusinessTypes() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.getBusinessTypes();
      List<Select> biz = [];
      final businesses = response.data['data']['docs'] as List;
      final businessTypes = businesses
          .map((item) => Select(
                label: item['name'],
                value: item['id'],
              ))
          .toList();

      biz = businessTypes;
      return biz;
    } catch (_) {
      return [];
    } finally {}
  }

  void validateInputs(String cac, String bvn) {
    bool isButtonEnabled;
    if (state.selected == 'CAC') {
      isButtonEnabled = cac.isNotEmpty;
    } else {
      isButtonEnabled = true;
    }
    state = state.copyWith(isButtonEnabled: isButtonEnabled);
  }

  Future<bool> verifyBVN(String bvn) async {
    //? change the state for loading and BVN verification
    state = state.copyWith(isLoading: true, isBVNVerify: true);
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.verifyBVN(bvn);

      //? check for is successful response
      if (response.data["statusCode"] == 200) {
        state = state.copyWith(
          isValidBVN: true,
          isLoading: false,
        );
        return true;
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
      //? Tell that isValidCAC is false not verifying BVN again
      state = state.copyWith(isValidBVN: false);
      return false;
    } catch (_) {
      state = state.copyWith(isValidBVN: false);
    } finally {
      state = state.copyWith(isLoading: false, isBVNVerify: false);
    }
    return false;
  }

  Future<bool> verifyCAC(String cac) async {
    state = state.copyWith(isLoading: true, isCACVerify: true);
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.verifyCAC(cac);

      if (response.data["statusCode"] == 200) {
        state = state.copyWith(
          isValidCAC: true,
          isLoading: false,
        );
        return true;
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
      state = state.copyWith(isValidCAC: false);
      return true;
    } catch (_) {
      state = state.copyWith(isValidCAC: false);
    } finally {
      state = state.copyWith(isLoading: false, isCACVerify: false);
    }
    return true;
  }

  Future<void> submit(BuildContext context, String cac, String bvn) async {
    //? check if bvn has been validated to continue
    if (!state.isValidBVN) {
      WayaSnackBar.showToast("Please Enter a valid BVN number ");
      return;
    }

    //? check if CAC has been validated to continue
    if (cac.trim().isNotEmpty) {
      if (!state.isValidCAC) {
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

    BusinessAccountData? businessData;

    final businessProfile = await ref
        .read(profileRepositoryProvider)
        .getBusinessDataRepo(userId: ConversationState.self.id);
    if (businessProfile.success) {
      businessData = BusinessAccountData.fromJson(businessProfile.data['data']);
    }
    // final businessId = await _secureDataSource.getBusinessId();
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
            'businessId': businessData?.id,
            'cacNumber': cac,
            "bvn": bvn,
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
            'businessId': businessData?.id,
            "bvn": bvn,
          };

    try {
      state = state.copyWith(isLoading: true);
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.businessKyc(formdata);
      if (response.data['statusCode'] == 200) {
        final userId = await _secureDataSource.getUserId();
        final bizResponse = await ref
            .read(profileRepositoryProvider)
            .getBusinessDataRepo(userId: userId!);
        if (bizResponse.success) {
          BusinessAccountData bizData =
              BusinessAccountData.fromJson(bizResponse.data);
          final setupVm = ref.read(successfulSetupProvider.notifier);
          setupVm.state = setupVm.state.copyWith(business: bizData);
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
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
