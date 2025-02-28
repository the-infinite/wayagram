import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

@JsonSerializable()
class RegionLGAModel {
  final String state;
  final List<String> lgas;
  final String name;
  final String isoCode;
  final String countryCode;
  final String latitude;
  final String longitude;

  RegionLGAModel({
    required this.state,
    required this.lgas,
    required this.name,
    required this.isoCode,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  factory RegionLGAModel.fromJson(Map<String, dynamic> json) => _$RegionLGAModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegionLGAModelToJson(this);
}

@JsonSerializable()
class RegionStateModel {
  final String name;
  final String isoCode;
  final String countryCode;
  final String latitude;
  final String longitude;

  RegionStateModel({
    required this.name,
    required this.isoCode,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  factory RegionStateModel.fromJson(Map<String, dynamic> json) => _$RegionStateModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegionStateModelToJson(this);
}

@JsonSerializable()
class RegionCityModel {
  final String name;
  final String countryCode;
  final String stateCode;
  final String latitude;
  final String longitude;

  RegionCityModel({
    required this.name,
    required this.countryCode,
    required this.stateCode,
    required this.latitude,
    required this.longitude,
  });

  factory RegionCityModel.fromJson(Map<String, dynamic> json) => _$RegionCityModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegionCityModelToJson(this);
}

@JsonSerializable()
class RegionCountryModel {
  final String name;
  final String isoCode;
  final String flag;
  final String phonecode;
  final String currency;
  final String latitude;
  final String longitude;
  final List<RegionTimezone> timezones;

  RegionCountryModel({
    required this.name,
    required this.isoCode,
    required this.flag,
    required this.phonecode,
    required this.currency,
    required this.latitude,
    required this.longitude,
    required this.timezones,
  });

  factory RegionCountryModel.fromJson(Map<String, dynamic> json) => _$RegionCountryModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegionCountryModelToJson(this);
}

@JsonSerializable()
class RegionTimezone {
  final String zoneName;
  final int gmtOffset;
  final String gmtOffsetName;
  final String abbreviation;
  final String tzName;

  RegionTimezone({
    required this.zoneName,
    required this.gmtOffset,
    required this.gmtOffsetName,
    required this.abbreviation,
    required this.tzName,
  });

  factory RegionTimezone.fromJson(Map<String, dynamic> json) => _$RegionTimezoneFromJson(json);
  Map<String, dynamic> toJson() => _$RegionTimezoneToJson(this);
}
