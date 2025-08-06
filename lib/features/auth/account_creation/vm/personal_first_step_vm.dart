import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/location_response_model.dart';
import 'package:wayagram/features/auth/account_creation/data/model/personal_state_model.dart';
import 'package:wayagram/features/auth/account_creation/data/model/response_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/chat/state/default.dart';

part 'personal_first_step_vm.g.dart';

@riverpod
class PersonalFirstStep extends _$PersonalFirstStep {
  final WayaLocalDataSource _localDataSource = WayaLocalDataSource();
  final WayaSecureDataSource _secureDataSource = WayaSecureDataSource();

  @override
  PersonalFirstStepState build() {
    return PersonalFirstStepState();
  }

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
    state = state.copyWith(gender: value.toLowerCase());
  }

  void selectBizType(Select value) {
    state = state.copyWith(businessTypeId: value.label);
    _localDataSource.saveSelectedBusinessType(value);
  }

  Future<void> selectState(Select value) async {
    String prevStates = state.state;
    state = state.copyWith(state: value.label);

    if (prevStates.isNotEmpty && value.label != prevStates) {
      state.copyWith(cities: []);
      state = state.copyWith(city: '');
      state.copyWith(lgas: []);
      state = state.copyWith(lga: '');
    }
    await fetchLGA(value.value, 'NG');
    await fetchCities(value.value, 'NG');
  }

  Future<void> selectCountry(Select value) async {
    String country = state.country;
    state = state.copyWith(country: value.label);

    if (country.isNotEmpty && value.label != country) {
      state.copyWith(states: []);
      state = state.copyWith(state: '');
      state.copyWith(cities: []);
      state = state.copyWith(city: '');
      state.copyWith(lgas: []);
      state = state.copyWith(lga: '');
    }
    await fetchStates();
  }

  void selectLGA(Select value) {
    state = state.copyWith(lga: value.value);
  }

  void selectCity(Select value) {
    state = state.copyWith(city: value.label);
  }

  Future<void> fetchCities(String stateCode, String countryCode) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.getAllCities(
        stateCode: stateCode,
        countryCode: countryCode,
      );

      if (response.success) {
        CitiesResponseModel responseModel =
            CitiesResponseModel.fromJson(response.data);

        final List<Select> allCities = responseModel.data.map((val) {
          return Select(label: val.name, value: val.stateCode);
        }).toList();
        state = state.copyWith(cities: allCities);
      }
    } catch (_) {}
  }

  Future<void> fetchStates() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.getAllStates();

      if (response.success) {
        StatesResponseModel responseModel =
            StatesResponseModel.fromJson(response.data);

        final List<Select> allStates = responseModel.data.map((val) {
          return Select(label: val.name, value: val.isoCode);
        }).toList();
        state = state.copyWith(states: allStates);
      }
    } catch (_) {}
  }

  Future<void> fetchLGA(String stateCode, String countryCode) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.getAllLGA(
        stateCode: stateCode,
        countryCode: countryCode,
      );

      if (response.success) {
        LGAResponseModel responseModel =
            LGAResponseModel.fromJson(response.data);

        final List<Select> lgas = responseModel.data.lgas.map((val) {
          return Select(label: val, value: val);
        }).toList();
        state = state.copyWith(lgas: lgas);
      }
    } catch (_) {}
  }

  Future<void> fetchLocation() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final reponse = await authRepository.getAllCountries();

      if (reponse.success) {
        CountryResponseModel responseModel =
            CountryResponseModel.fromJson(reponse.data);
        final List<Select> countries = [
          Select(
              label: responseModel.data.name, value: responseModel.data.isoCode)
        ];

        state = state.copyWith(countries: countries);
      }
    } catch (_) {}
  }

  Future<List<Select>?> fetchBusinessTypes() async {
    try {
      state = state.copyWith(isLoadingBusinessType: true);
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

      state = state.copyWith(businessTypes: businessTypes);

      return biz;
    } catch (e) {
      return [];
    } finally {
      state = state.copyWith(isLoadingBusinessType: false);
    }
  }

  void updateReferralCode(String code) {
    if (code.isNotEmpty) {
      state = state.copyWith(referralCode: TextEditingController(text: code));
    }
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
          initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)));

      if (response != null) {
        final dateOfBirth =
            "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(
            dateOfBirth: dateOfBirth, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> onSubmit(Function gotoNextTab) async {
    try {
      state = state.copyWith(isLoading: true);
      final accountState = ref.read(selectAccountProvider);
      final bool isPersonal = accountState.selectedType!.type == 'PERSONAL';
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.register(Register(
        email: state.email.text,
        password: state.password.text,
        firstName: state.firstName.text,
        lastName: state.lastName.text,
        phoneNumber:
            "234${state.phoneNumber.text.length > 10 ? state.phoneNumber.text.substring(1) : state.phoneNumber.text}",
        address: state.address.text,
        city: state.city,
        state: state.state,
        country: state.country,
        dateOfBirth: state.dateIsoFormat,
        tcAgreement: state.isAgreeToTerm,
        referenceCode: state.referralCode.text,
        policyAgreement: state.isAgreeToTerm,
        confirmPassword: state.confirmPassword.text,
        gender: state.gender.toUpperCase(),
        lga: state.lga,
        accountTypeId: accountState.selectedType!.id,
        business: isPersonal
            ? null
            : {
                "name": state.businessName.text,
                "state": state.state,
                "city": state.city,
                "country": state.country,
                "lga": state.lga,
                "address": state.businessAddress.text,
                "businessTypeId":
                    _localDataSource.getSelectedBusinessType().value,
              },
      ));

      if (response.success) {
        final responseModel = ResponseModel.fromJson(response.data);
        final user = responseModel.data.user;
        final profile = responseModel.data.profile;
        state = state.copyWith(user: user);

        // This is fine.
        ConversationState.setSelf(user, profile);

        // This is fine.
        _secureDataSource.saveUserId(user.id);
        _localDataSource.saveUserId(user.id);

        if (!isPersonal) {
          final business = responseModel.data.business!;
          state = state.copyWith(business: business);
          _secureDataSource.saveBusinessId(business.id!);
        }
        gotoNextTab();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

@riverpod
class BusinessTypes extends _$BusinessTypes {
  @override
  FutureOr<List<Select>> build() {
    return fetchBusinessTypes();
  }

  Future<List<Select>> fetchBusinessTypes() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.getBusinessTypes();
      final businesses = response.data['data']['docs'] as List;
      final businessTypes = businesses
          .map((item) => Select(
                label: item['name'],
                value: item['id'],
              ))
          .toList();

      return businessTypes;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchBusinessTypes());
  }
}
