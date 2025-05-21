import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/data/model/add_event_state.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/shared/components/radio_select.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

class AddEventVm extends StateNotifier<AddEventState> {
  final Ref ref;
  final EventRepository _eventRepository;
  final UploadFileRepository _uploadFileRepository;
  final WayaSecureDataSource _secureDataSource;
  AddEventVm(this._uploadFileRepository, this._secureDataSource,
      this._eventRepository, this.ref)
      : super(AddEventState());

  void reset() {
    state = AddEventState();
    ref.read(radioSelectProvider('add-event').notifier).state = '';
  }

  List<Select> eventTypes = [
    Select(label: 'Free', value: 'Free'),
    Select(label: 'Paid', value: 'Paid'),
  ];

  List<Select> locationTypes = [
    Select(label: 'Physical', value: 'Physical'),
    Select(label: 'Virtual', value: 'Virtual'),
  ];

  void update(Select value, String name) {
    switch (name) {
      case "eventType":
        state = state.copyWith(eventType: value.value);

      default:
        state = state.copyWith(location: value.value);
    }
  }

  void updatePrivacyOption(String value) {
    state = state.copyWith(privacyOption: value);
  }

  void selectStartDate({required String date, required String iso}) {
    state = state.copyWith(startDateString: date, startDate: date);
  }

  void selectEndDate({required String date, required String iso}) {
    state = state.copyWith(endDateString: date, endDate: date);
  }

  void selectTicketSalesStartDate({required String date, required String iso}) {
    state = state.copyWith(ticketStartDate: date);
  }

  void selectTicketSalesEndDate({required String date, required String iso}) {
    state = state.copyWith(ticketEndDate: date);
  }

  void selectStartTime({required String time}) {
    state = state.copyWith(startTime: time);
  }

  void selectEndTime({required String time}) {
    state = state.copyWith(endTime: time);
  }

  void addFile(File file) {
    state = state.copyWith(eventImage: [
      DocType(file: file, type: "event-image", name: file.path.split('/').last)
    ]);
  }

  void removeFile() {
    List<DocType> e = List.from(state.eventImage);
    e = e.where((i) => i.type != 'event-image').toList();
    state = state.copyWith(eventImage: e);
    debugPrint(state.toString());
  }

  bool isStartDateAfterEndDate(String startDate, String endDate) {
    if (startDate.isEmpty || endDate.isEmpty) return true;
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    return start.isAfter(end);
  }

  bool isStartTimeAfterEndTime(String startTime, String endTime) {
    List<String> startSplit = startTime.split(":");
    List<String> endSplit = endTime.split(":");

    int startMinutes = int.parse(startSplit[0]) * 60 + int.parse(startSplit[1]);
    int endMinutes = int.parse(endSplit[0]) * 60 + int.parse(endSplit[1]);

    return startMinutes > endMinutes;
  }

