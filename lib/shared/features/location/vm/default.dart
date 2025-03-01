import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/shared/features/location/model/default.dart';
import 'package:wayagram/shared/features/location/repo/default.dart';
import 'package:wayagram/shared/features/location/state/default.dart';

class RegionNotifier extends StateNotifier<RegionsState> {
  final repo = WayaLocationRepository.instance;
  RegionNotifier(super.state);

  /// Fetches a list of countries from the server.
  ///
  /// This asynchronous method retrieves country data from the backend.
  /// Throws an error if the network request fails or if the server
  /// returns an invalid response.
  Future<void> getCurrentCountry() async {
    state = state.copyWith(isLoading: true);

    //? Try fetching.
    final response = await repo.getAllCountries();

    //? If this is fine.
    if (response.success) {
      final choice = RegionCountryModel.fromJson(response.data["data"]);
      state = state.copyWith(
        countries: [choice],
        hasLoaded: true,
      );

      //? Then get the states.
      await getStates();
    }

    // We are no longer loading this one.
    state = state.copyWith(isLoading: false);
  }

  /// Fetches a list of states from the server.
  ///
  /// This asynchronous method retrieves state data from the backend.
  /// Throws an error if the network request fails or if the server
  /// returns an invalid response.
  Future<void> getStates() async {
    state = state.copyWith(isLoading: true);

    //? Try fetching.
    final response = await repo.getAllStates();

    //? If this is fine.
    if (response.success) {
      state = state.copyWith(
        states: (response.data["data"] as List).map((e) => RegionStateModel.fromJson(e)).toList(),
        hasLoaded: true,
      );
    }

    // We are no longer loading this one.
    state = state.copyWith(isLoading: false);
  }

  /// Fetches a list of cities from the server.
  ///
  /// This asynchronous method retrieves city data from the backend.
  /// Throws an error if the network request fails or if the server
  /// returns an invalid response.
  Future<void> getCities(String stateCode, String country) async {
    state = state.copyWith(isLoading: true);

    //? Try fetching.
    final response = await repo.getAllCities(stateCode: stateCode, countryCode: country);

    //? If this is fine.
    if (response.success) {
      state = state.copyWith(
        cities: (response.data["data"] as List).map((e) => RegionCityModel.fromJson(e)).toList(),
        hasLoaded: true,
      );
    }

    // We are no longer loading this one.
    state = state.copyWith(isLoading: false);
  }

  /// Fetches a list of Local Government Areas from the server.
  ///
  /// This asynchronous method retrieves LGA data from the backend.
  /// Throws an error if the network request fails or if the server
  /// returns an invalid response.
  Future<void> getLGAs(String stateCode, String country) async {
    state = state.copyWith(isLoading: true);

    //? Try fetching.
    final response = await repo.getAllLGA(stateCode: stateCode, countryCode: country);

    //? If this is fine.
    if (response.success) {
      state = state.copyWith(
        areas: (response.data["data"]["lgas"] as List).map((value) => value.toString()).cast<String>().toList(),
        hasLoaded: true,
      );
    }

    // We are no longer loading this one.
    state = state.copyWith(isLoading: false);
  }

  /// Whether or not we are going to be including the "all" property.
  void setUseAll(bool value) {
    state = state.copyWith(includeAll: value);
  }

  /// Helper function used to reset the provider to its initial state.
  void reset() {
    state = RegionsState.initial.copyWith(
      countries: state.countries,
    );
  }
}

final regionsProvider = StateNotifierProvider<RegionNotifier, RegionsState>((ref) {
  return RegionNotifier(RegionsState.initial);
});
