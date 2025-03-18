class UpdateEventRequestModel {
  final String title;
  final String? description;
  final String location;
  final String locationAddress;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String eventType;
  final int fee;
  final int? maxCapacity;
  final String privacyOption;
  final String image;

  UpdateEventRequestModel({
    this.description,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.endTime,
    required this.startTime,
    required this.eventType,
    required this.fee,
    required this.privacyOption,
    required this.image,
    required this.locationAddress,
    this.maxCapacity,
  });

  /// Converts a JSON map into an `UpdateEventRequestModel` instance
  factory UpdateEventRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateEventRequestModel(
      title: json['title'],
      description: json['description'],
      location: json['location'],
      locationAddress: json['locationAddress'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      eventType: json['eventType'],
      fee: json['fee'],
      maxCapacity: json['maxCapacity'],
      privacyOption: json['privacyOption'],
      image: json['image'],
    );
  }

  /// Converts the instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'title': title,
      'location': location,
      'locationAddress': locationAddress,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'eventType': eventType,
      'fee': fee,
      'privacyOption': privacyOption,
      'image': image,
    };

    if (description != null) json['description'] = description;
    if (maxCapacity != null) json['maxCapacity'] = maxCapacity;

    return json;
  }
}
