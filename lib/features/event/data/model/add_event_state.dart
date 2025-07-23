import 'package:flutter/material.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/event/data/model/add_event_request_model.dart';
import 'package:wayagram/features/event/data/model/update_event_request_model.dart';

class AddEventState {
  final bool isLoading;
  final TextEditingController title;
  final TextEditingController organizer;
  final TextEditingController description;
  final String location;
  final TextEditingController address;
  final TextEditingController link;
  final String eventType;
  final TextEditingController eventFee;
  final TextEditingController? maxCapacity;
  final String privacyOption;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String startDateString;
  final String endDateString;
  final String ticketStartDateString;
  final String ticketEndDateString;
  final String ticketEndDate;
  final String ticketStartDate;
  final List<DocType> eventImage;
  final String? image;
  final String userId;
  final bool isEditingMode;
  final String imageUrl;
  final String eventId;

  AddEventState(
      {this.isLoading = false,
      TextEditingController? title,
      TextEditingController? organizer,
      TextEditingController? description,
      this.location = '',
      TextEditingController? address,
      TextEditingController? link,
      this.eventType = '',
      TextEditingController? eventFee,
      TextEditingController? maxCapacity,
      this.privacyOption = '',
      this.startDate = '',
      this.startTime = '',
      this.endDate = '',
      this.endTime = '',
      this.image,
      this.eventImage = const [],
      this.startDateString = '',
      this.ticketStartDate = '',
      this.ticketEndDate = '',
      this.ticketStartDateString = '',
      this.ticketEndDateString = '',
      this.userId = '',
      this.isEditingMode = false,
      this.imageUrl = '',
      this.eventId = '',
      this.endDateString = ''})
      : title = title ?? TextEditingController(),
        organizer = organizer ?? TextEditingController(),
        description = description ?? TextEditingController(),
        eventFee = eventFee ?? TextEditingController(),
        address = address ?? TextEditingController(),
        link = link ?? TextEditingController(),
        maxCapacity = maxCapacity ?? TextEditingController();

  AddEventState copyWith({
    bool? isLoading,
    TextEditingController? title,
    TextEditingController? organizer,
    TextEditingController? description,
    String? location,
    TextEditingController? address,
    TextEditingController? link,
    String? eventType,
    TextEditingController? eventFee,
    TextEditingController? maxCapacity,
    String? privacyOption,
    String? startDate,
    String? startTime,
    String? endDate,
    String? endTime,
    List<DocType>? eventImage,
    String? startDateString,
    String? image,
    String? userId,
    bool? isEditingMode,
    String? imageUrl,
    String? eventId,
    String? endDateString,
    String? ticketStartDateString,
    String? ticketEndDateString,
    String? ticketStartDate,
    String? ticketEndDate,
  }) {
    return AddEventState(
        isLoading: isLoading ?? this.isLoading,
        title: title ?? this.title,
        organizer: organizer ?? this.organizer,
        description: description ?? this.description,
        location: location ?? this.location,
        address: address ?? this.address,
        link: link ?? this.link,
        eventType: eventType ?? this.eventType,
        eventFee: eventFee ?? this.eventFee,
        maxCapacity: maxCapacity ?? this.maxCapacity,
        privacyOption: privacyOption ?? this.privacyOption,
        startDate: startDate ?? this.startDate,
        startTime: startTime ?? this.startTime,
        endDate: endDate ?? this.endDate,
        eventImage: eventImage ?? this.eventImage,
        endTime: endTime ?? this.endTime,
        startDateString: startDateString ?? this.startDateString,
        image: image ?? this.image,
        userId: userId ?? this.userId,
        isEditingMode: isEditingMode ?? this.isEditingMode,
        imageUrl: imageUrl ?? this.imageUrl,
        eventId: eventId ?? this.eventId,
        endDateString: endDateString ?? this.endDateString,
        ticketEndDate: ticketEndDate ?? this.ticketEndDate,
        ticketStartDate: ticketStartDate ?? this.ticketStartDate,
        ticketStartDateString:
            ticketStartDateString ?? this.ticketStartDateString,
        ticketEndDateString: ticketEndDateString ?? this.ticketEndDateString);
  }

