
class AddEventRequestModel {
  final String title;
  final String organizerName;
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
  final String userId;

  AddEventRequestModel({
    this.description,
    required this.title,
    required this.organizerName,
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
    required this.userId,
    this.maxCapacity,
  });

  /// Converts a JSON map into an `AddEventRequestModel` instance
  factory AddEventRequestModel.fromJson(Map<String, dynamic> json) {
    return AddEventRequestModel(
      title: json['title'],
      organizerName: json['organizerName'],
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
      userId: json['userId'],
    );
  }

  /// Converts the instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'title': title,
      'organizerName': organizerName,
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
      'userId': userId,
    };

    if (description != null) json['description'] = description;
    if (maxCapacity != null) json['maxCapacity'] = maxCapacity;
    
    return json;
  }
}
