import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/data/repo/donation_repository.dart';
import 'package:wayagram/features/donation/donation_modal/donation_modal.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/applied_donation_model.dart';
import 'package:wayagram/features/donation/model/create_donation_response.dart';
import 'package:wayagram/features/donation/model/donation_category_model.dart';
import 'package:wayagram/features/donation/model/kyc_model.dart';
import 'package:wayagram/features/donation/model/login_response.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/state/donation_state.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

class DonationVm extends StateNotifier<DonationState> {
  final Ref ref;
  final DonationRepository _donationRepository;
  final UploadFileRepository _uploadFileRepository;
  final _logger = getLogger('DonationVm');
  DonationVm(this._donationRepository, this.ref, this._uploadFileRepository)
      : super(DonationState()) {
    state = state.copyWith(title: TextEditingController(text: ''));
    state = state.copyWith(description: TextEditingController(text: ''));
    state = state.copyWith(solution: TextEditingController(text: ''));
    state = state.copyWith(statement: TextEditingController(text: ''));
    state = state.copyWith(targetAmount: TextEditingController(text: ''));
    state =
        state.copyWith(minimumDonationAmount: TextEditingController(text: ''));
    state = state.copyWith(details: TextEditingController(text: ''));
  }

  void reset() {
    state = DonationState();
  }

  void updateAmountRaised(bool value) {
    state = state.copyWith(showAmountRaised: value);
  }

