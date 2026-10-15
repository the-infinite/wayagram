import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/support/state/dispute.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

class SupportDisputeNotifier extends StateNotifier<SupportDisputeState> {
  final ProfileRepo _roleShopRepository;
  final UploadFileRepository _uploadFileRepository;
  final fullname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final typeNotifier = ValueNotifier<Select?>(null);
  final details = TextEditingController();
  final merchantName = TextEditingController();
  final merchantLink = TextEditingController();
  final productLink = TextEditingController();
  final proof = ValueNotifier<File?>(null);

  // Construct.
  //SupportDisputeNotifier(super.state);

  SupportDisputeNotifier(this._roleShopRepository, this._uploadFileRepository)
      : super(SupportDisputeState.initial) {
    email.text = ConversationState.self.email ?? "";
    fullname.text = ConversationState.self.fullname;
    phone.text = ConversationState.self.phoneNumber ?? "";
  }

  // OUr support topics.
  List<Select> get disputeType {
    return [
      // This is fine too.
      Select(
        label: "Shop",
        value: "Shop",
      ),

      // This is fine too.
      Select(
        label: "Quotation",
        value: "Quotation",
      ),
      // This is fine too.
      Select(
        label: "Transaction",
        value: "Transaction",
      ),
      // This is fine too.
      Select(
        label: "Support",
        value: "Support",
      ),

      // This is fine too.
      Select(
        label: "General",
        value: "General",
      ),
    ];
  }

  /// Helper used to reset everything in this form.
  void reset() {
    //fullname.clear();
    //email.clear();
    //phone.clear();
    typeNotifier.value = null;
    details.clear();
    merchantName.clear();
    merchantLink.clear();
    productLink.clear();
    proof.value = null;
  }

  /// Controller function used to send the request to the server for posting this
  /// support ticket.
  Future<String?> sendDisputeTicket(bool isShopSelected) async {
    try {
      String? media;
      File? myFile = proof.value;
      if (myFile != null) {
        media = await WayaUtils.uploadFile(
            file: myFile, repository: _uploadFileRepository);
      }

      final response = await _roleShopRepository.postDisputeDetails({
        "details": details.text,
        "reasonCategory": details.text,
        "userId": ConversationState.self.id,
        "metadata": {
          if (isShopSelected) "merchantName": merchantName.text,
          if (isShopSelected) "merchantID": merchantLink.text,
          if (isShopSelected) "productId": productLink.text,
          "fullname": fullname.text,
          "email": email.text,
          "phone": phone.text,
          //  "type": typeNotifier.value?.label.toLowerCase() ?? "general",
        }, //optiona

        "disputeType": typeNotifier.value?.label.toLowerCase() ?? "general",
        if ((isShopSelected ||
                typeNotifier.value?.label.toLowerCase() == "quotation") &&
            merchantLink.text.trim().isEmpty)
          "sellerId": merchantLink.text,
        "media": media
      });

      if (response.success) {
        return response.data?['data']['ticketBody']['ticketId'] ?? "ticketID";
      } else {
        WayaSnackBar.showToast(response.data["message"]);
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
      //  return null;
    }
    return null;
  }
}

final supportDisputeProvider =
    StateNotifierProvider<SupportDisputeNotifier, SupportDisputeState>(
  (ref) {
    final profileRepo = ref.watch(profileRepositoryProvider);
    final uploadFileRepo = ref.watch(uploadFileRepositoryProvider);

    return SupportDisputeNotifier(profileRepo, uploadFileRepo);
  },
);
