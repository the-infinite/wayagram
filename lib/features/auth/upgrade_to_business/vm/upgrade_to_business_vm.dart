import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/location_response_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';
import 'package:wayagram/features/auth/add_business_account/data/model/upgrading_response_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/auth/upgrade_to_business/data/model/upgrade_to_business_state.dart';

part 'upgrade_to_business_vm.g.dart';

@riverpod
class UpgradeToBusiness extends _$UpgradeToBusiness {
  final WayaLocalDataSource _localDataSource = WayaLocalDataSource();
  final WayaSecureDataSource _secureDataSource = WayaSecureDataSource();

  @override
  UpgradeToBusinessState build() {
    return UpgradeToBusinessState();
  }

  void selectBizType(Select value) {
    state = state.copyWith(businessTypeId: value.value);
    state = state.copyWith(businessTypeName: value.label);
    _localDataSource.saveSelectedBusinessType(value);
  }

  Future<void> selectState(Select value) async {
    String finalState = state.state;
    state = state.copyWith(state: value.label);

    if (finalState.isNotEmpty && value.label != finalState) {
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

  Future<void> selectCity(Select value) async {
    state = state.copyWith(city: value.label);
  }

  Future<void> onSubmit() async {
    try {
      state = state.copyWith(isLoading: true);
      final accountData = await ref
          .read(selectAccountTypesProvider.notifier)
          .fetchAccountType();
      final accountId = accountData.firstWhere((v) => v.type != 'PERSONAL').id;

      state = state.copyWith(accountTypeId: accountId);
      final userid = await _secureDataSource.getUserId();
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.upgradeToBusiness(
          payload: state.upgradeToBusinessModel, id: userid!);
      if (response.success) {
        UpgradingResponseModel responseModel =
            UpgradingResponseModel.fromJson(response.data);

        final businessId = responseModel.business.id;
        await _secureDataSource.saveBusinessId(businessId);
        WayaNav.toNamed(AddBusinessAccountView.route);
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

  Future<List<Select>?> fetchCities(
      String stateCode, String countryCode) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.getAllCities(
          stateCode: stateCode, countryCode: countryCode);

      List<Select>? cities;
      if (response.success) {
        CitiesResponseModel responseModel =
            CitiesResponseModel.fromJson(response.data);

        final List<Select> allCities = responseModel.data.map((val) {
          return Select(label: val.name, value: val.stateCode);
        }).toList();
        cities = allCities;
        state = state.copyWith(cities: allCities);
      }

      return cities;
    } catch (_) {
      return null;
    }
  }

  Future<List<Select>?> fetchStates() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.getAllStates();
      List<Select>? states;
      if (response.success) {
        StatesResponseModel responseModel =
            StatesResponseModel.fromJson(response.data);

        final List<Select> allStates = responseModel.data.map((val) {
          return Select(label: val.name, value: val.isoCode);
        }).toList();
        states = allStates;
        state = state.copyWith(states: allStates);
      }

      return states;
    } catch (_) {
      return null;
    }
  }

  Future<List<Select>?> fetchLGA(String stateCode, String countryCode) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.getAllLGA(
          stateCode: stateCode, countryCode: countryCode);

      List<Select>? allLgas;
      if (response.success) {
        LGAResponseModel responseModel =
            LGAResponseModel.fromJson(response.data);

        final List<Select> lgas = responseModel.data.lgas.map((val) {
          return Select(label: val, value: val);
        }).toList();
        state = state.copyWith(lgas: lgas);
      }

      return allLgas;
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchBusinessTypes() async {
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

      state = state.copyWith(businessTypes: businessTypes);
    } catch (_) {
    } finally {}
  }
}
