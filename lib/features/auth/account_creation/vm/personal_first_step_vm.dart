import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/account_creation/data/model/location_response_model.dart';
import 'package:wayagram/features/auth/account_creation/data/model/personal_state_model.dart';
import 'package:wayagram/features/auth/account_creation/data/model/response_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/chat/state/default.dart';

class PersonalFirstStepVm extends StateNotifier<PersonalFirstStepState> {
  final AuthRepository _authRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final Ref ref;

  final _logger = getLogger('PersonalFirstStepVm');

  PersonalFirstStepVm(this.ref, this._authRepository, this._localDataSource,
      this._secureDataSource)
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
    state = state.copyWith(gender: value.toLowerCase());
  }

  void selectBizType(Select value) {
    state = state.copyWith(businessTypeId: value.label);
    _localDataSource.saveSelectedBusinessType(value);
  }

  Future<void> selectState(Select value) async {
    String _state = state.state;
    state = state.copyWith(state: value.label);

    if (_state.isNotEmpty && value.label != _state) {
      state.copyWith(cities: []);
      state = state.copyWith(city: '');
      state.copyWith(lgas: []);
      state = state.copyWith(lga: '');
    }
    await fetchCities(value.value, 'NG');
  }

  Future<void> selectCountry(Select value) async {
    String _country = state.country;
    state = state.copyWith(country: value.label);

    if (_country.isNotEmpty && value.label != _country) {
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

  Future<void> selectCity(Select value) async {
    String _city = state.city;
    state = state.copyWith(city: value.label);
    await fetchLGA(value.value, 'NG');
    if (_city.isNotEmpty && value.label != _city) {
      state = state.copyWith(lgas: []);
      state = state.copyWith(lga: '');
    }
  }

  Future<void> fetchCities(String stateCode, String countryCode) async {
    try {
      final response = await _authRepository.getAllCities(
          stateCode: stateCode, countryCode: countryCode);

      if (response.success) {
        CitiesResponseModel responseModel =
            CitiesResponseModel.fromJson(response.data);

        final List<Select> allCities = responseModel.data.map((val) {
          return Select(label: val.name, value: val.stateCode);
        }).toList();
        state = state.copyWith(cities: allCities);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> fetchStates() async {
    try {
      final response = await _authRepository.getAllStates();

      if (response.success) {
        StatesResponseModel responseModel =
            StatesResponseModel.fromJson(response.data);

        final List<Select> allStates = responseModel.data.map((val) {
          return Select(label: val.name, value: val.isoCode);
        }).toList();
        state = state.copyWith(states: allStates);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> fetchLGA(String stateCode, String countryCode) async {
    try {
      final response = await _authRepository.getAllLGA(
          stateCode: stateCode, countryCode: countryCode);

      if (response.success) {
        LGAResponseModel responseModel =
            LGAResponseModel.fromJson(response.data);

        final List<Select> lgas = responseModel.data.lgas.map((val) {
          return Select(label: val, value: val);
        }).toList();
        state = state.copyWith(lgas: lgas);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> fetchLocation() async {
    try {
      final reponse = await _authRepository.getAllCountries();

      if (reponse.success) {
        CountryResponseModel responseModel =
            CountryResponseModel.fromJson(reponse.data);
        final List<Select> countries = [
          Select(
              label: responseModel.data.name, value: responseModel.data.isoCode)
        ];

        state = state.copyWith(countries: countries);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> fetchBusinessTypes() async {
    try {
      state = state.copyWith(isLoadingBusinessType: true);
      final response = await _authRepository.getBusinessTypes();
      _logger.d(response.data);
      final businesses = response.data['data']['docs'] as List;
      final businessTypes = businesses
          .map((item) => Select(
                label: item['name'],
                value: item['id'],
              ))
          .toList();

      state = state.copyWith(businessTypes: businessTypes);
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoadingBusinessType: false);
    }
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

  // Future<Waya>

  Future<void> onSubmit(Function gotoNextTab) async {
    try {
      state = state.copyWith(isLoading: true);
      final accountState = ref.watch(selectAccountProvider);
      final bool isPersonal = accountState.selectedType!.type == 'PERSONAL';
      print("isPersonal $isPersonal");
      final response = await _authRepository.register(Register(
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
  return PersonalFirstStepVm(
      ref, authRepository, localDataSource, WayaSecureDataSource());
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
  return BusinessTypes( authRepository);
});
