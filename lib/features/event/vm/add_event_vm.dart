import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/event/data/model/add_event_state.dart';
import 'package:wayagram/features/event/views/event_view.dart';

class AddEventVm extends StateNotifier<AddEventState> {
  final Ref ref;
  AddEventVm(this.ref) : super(AddEventState());

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
    Select(label: 'Both', value: 'Both'),
  ];

  void update(Select value, String name) {
    switch (name) {
      case "eventType":
        state = state.copyWith(eventType: value.value);

      default:
        state = state.copyWith(location: value.value);
    }
  }

  void selectStartDate({required String date, required String iso}) {
    state = state.copyWith(startDateString: date, startDate: iso);
  }

  void selectEndDate({required String date, required String iso}) {
    state = state.copyWith(endDateString: date, endDate: iso);
  }

  void selectStartTime({required String time}) {
    state = state.copyWith(startTime: time);
  }

  void selectEndTime({required String time}) {
    state = state.copyWith(endTime: time);
  }

  void addFile(File file) {
    state = state.copyWith(eventImage: file);
  }

  void removeFile() {
    state = state.copyWith(eventImage: null);
  }

  Future<void> onSubmit({required BuildContext context}) async {
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
}

final addEventVmProvider =
    StateNotifierProvider<AddEventVm, AddEventState>((ref) {
  return AddEventVm(ref);
});
