import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/shared/features/location/model/default.dart';

class RegionsState {
  final bool hasLoaded;
  final bool isLoading;
  final bool includeAll;
  final List<String> areas;
  final List<RegionCountryModel> countries;
  final List<RegionStateModel> states;
  final List<RegionCityModel> cities;

  // Construct.
  RegionsState({
    required this.hasLoaded,
    required this.isLoading,
    required this.includeAll,
    required this.areas,
    required this.countries,
    required this.states,
    required this.cities,
  });

  // Initial state.
  static final initial = RegionsState(
    hasLoaded: false,
    isLoading: false,
    includeAll: false,
    areas: [],
    countries: [],
    states: [],
    cities: [],
  );

  // Our getters that transform the entities into a more usable form.
  List<Select> get countryItems {
    return [
      ...countries.map((e) => Select(label: e.name, value: e.isoCode, image: e.flag)),
    ];
  }

  List<Select> get stateItems {
    return [
      if (includeAll) Select(label: 'All', value: 'all'),
      ...states.map((e) => Select(label: e.name, value: e.isoCode)),
    ];
  }

  List<Select> get cityItems {
    return [
      if (includeAll) Select(label: 'All', value: 'all'),
      ...cities.map((e) => Select(label: e.name, value: e.stateCode)),
    ];
  }

  List<Select> get areaItems {
    return [
      if (includeAll) Select(label: 'All', value: 'all'),
      ...areas.map((e) => Select(label: e, value: e)),
    ];
  }

  // Copy.
  RegionsState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    bool? includeAll,
    List<String>? areas,
    List<RegionCountryModel>? countries,
    List<RegionStateModel>? states,
    List<RegionCityModel>? cities,
  }) {
    return RegionsState(
      includeAll: includeAll ?? this.includeAll,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      areas: areas ?? this.areas,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      cities: cities ?? this.cities,
    );
  }
}
