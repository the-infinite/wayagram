import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/chat/state/chat.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/shop_dispute/data/model/dispute_response_model.dart';
import 'package:wayagram/features/shop/shop_dispute/data/repo/shop_dispute_repository.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

final sellerDisputeChatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) => ChatNotifier(ChatState.initial),
);

class States {
  final bool isLoading;
  final List<DisputeModel> disputes;
  final DisputeModel? dispute;
  final int totalSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasLoaded;
  final int page;
  final int? nextPage;

  States(
      {this.isLoading = false,
      this.disputes = const [],
      this.dispute,
      this.hasLoaded = false,
      this.page = 0,
      this.totalPages = 1,
      this.totalSize = 0,
      this.nextPage = 1,
      this.hasNextPage = false});

  States copyWith(
      {bool? isLoading,
      List<DisputeModel>? disputes,
      int? totalSize,
      int? totalPages,
      bool? hasNextPage,
      bool? hasLoaded,
      int? page,
      int? nextPage,
      DisputeModel? dispute}) {
    return States(
        isLoading: isLoading ?? this.isLoading,
        dispute: dispute ?? this.dispute,
        nextPage: nextPage ?? this.nextPage,
        page: page ?? this.page,
        hasLoaded: hasLoaded ?? this.hasLoaded,
        totalPages: totalPages ?? this.totalPages,
        totalSize: totalSize ?? this.totalSize,
        disputes: disputes ?? this.disputes);
  }
}

class DisputeVm extends StateNotifier<States> {
  final Ref ref;
  final ShopDisputeRepository repo;
  final UploadFileRepository _uploadFileRepository;
  DisputeVm(this._uploadFileRepository, this.repo, this.ref) : super(States());

  Future<void> getDisputes() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await repo.getUserDisputes();

      if (response.success) {
        DisputeResponseModel responseModel = DisputeResponseModel.fromJson(response.data);
        state = state.copyWith(
          disputes: responseModel.data.docs,
        );
        debugPrint(response.data.toString());
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // OUr support topics.
  List<Select> get disputeType {
    return [
      // This is fine too.
      Select(
        label: "Item not delivered",
        value: "Item not delivered",
      ),

      // This is fine.
      Select(
        label: "It is damaged or defective",
        value: "It is damaged or defective",
      ),

      // This is fine.
      Select(
        label: "Item received is different from the description",
        value: "Item received is different from the description",
      ),

      Select(
        label: "Others",
        value: "Others",
      ),
    ];
  }

  /// A helper function to open a shop dispute ticket
  Future<Map<String, String>?> openTicket(
      {required String reason, Order? orderedItem, String? sellerId, required String reference}) async {
    try {
      final response = await repo.openTicket(
          reasonCategory: reason,
          details: "details",
          orderedItem: orderedItem,
          userId: ConversationState.self.id,
          disputeType: "shop",
          sellerId: sellerId,
          reference: reference);

      String disputeId = '';
      String chatId = '';
      if (response.success) {
        debugPrint(response.data['data']['ticket']['id']);
        disputeId = response.data['data']['ticket']['id'];
        chatId = response.data['data']['ticket']['chatId'];
      }

      return {"disputeId": disputeId, "chatId": chatId};
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<bool> updateTicket(
      {required String reason,
      required String details,
      Order? orderedItem,
      String? sellerId,
      DocType? mediaDoc,
      required String toBeEscalatedBy,
      required String reference,
      required String disputeId}) async {
    try {
      state = state.copyWith(isLoading: true);
      String? media;
      if (mediaDoc != null) {
        media = await WayaUtils.uploadFile(file: mediaDoc.file!, repository: _uploadFileRepository);
      }
      final response = await repo.updateTicket(
          reasonCategory: reason,
          details: details,
          orderedItem: orderedItem,
          userId: ConversationState.self.id,
          disputeType: "shop",
          sellerId: sellerId,
          reference: reference,
          media: media,
          disputeId: disputeId);
      bool isSuccess = false;
      if (response.success) {
        await repo.escalate(id: disputeId, escalatedBy: toBeEscalatedBy);

        await getSDispute(id: disputeId);
        isSuccess = true;
        debugPrint(response.data['data']['ticket']['id']);
      }

      return isSuccess;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getSDispute({required String id}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await repo.getSingleDispute(id: id);

      if (response.success) {
        // DisputeResponseModel responseModel =
        //     DisputeResponseModel.fromJson(response.data);
        final ticket = DisputeModel.fromJson(response.data['data']);
        debugPrint(ticket.toString());
        state = state.copyWith(dispute: ticket);
        debugPrint(response.data.toString());
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final disputeVmProvider = StateNotifierProvider<DisputeVm, States>((ref) {
  return DisputeVm(UploadFileRepository(), ShopDisputeRepository(), ref);
});