  void updateNumberOfDonors(bool value) {
    state = state.copyWith(showNumberOfDonors: value);
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

  void selectCategory(Select value) {
    state = state.copyWith(category: value.value);
  }

  void addFile(File file) {
    state = state.copyWith(donationImage: [
      DocType(
          file: file, type: "donation-image", name: file.path.split('/').last)
    ]);
  }

  void removeFile() {
    List<DocType> e = List.from(state.donationImage);
    e = e.where((i) => i.type != 'donation-image').toList();
    state = state.copyWith(donationImage: e);

    print("efwefw");
    print(state);
  }

  void selectDonationCategory(String value) {
    state = state.copyWith(category: value.toLowerCase());
  }

  List<Select> donationCategory = [
    Select(label: 'School fees', value: 'School fees'),
    Select(label: 'Food', value: 'Food'),
  ];

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

  Future<void> fetchCategory() async {
    try {
      final response = await _donationRepository.getDonationCategory();

      if (response.success) {
        DonationCategoryModel responseModel =
            DonationCategoryModel.fromJson(response.data);

        final List<Select>? categories = responseModel.data?.docs?.map((val) {
          return Select(
              label: '${val.title?.capitalizeFirst}', value: '${val.id}');
        }).toList();
        state = state.copyWith(categories: categories);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> makeDonation(
      String campaignId, int amount, String message, ctx) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await _donationRepository.donate(campaignId, amount, message);
      state = state.copyWith(isLoading: false);
      WayaNav.goBack();
      if (response.success && ctx.mounted) {
        WayaUtils.showModalSheet(ctx, child: DonationGenerosityModal());
        _logger.i(response.data['data']);
      } else if (response.data['error'] == 'Insufficient wallet balance') {
        WayaUtils.showModalSheet(ctx, child: DonationUnSuccessfulModal());

        print('CHECKINGGGGG');
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<PaginatedResult<AllDonationDocs>?> getAllDonation(
      {required int page}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository.getAllCampaigns(page);
      List<AllDonationDocs>? fetchAllDonations = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        AllDonationModel responseModel =
            AllDonationModel.fromJson(response.data);
        fetchAllDonations = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(allDonationDocs: fetchAllDonations);
        state = state.copyWith(allDonationDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(
          hasNextPage: hasNextPage!, items: fetchAllDonations!);
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  // Future<PaginatedResult<AllDonationDocs>?> getDonatedDonation({required int page}) async {
  //
  //   try{
  //     state = state.copyWith(isLoading: true);
  //     final response = await _donationRepository.getDonatedDonations(page);
  //     List<AllDonationDocs>? fetchAllDonations= [];
  //     bool? hasNextPage = false;
  //     state = state.copyWith(isLoading: false);
  //     if (response.success) {
  //       AllDonationModel responseModel = AllDonationModel.fromJson(response.data);
  //       fetchAllDonations = responseModel.data?.docs;
  //       hasNextPage = responseModel.data?.hasNextPage;
  //       state = state.copyWith(appliedDonationDocs: fetchAllDonations);
  //       state = state.copyWith(appliedDonationDocs: responseModel.data?.docs);
  //     } else {
  //       state = state.copyWith(isLoading: false);
  //     }
  //     return PaginatedResult(hasNextPage: hasNextPage!, items:  fetchAllDonations!);
  //   }catch (e){
  //     _logger.e(e);
  //   }finally {
  //     state = state.copyWith(isLoading: false);
  //   }
  // }

  Future<void> getDonatedDonation(int page) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository.getDonatedDonations(page);
      state = state.copyWith(isLoading: false);
      print('API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.success) {
        AppliedDonationModel responseModel =
            AppliedDonationModel.fromJson(response.data);
        state = state.copyWith(appliedDonationDocs: responseModel.data?.docs);
      } else {}
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<bool> verifyWalletPin(String pin, ctx) async {
    final response = await _donationRepository.confirmWalletPin(
        ConfirmWalletPin(userId: ConversationState.self.id, pin: pin));
    if (response.success) {
      return true;
    } else if (response.data['error'] == 'User hasn\'t set wallet pin yet') {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            'Kindly set your wallet pin',
            style: TextStyle(
                fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
          ),
          backgroundColor: WayaColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      return false;
    }
    return false;
  }

  Future<void> editCampaign(ctx, amount, campaignId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await _donationRepository.updateDonation(amount, campaignId);
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Minimum amount updated successfully!',
              style: TextStyle(
                  fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
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

  Future<void> onSubmit(title, description, solution, impact, targetAmount,
      minimumAmount, privacy, expirationDate, image, startDate, category,
      {required BuildContext context}) async {
    try {
      // validate image
      if (state.donationImage.isEmpty) {
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
      final image = state.donationImage[0].file == null
          ? state.donationImage[0].url
          : await WayaUtils.uploadFile(
              file: state.donationImage[0].file!,
              repository: _uploadFileRepository);

      final response = await _donationRepository.createCampaign(
          title,
          description,
          solution,
          impact,
          targetAmount,
          minimumAmount,
          privacy,
          expirationDate,
          image!,
          startDate,
          category);

      if (response.success) {
        if (context.mounted) {
          CreateDonationResponse createDonationResponse =
              CreateDonationResponse.fromJson(response.data);
          WayaUtils.showModalSheet(
            context,
            child: DonationSuccessModal(
              url: '${createDonationResponse.data?.url}',
            ),
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

  Future<void> getMyDonation() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response =
          await _donationRepository.getMyCampaigns(ConversationState.self.id);
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

  Future<void> getHostedDonation() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository
          .getHostedDonation(ConversationState.self.id);
      state = state.copyWith(isLoading: false);
      print('API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.success) {
        MyDonationModel responseModel = MyDonationModel.fromJson(response.data);
        //state = state.copyWith(myDonationDocs: responseModel.data?.docs);
        state = state.copyWith(approvedDonations: responseModel.data?.docs);
      } else {}
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> getAppliedDonation() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository
          .getAppliedDonation(ConversationState.self.id);
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

  Future<void> getRejectedDonation() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository
          .getRejectedDonation(ConversationState.self.id);
      state = state.copyWith(isLoading: false);
      print('API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.success) {
        MyDonationModel responseModel = MyDonationModel.fromJson(response.data);
        //state = state.copyWith(myDonationDocs: responseModel.data?.docs);
        state = state.copyWith(rejectedDonations: responseModel.data?.docs);
      } else {}
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> getMyKYC() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response =
          await _donationRepository.getMyKYC(ConversationState.self.id);
      state = state.copyWith(isLoading: false);
      print('API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.success) {
        KycModel responseModel = KycModel.fromJson(response.data);
        LoginResponse loginResponse = LoginResponse.fromJson(response.data);
        state = state.copyWith(
            kycStatus: responseModel.data?.status,
            accountType: loginResponse.data?.userdata?.business,
            kycMessage: responseModel.message);
      } else {}
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> getSingleDonation(String campaignId) async {
    print('Fetching saved posts...');

    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _donationRepository.getMyCampaigns(campaignId);
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

  Future<MyDonationDocs?> getSingleCampaign(String id) async {
    try {
      final response = await _donationRepository.getSingleCampaign(id);
      MyDonationDocs? donation;
      if (response.success) {
        donation = MyDonationDocs.fromJson(response.data['data']);
      }

      return donation;
    } catch (error) {
      print(error);
      return null;
    }
  }
}

final donationVmProvider =
    StateNotifierProvider<DonationVm, DonationState>((ref) {
  return DonationVm(DonationRepository(), ref, UploadFileRepository());
});
