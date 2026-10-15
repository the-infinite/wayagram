import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/buyer/model/buyer_request_model.dart';
import 'package:wayagram/features/quotation/buyer/model/create_request_state_model.dart';
import 'package:wayagram/features/quotation/data/model/model.dart';
import 'package:wayagram/features/quotation/data/model/quotation_model.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/repo/quotation_repository.dart';
import 'package:wayagram/shared/features/shop/resource/shop_resource.dart';

class CreateRequestVm extends StateNotifier<CreateRequestState> {
  final QuotationRepository _quotationRepository;

  CreateRequestVm(this._quotationRepository) : super(CreateRequestState());

  void clear() {
    state = CreateRequestState(
      productCategory: '',
      productCondition: '',
      productType: '',
      productColor: '',
      productDescription: null,
      productName: null,
      productImage: null,
      startDate: '',
      endDate: '',
      dateIsoFormat: '',
      deliveryState: '',
      deliveryLga: '',
      lga: '',
      stateOfPurchase: '',
      pickUpOption: 'No',
      biddingStartTime: '',
      vendorSeeBuyRequest: false,
      skipAddress: false,
    );
  }

  void selectStateOfPurchase(Select value) {
    state = state.copyWith(stateOfPurchase: value.value);
  }

  void setPickupOption(String value) {
    state = state.copyWith(pickUpOption: value);
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
    return ShopResource.categories.asMap().entries.map((entries) {
      return Select(value: entries.value.name, label: entries.value.name);
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
          value: entries.value.id.toString(),
          label: entries.value.productCondition);
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
        firstDate: DateTime.now(),
        lastDate: DateTime.now(),
        initialDate: DateTime.now(),
      );

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state =
            state.copyWith(startDate: startDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> showDatePickerDialogTwo(BuildContext context) async {
    try {
      final moment = DateTime.now();
      final response = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(moment.year + 1),
        initialDate: moment,
      );

      if (response != null) {
        final endDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(endDate: endDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
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

  Future<BuyRequestModel?> createBuyerRequest(
      CreateBuyerRequest createBuyerRequest) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await _quotationRepository.createBuyerRequest(createBuyerRequest);

      //? Since this can be fine.
      if (response.success) {
        return BuyRequestModel.fromJson(response.data['data']);
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
        return null;
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }

    return null;
  }

  Future<void> getBuyerRequest() async {
    state = state.copyWith(isLoading: true);
    final response = await _quotationRepository.getBuyerRequest();
    state = state.copyWith(isLoading: false);
    if (response.success) {
      BuyerRequestModel responseModel =
          BuyerRequestModel.fromJson(response.data);

      state = state.copyWith(buyerRequest: responseModel.data?.buyerRequests);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}

final createRequestProvider =
    StateNotifierProvider<CreateRequestVm, CreateRequestState>(
  (ref) {
    final quotationRepository = ref.watch(quotationRepositoryProvider);
    return CreateRequestVm(quotationRepository);
  },
);
