import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/account_creation/data/model/personal_state_model.dart';
import 'package:wayagram/features/auth/account_creation/data/model/response_model.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';

class PersonalFirstStepVm extends StateNotifier<PersonalFirstStepState> {
  final AuthRepository _authRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final _logger = getLogger('PersonalFirstStepVm');

  PersonalFirstStepVm(this._authRepository, this._localDataSource, this._secureDataSource)
      : super(PersonalFirstStepState());

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  void setConfirmPasswordFocus(bool hasFocus) {
    state = state.copyWith(isConfirmPasswordFocused: hasFocus);
  }

  void setPasswordFocus(bool hasFocus) {
    state = state.copyWith(isPasswordFocused: hasFocus);
  }

  void toggleTerm(bool? value) {
    state = state.copyWith(isAgreeToTerm: value!);
  }

  void focusChanged(bool hasFocus) {
    state = state.copyWith(isFocused: hasFocus);
  }

  void selectGender(String value) {
    state = state.copyWith(gender: value);
  }

  void selectBizType(Select value) {
    state = state.copyWith(businessTypeId: value.value);
    _localDataSource.saveSelectedBusinessType(value);
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: DateTime.now());

      if (response != null) {
        final dateOfBirth =
            "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(
            dateOfBirth: dateOfBirth, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> onSubmit(Function gotoNextTab) async {
    try {
      state = state.copyWith(isLoading: true);
      final bool isPersonal = _localDataSource.getUserType().type == 'PERSONAL';
      print("isPersonal $isPersonal");
      final response = await _authRepository.register(Register(
        email: state.email.text,
        password: state.password.text,
        firstName: state.firstName.text,
        lastName: state.lastName.text,
        phoneNumber:
            "234${state.phoneNumber.text.length > 10 ? state.phoneNumber.text.substring(1) : state.phoneNumber.text}",
        address: state.address.text,
        city: state.city.text,
        state: state.state.text,
        country: state.country.text,
        dateOfBirth: state.dateIsoFormat,
        tcAgreement: state.isAgreeToTerm,
        policyAgreement: state.isAgreeToTerm,
        confirmPassword: state.confirmPassword.text,
        gender: state.gender,
        accountTypeId: _localDataSource.getUserType().id,
        business: isPersonal
            ? null
            : {
                "name": state.businessName.text,
                "address": state.businessAddress.text,
                "businessTypeId": state.businessTypeId,
              },
      ));

      if (response.success) {
        final responseModel = ResponseModel.fromJson(response.data);
        final user = responseModel.data.user;
        _localDataSource.saveUser(user);
        _secureDataSource.saveUserId(user.id!);
         _localDataSource.saveUserId(user.id!);
       

        if (!isPersonal) {
          final business = responseModel.data.business;
          _localDataSource.saveBusiness(business!);
        }
        gotoNextTab();
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final personalFirstStepProvider =
    StateNotifierProvider<PersonalFirstStepVm, PersonalFirstStepState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return PersonalFirstStepVm(authRepository, localDataSource, WayaSecureDataSource());
});

class BusinessTypes extends StateNotifier<AsyncValue<List<Select>>> {
  final AuthRepository _authRepository;
  final _logger = getLogger('BusinessTypes');

  BusinessTypes(this._authRepository) : super(const AsyncValue.loading()) {
    fetchBusinessTypes();
  }

  Future<void> fetchBusinessTypes() async {
    try {
      state = const AsyncValue.loading();
      final response = await _authRepository.getBusinessTypes();
      _logger.d(response.data);
      final businesses = response.data['data']['docs'] as List;
      final businessTypes = businesses
          .map((item) => Select(
                label: item['name'],
                value: item['id'],
              ))
          .toList();

      state = AsyncValue.data(businessTypes);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      _logger.e(e);
    }
  }

  Future<void> refresh() async {
    await fetchBusinessTypes();
  }
}

final businessTypesProvider =
    StateNotifierProvider<BusinessTypes, AsyncValue<List<Select>>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return BusinessTypes(authRepository);
});
