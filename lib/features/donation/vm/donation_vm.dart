import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/data/repo/donation_repository.dart';
import 'package:wayagram/features/donation/donation_modal/donation_modal.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/create_donation_response.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/state/donation_state.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

class DonationVm extends StateNotifier<DonationState> {
  final Ref ref;
  final DonationRepository _donationRepository;
  final WayaSecureDataSource _secureDataSource;
  final UploadFileRepository _uploadFileRepository;
  final SuccessfulSetUpState _setupState;
  final _logger = getLogger('DonationVm');
  DonationVm(this._secureDataSource, this._donationRepository,
      this.ref, this._uploadFileRepository, this._setupState)
      : super(DonationState());

  void reset() {
    state = DonationState();
  }

  void updateAmountRaised(bool value) {
    state = state.copyWith(showAmountRaised: value);
  }

  void updateNumberOfDonors(bool value) {
    state = state.copyWith(showNumberOfDonors: value);
  }

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

  Future<PaginatedResult<AllDonationDocs>?> getAllDonation(int page) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository.getAllCampaigns(page);
      List<AllDonationDocs>? fetchAllDonations= [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        AllDonationModel responseModel = AllDonationModel.fromJson(response.data);
        fetchAllDonations = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(allDonationDocs: fetchAllDonations);
        state = state.copyWith(allDonationDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchAllDonations!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> verifyWalletPin(String pin) async {
    final user = _setupState.user?.user;
    final response = await _donationRepository
        .confirmWalletPin(ConfirmWalletPin(userId: user!.id ?? "", pin: pin));
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> editCampaign(ctx, amount, campaignId ) async {

    try {
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository.updateDonation(amount, campaignId);
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              'Minimum amount updated successfully!',
              style:
              TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        print('Edit campaign');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


  /* Future<PaginatedResult<MyDonationDocs>?> getMyDonation(int page) async {

    try{
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository.getMyCampaigns(ConversationState.self.id,page);
      List<MyDonationDocs>? fetchMyDonations= [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        MyDonationModel responseModel = MyDonationModel.fromJson(response.data);
        fetchMyDonations = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(myDonationDocs: fetchMyDonations);
        state = state.copyWith(myDonationDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchMyDonations!);
    }catch (e){
      _logger.e(e);
    }finally {
      state = state.copyWith(isLoading: false);
    }
  }
*/
  Future<void> onSubmit(title, description, solution, impact, targetAmount, minimumAmount, privacy, expirationDate, image, startDate, {required BuildContext context}) async {
    try {
      // validate image
      if (state.donationImage == null) {
        WayaSnackBar.showToast("Add an Image");
        return;
      }

      // validate date
      if (isStartDateAfterEndDate(state.startDate, state.endDate)) {
        WayaSnackBar.showToast("Start date must be before the end date");
        return;
      }

      // validate time
      // if (isStartTimeAfterEndTime(state.startTime, state.endTime)) {
      //   WayaSnackBar.showToast("Start time must be before the end time");
      //   return;
      // }

      // validate payment option
      // if (state.eventType == 'Paid' && state.eventFee.text.isEmpty) {
      //   WayaSnackBar.showToast("Add price for a PAID event");
      //   return;
      // }

      // if (state.eventType == 'Free' && state.eventFee.text.isEmpty) {
      //   state = state.copyWith(eventFee: TextEditingController(text: '0'));
      // }

      state = state.copyWith(isLoading: true);
      final image =  state.donationImage!.file == null
          ? state.donationImage!.url
          : await WayaUtils.uploadFile(
          file: state.donationImage!.file!, repository: _uploadFileRepository);

      final response = await _donationRepository.createCampaign(title, description,
          solution, impact,
          targetAmount, minimumAmount,
          privacy, expirationDate, image!, startDate);


      if (response.success) {
        if (context.mounted) {
          CreateDonationResponse createDonationResponse = CreateDonationResponse.fromJson(response.data);
          WayaUtils.showModalSheet(
            context,
            child: DonationSuccessModal(url: '${createDonationResponse.data?.url}',),
          );
        }
        //reset();
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isLoading: false);
    }

  }


// Future<void> getAllDonation() async {
  //   print('Fetching saved posts...');
  //
  //   try {
  //     // API call
  //     state = state.copyWith(isLoading: true);
  //     final response = await _donationRepository.getAllCampaigns();
  //     state = state.copyWith(isLoading: false);
  //     print('API Response: ${response.data}');
  //     print('Status Code: ${response.statusCode}');
  //
  //     if (response.success) {
  //       AllDonationModel responseModel = AllDonationModel.fromJson(response.data);
  //       state = state.copyWith(allDonationDocs: responseModel.data?.docs);
  //     } else {}
  //   } catch (e) {
  //     print(e);
  //   } finally {}
  // }

  Future<void> getMyDonation() async {
    print('Fetching saved posts...');

    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository.getMyCampaigns( ConversationState.self.id);
      state = state.copyWith(isLoading: false);
      print('API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.success) {
        MyDonationModel responseModel = MyDonationModel.fromJson(response.data);
        state = state.copyWith(myDonationDocs: responseModel.data?.docs);
      } else {}
    } catch (e) {
      print(e);
    } finally {}
  }


}

final donationVmProvider =
StateNotifierProvider<DonationVm, DonationState>((ref) {
  return DonationVm(WayaSecureDataSource(), DonationRepository(), ref, UploadFileRepository(), SuccessfulSetUpState());
});
