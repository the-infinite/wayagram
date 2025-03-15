import 'dart:convert';

import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';

class DisputeResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final DataModel data;

  DisputeResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory DisputeResponseModel.fromJson(Map<String, dynamic> json) {
    return DisputeResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: DataModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

class DataModel {
  final List<DisputeModel> docs;

  DataModel({required this.docs});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      docs: (json['docs'] as List).map((e) => DisputeModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docs': docs.map((e) => e.toJson()).toList(),
    };
  }
}

class DisputeModel {
  final String id;
  final String userId;
  final String status;
  final String disputeType;
  final String? reference;
  final String? escalatedBy;
  final String sellerId;
  final String chatId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TicketBodyModel ticketBody;

  DisputeModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.disputeType,
    this.reference,
    this.escalatedBy,
    required this.sellerId,
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    required this.ticketBody,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      id: json['id'],
      userId: json['userId'],
      status: json['status'],
      disputeType: json['disputeType'],
      reference: json['reference'],
      escalatedBy: json['escalatedBy'],
      sellerId: json['sellerId'],
      chatId: json['chatId'],
       createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      ticketBody: TicketBodyModel.fromJson(json['ticketBody']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status,
      'disputeType': disputeType,
      'reference': reference,
      'escalatedBy': escalatedBy,
      'sellerId': sellerId,
      'chatId': chatId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
     'ticketBody': ticketBody.toJson(),
    };
  }
}

class TicketBodyModel {
  final String id;
  final String ticketId;
  final String reasonCategory;
  final String details;
  final dynamic media;
  final TicketMetadata metadata;
  final String createdAt;
  final String updatedAt;

  TicketBodyModel({
    required this.id,
    required this.ticketId,
    required this.reasonCategory,
    required this.details,
    this.media,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketBodyModel.fromJson(Map<String, dynamic> json) {
    return TicketBodyModel(
      id: json['id'],
      ticketId: json['ticketId'],
      reasonCategory: json['reasonCategory'],
      details: json['details'],
      media: json['media'],
      metadata: TicketMetadata.fromJson(json['metadata']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketId': ticketId,
      'reasonCategory': reasonCategory,
      'details': details,
      'media': media,
      'metadata': metadata.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class TicketMetadata {
  final dynamic orderedItem;


  TicketMetadata({
    required this.orderedItem,
    
  });

  factory TicketMetadata.fromJson(Map<String, dynamic> json) {
    return TicketMetadata(
      orderedItem: json['orderedItem'],
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderedItem': orderedItem,
      
    };
  }
}
