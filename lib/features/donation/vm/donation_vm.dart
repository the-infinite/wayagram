import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/donation/data/repo/donation_repository.dart';
import 'package:wayagram/features/donation/state/donation_state.dart';
import 'package:wayagram/features/event/data/model/add_event_state.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/shared/components/radio_select.dart';

class DonationVm extends StateNotifier<DonationState> {
  final Ref ref;
  final DonationRepository _donationRepository;
  final WayaSecureDataSource _secureDataSource;
  DonationVm(this._secureDataSource, this._donationRepository, this.ref)
      : super(DonationState());

  void reset() {
    state = DonationState();
  }




  // void updatePrivacyOption(String value) {
  //   state = state.copyWith(privacyOption: value);
  // }
  //
  void selectStartDate({required String date, required String iso}) {
    state = state.copyWith(startDateString: date, startDate: date);
  }

  void selectEndDate({required String date, required String iso}) {
    state = state.copyWith(endDateString: date, endDate: date);
  }



  void addFile(File file) {
    state = state.copyWith(
        donationImage: DocType(
            file: file, type: "donation-image", name: file.path.split('/').last));
  }

  void removeFile() {
    state = state.copyWith(donationImage: null);
  }

  bool isStartDateAfterEndDate(String startDate, String endDate) {
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


}

final donationVmProvider =
StateNotifierProvider<DonationVm, DonationState>((ref) {
  return DonationVm(WayaSecureDataSource(), DonationRepository(), ref);
});
