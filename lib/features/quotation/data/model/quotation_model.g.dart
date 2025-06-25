// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBuyerRequest _$CreateBuyerRequestFromJson(Map<String, dynamic> json) =>
    CreateBuyerRequest(
      buyerId: json['buyerId'] as String,
      productName: json['productName'] as String,
      brand: json['brand'] as String?,
      category: json['category'] as String,
      condition: json['condition'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as String,
      bidStart: json['bidStart'] as String,
      bidEnd: json['bidEnd'] as String,
      deliveryDetails: json['deliveryDetails'] as String,
      stateOfPurchase: json['stateOfPurchase'] as String,
      lga: json['lga'] as String,
      vendorsCanSeeBidFromAnyDistance:
          json['vendorsCanSeeBidFromAnyDistance'] as String,
      deliveryType: json['deliveryType'] as String,
      deliveryAddress: json['deliveryAddress'] as String?,
      deliveryState: json['deliveryState'] as String?,
      deliveryLga: json['deliveryLga'] as String?,
      maxBidAmount: (json['maxBidAmount'] as num).toDouble(),
      bidStartingAmount: (json['bidStartingAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$CreateBuyerRequestToJson(CreateBuyerRequest instance) =>
    <String, dynamic>{
      'buyerId': instance.buyerId,
      'productName': instance.productName,
      'brand': instance.brand,
      'category': instance.category,
      'condition': instance.condition,
      'description': instance.description,
      'quantity': instance.quantity,
      'bidStart': instance.bidStart,
      'bidEnd': instance.bidEnd,
      'deliveryDetails': instance.deliveryDetails,
      'stateOfPurchase': instance.stateOfPurchase,
      'lga': instance.lga,
      'vendorsCanSeeBidFromAnyDistance':
          instance.vendorsCanSeeBidFromAnyDistance,
      'deliveryType': instance.deliveryType,
      'deliveryAddress': instance.deliveryAddress,
      'deliveryState': instance.deliveryState,
      'deliveryLga': instance.deliveryLga,
      'maxBidAmount': instance.maxBidAmount,
      'bidStartingAmount': instance.bidStartingAmount,
    };
