import 'dart:io';

import 'package:flutter/material.dart';

class AddEventState {
  final bool isLoading;
  final TextEditingController title;
  final TextEditingController organizer;
  final TextEditingController description;
  final String location;
  final TextEditingController? address;
  final String? link;
  final String eventType;
  final TextEditingController eventFee;
  final TextEditingController maxCapacity;
  final String privacyOption;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String startDateString;
  final String endDateString;
  final File? eventImage;

  AddEventState(
      {this.isLoading = false,
      TextEditingController? title,
      TextEditingController? organizer,
      TextEditingController? description,
      this.location = '',
      TextEditingController? address,
      this.link,
      this.eventType = '',
      TextEditingController? eventFee,
      TextEditingController? maxCapacity,
      this.privacyOption = '',
      this.startDate = '',
      this.startTime = '',
      this.endDate = '',
      this.endTime = '',
      this.eventImage,
      this.startDateString = '',
      this.endDateString = ''})
      : title = title ?? TextEditingController(),
        organizer = organizer ?? TextEditingController(),
        description = description ?? TextEditingController(),
        eventFee = eventFee ?? TextEditingController(),
        address = address ?? TextEditingController(),
        maxCapacity = maxCapacity ?? TextEditingController();

  AddEventState copyWith(
      {bool? isLoading,
      TextEditingController? title,
      TextEditingController? organizer,
      TextEditingController? description,
      String? location,
      TextEditingController? address,
      String? link,
      String? eventType,
      TextEditingController? eventFee,
      TextEditingController? maxCapacity,
      String? privacyOption,
      String? startDate,
      String? startTime,
      String? endDate,
      String? endTime,
      File? eventImage,
      String? startDateString,
      String? endDateString}) {
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
        eventImage:eventImage ?? this.eventImage,
        endTime: endTime ?? this.endTime,
        startDateString: startDateString ?? this.startDateString,
        endDateString: endDateString ?? this.endDateString);
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'isLoading': isLoading,
  //     'title': title.text,
  //     'organizer': organizer.text,
  //     'description': description.text,
  //     'location': location,
  //     'address': address,
  //     'link': link,
  //     'eventType': eventType,
  //     'eventFee': eventFee.text,
  //     'maxCapacity': maxCapacity.text,
  //     'privacyOption': privacyOption,
  //     'startDate': startDate,
  //     'startTime': startTime,
  //     'endDate': endDate,
  //     'endTime': endTime,
  //   };
  // }

  // factory AddEventState.fromJson(Map<String, dynamic> json) {
  //   return AddEventState(
  //     isLoading: json['isLoading'] ?? false,
  //     title: TextEditingController(text: json['title'] ?? ''),
  //     organizer: TextEditingController(text: json['organizer'] ?? ''),
  //     description: TextEditingController(text: json['description'] ?? ''),
  //     location: json['location'] ?? '',
  //     address: json['address'],
  //     link: json['link'],
  //     eventType: json['eventType'] ?? '',
  //     eventFee: TextEditingController(text: json['eventFee'] ?? ''),
  //     maxCapacity: TextEditingController(text: json['maxCapacity'] ?? ''),
  //     privacyOption: json['privacyOption'] ?? '',
  //     startDate: json['startDate'] ?? '',
  //     startTime: json['startTime'] ?? '',
  //     endDate: json['endDate'] ?? '',
  //     endTime: json['endTime'] ?? '',
  //   );
  // }

  // add the creation model
}
