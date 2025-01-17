class CitiesResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<CitiesLocationData> data;

  CitiesResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  // Manually serialize from JSON
  factory CitiesResponseModel.fromJson(Map<String, dynamic> json) {
    return CitiesResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as List)
          .map((item) => CitiesLocationData.fromJson(item))
          .toList(),
    );
  }

  // Manually serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class CitiesLocationData {
  final String name;
  final String countryCode;
  final String stateCode;
  final String latitude;
  final String longitude;

  CitiesLocationData({
    required this.name,
    required this.countryCode,
    required this.stateCode,
    required this.latitude,
    required this.longitude,
  });

  // Manually serialize from JSON
  factory CitiesLocationData.fromJson(Map<String, dynamic> json) {
    return CitiesLocationData(
      name: json['name'],
      countryCode: json['countryCode'],
      stateCode: json['stateCode'],
      latitude: (json['latitude']),
      longitude: (json['longitude']),
    );
  }

  // Manually serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'countryCode': countryCode,
      'stateCode': stateCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class CountryResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final CountryData data;

  CountryResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  // Deserialize from JSON
  factory CountryResponseModel.fromJson(Map<String, dynamic> json) {
    return CountryResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: CountryData.fromJson(json['data']),
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

class CountryData {
  final String name;
  final String isoCode;
  final String flag;
  final String phonecode;
  final String currency;
  final String latitude;
  final String longitude;
  final List<Timezone> timezones;

  CountryData({
    required this.name,
    required this.isoCode,
    required this.flag,
    required this.phonecode,
    required this.currency,
    required this.latitude,
    required this.longitude,
    required this.timezones,
  });

  // Deserialize from JSON
  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      name: json['name'],
      isoCode: json['isoCode'],
      flag: json['flag'],
      phonecode: json['phonecode'],
      currency: json['currency'],
      latitude: (json['latitude']),
      longitude: (json['longitude']),
      timezones: (json['timezones'] as List)
          .map((item) => Timezone.fromJson(item))
          .toList(),
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isoCode': isoCode,
      'flag': flag,
      'phonecode': phonecode,
      'currency': currency,
      'latitude': latitude,
      'longitude': longitude,
      'timezones': timezones.map((item) => item.toJson()).toList(),
    };
  }
}

class Timezone {
  final String zoneName;
  final int gmtOffset;
  final String gmtOffsetName;
  final String abbreviation;
  final String tzName;

  Timezone({
    required this.zoneName,
    required this.gmtOffset,
    required this.gmtOffsetName,
    required this.abbreviation,
    required this.tzName,
  });

  // Deserialize from JSON
  factory Timezone.fromJson(Map<String, dynamic> json) {
    return Timezone(
      zoneName: json['zoneName'],
      gmtOffset: json['gmtOffset'],
      gmtOffsetName: json['gmtOffsetName'],
      abbreviation: json['abbreviation'],
      tzName: json['tzName'],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'zoneName': zoneName,
      'gmtOffset': gmtOffset,
      'gmtOffsetName': gmtOffsetName,
      'abbreviation': abbreviation,
      'tzName': tzName,
    };
  }
}

class LGAResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final StateWithLgas data;

  LGAResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  // Factory method to create an instance from JSON
  factory LGAResponseModel.fromJson(Map<String, dynamic> json) {
    return LGAResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: StateWithLgas.fromJson(json['data']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

// Model for State with LGAs
class StateWithLgas {
  final String state;
  final List<String> lgas;
  final String name;
  final String isoCode;
  final String countryCode;
  final String latitude;
  final String longitude;

  StateWithLgas({
    required this.state,
    required this.lgas,
    required this.name,
    required this.isoCode,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to create an instance from JSON
  factory StateWithLgas.fromJson(Map<String, dynamic> json) {
    return StateWithLgas(
      state: json['state'],
      lgas: List<String>.from(json['lgas']),
      name: json['name'],
      isoCode: json['isoCode'],
      countryCode: json['countryCode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'lgas': lgas,
      'name': name,
      'isoCode': isoCode,
      'countryCode': countryCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class StatesResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<StateData> data;

  StatesResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  // Factory method to create an instance from JSON
  factory StatesResponseModel.fromJson(Map<String, dynamic> json) {
    return StatesResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as List<dynamic>)
          .map((item) => StateData.fromJson(item))
          .toList(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class StateData {
  final String name;
  final String isoCode;
  final String countryCode;
  final String latitude;
  final String longitude;

  StateData({
    required this.name,
    required this.isoCode,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to create an instance from JSON
  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      name: json['name'],
      isoCode: json['isoCode'],
      countryCode: json['countryCode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isoCode': isoCode,
      'countryCode': countryCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
