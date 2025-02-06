import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/event/data/model/add_event_state.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/features/event/views/event_view.dart';

class AddEventVm extends StateNotifier<AddEventState> {
  final Ref ref;
  final EventRepository _eventRepository;
  final WayaSecureDataSource _secureDataSource;
  AddEventVm(this._secureDataSource, this._eventRepository, this.ref)
      : super(AddEventState());

  void reset() {
    state = AddEventState();
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

  void selectStartTime({required String time}) {
    state = state.copyWith(startTime: time);
  }

  void selectEndTime({required String time}) {
    state = state.copyWith(endTime: time);
  }

  void addFile(File file) {
    state = state.copyWith(
        eventImage: DocType(
            file: file, type: "event-image", name: file.path.split('/').last));
  }

  void removeFile() {
    state = state.copyWith(eventImage: null);
  }

  bool isStartDateAfterEndDate(String startDate, String endDate) {
    print("$startDate $endDate");
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

  Future<void> onSubmit({required BuildContext context}) async {
    try {
      // validate image
      if (state.eventImage == null) {
        WayaSnackBar.showToast("Add an Image");
        return;
      }

      // validate date
      if (isStartDateAfterEndDate(state.startDate, state.endDate)) {
        WayaSnackBar.showToast("Start date must be before the end date");
        return;
      }

      // validate time
      if (isStartTimeAfterEndTime(state.startTime, state.endTime)) {
        WayaSnackBar.showToast("Start time must be before the end time");
        return;
      }

      // validate payment option
      if (state.eventType == 'Paid' && state.eventFee.text.isEmpty) {
        WayaSnackBar.showToast("Add price for a PAID event");
        return;
      }
      state = state.copyWith(isLoading: true);
      final image = await WayaHelpers.formattedImage(state.eventImage!.file!);
      state = state.copyWith(image: image);
      final userId = await _secureDataSource.getUserId();
      state = state.copyWith(userId: userId);
      final response = await _eventRepository.createEvent(state.addEvent);

      if (response.success) {
        print(response.data);
        if (context.mounted) {
          WayaUtils.showNotice(
              context: context,
              title: "Your Event has been created successfully",
              message:
                  "Your event is now live. Share it with your audience and start engaging with attendees today!",
              onPress: () {
                WayaNav.toNamed(EventView.route);
              },
              buttonText: 'Go To Event Home Page',
              secondButtonText: 'Share Event Link',
              onCancel: () {
                // state.link
              },
              icon: Image.asset(
                "assets/images/create-event-success.png",
                scale: 1.5,
              ));
        }
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final addEventVmProvider =
    StateNotifierProvider<AddEventVm, AddEventState>((ref) {
  return AddEventVm(WayaSecureDataSource(), EventRepository(), ref);
});
