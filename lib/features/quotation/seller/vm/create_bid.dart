import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/quotation/data/model/model.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class CreateBidState {
  //? Reference.
  final BuyRequestModel? request;

  //? First, for the overview and specifications.
  final String? description;
  final String? condition;
  final List<File>? images;

  //? Second, pricing for delivery.
  final String? shopId;
  final double? unitPrice;
  final double? deliveryCharge;
  final DateTime? readyDate;

  // Construct.
  CreateBidState({
    required this.request,
    required this.description,
    required this.condition,
    required this.images,
    required this.unitPrice,
    required this.shopId,
    required this.deliveryCharge,
    required this.readyDate,
  });

  /// Creates a new instance of [CreateBidState] with updated properties.
  ///
  /// Takes optional parameters to update specific fields while keeping the values
  /// of non-specified fields unchanged from the current instance.
  ///
  /// Returns a new [CreateBidState] instance with the updated values.
  CreateBidState copyWith({
    BuyRequestModel? request,
    String? description,
    List<File>? images,
    String? shopId,
    String? condition,
    double? unitPrice,
    double? deliveryCharge,
    DateTime? readyDate,
  }) {
    return CreateBidState(
      request: request ?? this.request,
      description: description ?? this.description,
      images: images ?? this.images,
      shopId: shopId ?? this.shopId,
      condition: condition ?? this.condition,
      unitPrice: unitPrice ?? this.unitPrice,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      readyDate: readyDate ?? this.readyDate,
    );
  }
}

class CreateBidVm extends StateNotifier<CreateBidState> {
  CreateBidVm(BuyRequestModel request)
      : super(CreateBidState(
          request: request,
          description: null,
          images: null,
          shopId: null,
          condition: null,
          unitPrice: null,
          deliveryCharge: null,
          readyDate: null,
        ));

  /// Returns a list of valid product conditions available for selection.
  /// 
  /// The list contains [Select] objects representing different conditions 
  /// that can be assigned to a product in the quotation/bidding process.
  List<Select> get validConditions => productConditions
      .asMap()
      .entries
      .map((entries) => Select(value: entries.value.id.toString(), label: entries.value.productCondition))
      .toList();

  /// Resets all bid-related states to their initial values.
  /// This includes clearing any form inputs, validation errors, and loading states.
  void reset() {
    state = CreateBidState(
      request: null,
      description: null,
      images: null,
      shopId: null,
      condition: null,
      unitPrice: null,
      deliveryCharge: null,
      readyDate: null,
    );
  }

  /// Used to update all of the overview and specifications.
  void updateSpecifications(
    String description,
    String condition,
    List<File> images,
  ) {
    state = state.copyWith(
      description: description,
      condition: condition,
      images: images,
    );
  }

  /// Used to update all of the configuration for pricing and delivery.
  void updatePricingAndDelivery(
    String shopId,
    double unitPrice,
    double? deliveryCharge,
    DateTime? readyDate,
  ) {
    state = state.copyWith(
      shopId: shopId,
      deliveryCharge: deliveryCharge,
      unitPrice: unitPrice,
      readyDate: readyDate,
    );
  }
}

typedef CreateBidProvider = StateNotifierProvider<CreateBidVm, CreateBidState>;

/// Creates a [StateNotifierProvider] for managing bid creation state.
///
/// Takes a [BuyRequestModel] parameter [request] which contains the details
/// of the buy request that the bid is being created for.
///
/// Returns a [StateNotifierProvider] that provides access to the [CreateBidVm]
/// view model and [CreateBidState] state.
CreateBidProvider createBidProviderFactory(BuyRequestModel request) => CreateBidProvider((ref) => CreateBidVm(request));