  Map<String, dynamic> toJson() {
    return {
      'isLoading': isLoading,
      'title': title.text,
      'organizer': organizer.text,
      'description': description.text,
      'location': location,
      'address': address,
      'link': link,
      'eventType': eventType,
      'eventFee': eventFee.text,
      'maxCapacity': maxCapacity!.text,
      'privacyOption': privacyOption,
      'startDate': startDate,
      'startTime': startTime,
      'endDate': endDate,
      'endTime': endTime,
      'image': image,
      'userId': userId,
      'isEditingMode': isEditingMode,
      'imageUrl': imageUrl,
      'eventId': eventId,
      'ticketStartDate': ticketStartDate,
      'ticketEndDate': ticketEndDate
    };
  }

  factory AddEventState.fromJson(Map<String, dynamic> json) {
    return AddEventState(
        isLoading: json['isLoading'] ?? false,
        title: TextEditingController(text: json['title'] ?? ''),
        organizer: TextEditingController(text: json['organizer'] ?? ''),
        description: TextEditingController(text: json['description'] ?? ''),
        location: json['location'] ?? '',
        address: json['address'],
        link: TextEditingController(text: json['link']),
        eventType: json['eventType'] ?? '',
        eventFee: TextEditingController(text: json['eventFee'] ?? ''),
        maxCapacity: TextEditingController(text: json['maxCapacity'] ?? ''),
        privacyOption: json['privacyOption'] ?? '',
        startDate: json['startDate'] ?? '',
        startTime: json['startTime'] ?? '',
        endDate: json['endDate'] ?? '',
        endTime: json['endTime'] ?? '',
        image: json['image'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        isEditingMode: json['isEditingMode'] ?? false,
        eventId: json['eventId'] ?? '',
        userId: json['userId'] ?? '');
  }

  // add the creation model
  AddEventRequestModel get addEvent {
    return AddEventRequestModel(
        title: title.text,
        organizerName: organizer.text,
        location: location.toLowerCase(),
        startDate: startDate,
        endDate: endDate,
        description: description.text,
        ticketSalesEndDate: ticketEndDate,
        ticketSalesStartDate: ticketStartDate,
        endTime: endTime,
        startTime: startTime,
        eventType: eventType.toLowerCase(),
        fee: int.parse(eventType == "Free" ? "0" : eventFee.text),
        privacyOption: privacyOption.toLowerCase(),
        image: image!,
        maxCapacity: maxCapacity!.text.isEmpty && isEditingMode
            ? null
            : maxCapacity!.text.isEmpty
                ? null
                : int.parse(maxCapacity!.text),
        locationAddress: location == 'Physical' ? address.text : link.text,
        userId: userId);
  }

  //>
  UpdateEventRequestModel get updateEvent {
    return UpdateEventRequestModel(
      title: title.text,
      location: location.toLowerCase(),
      startDate: startDate,
      endDate: endDate,
      ticketSalesEndDate: ticketEndDate,
      ticketSalesStartDate: ticketStartDate,
      description: description.text,
      endTime: endTime,
      startTime: startTime,
      eventType: eventType.toLowerCase(),
      fee: int.parse(eventType == "Free" ? "0" : eventFee.text),
      privacyOption: privacyOption.toLowerCase(),
      image: image!,
      maxCapacity: maxCapacity!.text.isEmpty && isEditingMode
          ? null
          : maxCapacity!.text.isEmpty
              ? null
              : int.parse(maxCapacity!.text),
      locationAddress: location == 'Physical' ? address.text : link.text,
    );
  }
}

const eventReport = [
  "Spam or misleading content",
  "Inappropriate_Content",
  "Fraudulent_activity",
  "Violates_terms_and_conditions",
  "other"
];