  Future<bool> onSubmit({required BuildContext context}) async {
    try {
      // validate image
      if (state.eventImage.isEmpty) {
        WayaSnackBar.showToast("Add an Image");
        return false;
      }

      // validate date
      if (isStartDateAfterEndDate(state.startDate, state.endDate)) {
        WayaSnackBar.showToast("Start date must be before the end date");
        return false;
      }

      // validate time
      if (isStartTimeAfterEndTime(state.startTime, state.endTime)) {
        WayaSnackBar.showToast("Start time must be before the end time");
        return false;
      }

      // validate ticket sale start date
      if (isStartDateAfterEndDate(state.ticketStartDate, state.ticketEndDate)) {
        WayaSnackBar.showToast("Sales Start date must be before the end date");
        return false;
      }

      // validate payment option
      if (state.eventType == 'Paid' && state.eventFee.text.isEmpty) {
        WayaSnackBar.showToast("Add price for a PAID event");
        return false;
      }

      if (state.eventType == 'Free' && state.eventFee.text.isEmpty) {
        state = state.copyWith(eventFee: TextEditingController(text: '0'));
      }

      if (state.eventType == "Paid" &&
          ConversationState.self.accountType == UserAccountType.personal) {
        WayaUtils.showNotice(
            context: context,
            title: "You don't have a Business Account",
            message:
                'Please upgrade to a business account to create a paid poll',
            onPress: () => WayaNav.toNamed(UpgradeToBusiness.route),
            buttonText: 'Upgrade to Business',
            secondButtonText: 'Cancel',
            icon: Image.asset('assets/images/cp-shop.png'));

        return false;
      }

      if (state.privacyOption.isEmpty) {
        WayaSnackBar.showToast("Choose a privacy option");
        return false;
      }

      state = state.copyWith(isLoading: true);
      final image = state.isEditingMode && state.eventImage[0].file == null
          ? state.eventImage[0].url
          : await WayaUtils.uploadFile(
              file: state.eventImage[0].file!,
              repository: _uploadFileRepository);

      state = state.copyWith(image: image);
      final userId = await _secureDataSource.getUserId();
      state = state.copyWith(userId: userId);
      final response = state.isEditingMode
          ? await _eventRepository.editEvent(state.updateEvent, state.eventId)
          : await _eventRepository.createEvent(state.addEvent);

      if (response.success) {
        if (context.mounted) {
          await WayaUtils.showNotice(
            context: context,
            title: state.isEditingMode
                ? "Your Event has been updated successfully"
                : "Your Event has been created successfully.",
            message:
                "Your event is now live. Share it with your audience and start engaging with attendees today!. ${state.eventType == "Paid" ? "Waya will take a commission from the payment and the rest of the money will be paid into your account" : ""}",
            onPress: () {
              WayaNav.goBack();
              reset();
            },
            buttonText: 'Go To Event Home Page',
            secondButtonText: 'Go Back',
            onCancel: () async {
              WayaNav.goBack();
              reset();
            },
            icon: Image.asset(
              "assets/images/create-event-success.png",
              scale: 1.5,
            ),
          );
        }
        return response.success;
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }

    return false;
  }

  Future<void> initializeForEdit(EventDoc event) async {
    state = state.copyWith(
      isEditingMode: true,
      title: TextEditingController(text: event.title),
      organizer: TextEditingController(text: event.organizerName),
      description: TextEditingController(text: event.description ?? ''),
      location: event.location.capitalizeFirst,
      address: TextEditingController(
          text: event.location.toLowerCase() == 'physical'
              ? event.locationAddress
              : ''),
      link: TextEditingController(
          text: event.location.toLowerCase() == 'virtual'
              ? event.locationAddress
              : ''),
      eventType: event.eventType.capitalizeFirst,
      eventFee: TextEditingController(text: event.fee.toString()),
      maxCapacity: TextEditingController(text: event.maxCapacity?.toString()),
      privacyOption: event.privacyOption,
      startDate: event.startDate.toIso8601String().split('T')[0],
      endDate: event.endDate.toIso8601String().split('T')[0],
      ticketEndDate: event.ticketSalesEndDate != null
          ? event.ticketSalesEndDate?.toIso8601String().split('T')[0]
          : '',
      ticketStartDate: event.ticketSalesStartDate != null
          ? event.ticketSalesStartDate?.toIso8601String().split('T')[0]
          : '',
      startTime: event.startTime,
      eventId: event.id,
      endTime: event.endTime,
      eventImage: [
        DocType(
            file: null,
            type: "event-image",
            name: "uploaded image",
            url: event.image)
      ],
    );
    ref.read(radioSelectProvider("add-event").notifier).state =
        event.privacyOption.capitalizeFirst;
  }
}

final addEventVmProvider =
    StateNotifierProvider<AddEventVm, AddEventState>((ref) {
  return AddEventVm(
      UploadFileRepository(), WayaSecureDataSource(), EventRepository(), ref);
});
