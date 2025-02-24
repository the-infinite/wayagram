
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/buyer/model/buyer_request_model.dart';
import 'package:wayagram/features/quotation/buyer/model/create_request_state_model.dart';
import 'package:wayagram/features/quotation/data/model/model.dart';
import 'package:wayagram/features/quotation/data/model/quotation_model.dart';
import 'package:wayagram/features/quotation/data/repo/quotation_repository.dart';


class CreateRequestVm extends StateNotifier<CreateRequestState> {
  final QuotationRepository _quotationRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;

  final _logger = getLogger('CreateRequestVm');

  CreateRequestVm(this._quotationRepository, this._localDataSource, this._secureDataSource ) : super(CreateRequestState());

  void selectStateOfPurchase(Select value) {
    state = state.copyWith(stateOfPurchase: value.value);
  }

  void selectState(Select value) {
    state = state.copyWith(deliveryState: value.value);
  }

  void selectCountry(Select value) {
    state = state.copyWith(lga: value.value);
  }

  void selectLGA(Select value) {
    state = state.copyWith(deliveryLga: value.value);
  }

  void selectBidTime(Select value) {
    state = state.copyWith(biddingStartTime: value.value);
  }

  void updateVendorSeeBuyRequest(bool value) {
    state = state.copyWith(vendorSeeBuyRequest: value);
  }

  void updateSkipAddress(bool value) {
    state = state.copyWith(skipAddress: value);
  }

  List<Select> restructuredCategory() {
    return categories.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.category);
    }).toList();
  }

  List<Select> restructuredBidTime() {
    return bidTimes.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.bidTime);
    }).toList();
  }

  List<Select> restructuredState() {
    return states.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.state);
    }).toList();
  }

  List<Select> restructuredCondition() {
    return productConditions.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.productCondition);
    }).toList();
  }

  List<Select> restructuredLga() {
    return lgas.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.lga);
    }).toList();
  }
  void focusChanged(bool hasFocus) {
    state = state.copyWith(isFocused: hasFocus);
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
         lastDate: DateTime(2050),
          initialDate: DateTime.now());

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(startDate: startDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> showDatePickerDialogTwo(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime(2050),
          initialDate: DateTime.now());

      if (response != null) {
        final endDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(endDate: endDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      print(error);
    }
  }

  void update(Select value, String name) {
    switch (name) {
      case "productCategory":
        state = state.copyWith(productCategory: value.value);
      case "productCondition":
        state = state.copyWith(productCondition: value.value);
      case "productType":
        state = state.copyWith(productType: value.value);
      case "pickUpOption":
        state = state.copyWith(pickUpOption: value.value);
      case "biddingStartTime":
        state = state.copyWith(biddingStartTime: value.value);
      case "stateOfPurchase":
        state = state.copyWith(stateOfPurchase: value.value);
      case "deliveryState":
        state = state.copyWith(deliveryState: value.value);
      case "deliveryLga":
        state = state.copyWith(deliveryLga: value.value);
      case "lga":
        state = state.copyWith(lga: value.value);
      default:
        state = state.copyWith(productColor: value.value);
    }
  }

  Future<void> createBuyerRequest(CreateBuyerRequest createBuyerRequest) async {
    try {

      state = state.copyWith(isLoading: true);
      final response = await _quotationRepository.createBuyerRequest(createBuyerRequest);
      if (response.success ) {
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getBuyerRequest() async {
    state = state.copyWith(isLoading: true);
    final response = await _quotationRepository!.getBuyerRequest();
    state = state.copyWith(isLoading: false);
    if (response.success) {
      BuyerRequestModel responseModel = BuyerRequestModel.fromJson(response.data);

      state = state.copyWith(buyerRequest:  responseModel.data?.buyerRequests);
      //print(state.productDescription);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

}

final quotationRepositoryProvider = Provider((ref) => QuotationRepository());

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createRequestProvider =
StateNotifierProvider<CreateRequestVm, CreateRequestState>((ref){
  final quotationRepository = ref.watch(quotationRepositoryProvider);
  final localDataSource = ref.watch(localDataSourceProvider);

  return CreateRequestVm(quotationRepository, localDataSource, WayaSecureDataSource());
});