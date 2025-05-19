import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  SupportDisputeNotifier(this._roleShopRepository, this._uploadFileRepository) : super(SupportDisputeState.initial) {
    email.text = ConversationState.self.email ?? "";
    fullname.text = ConversationState.self.fullname;
    phone.text = ConversationState.self.phoneNumber ?? "";
  }

  // OUr support topics.
  List<Select> get disputeType {
    return [
      // This is fine too.
      Select(
        label: "Missing Item(s)",
        value: "missing-item",
      ),

      // This is fine.
      Select(
        label: "Damaged Item(s)",
        value: "damaged-item",
      ),

      // This is fine.
      Select(
        label: "Incorrect Item(s)",
        value: "damaged-item",
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
  Future<bool> sendDisputeTicket() async {
    try {
      String? media;
      File? myFile = proof.value;
      if (myFile != null) {
        media = await WayaUtils.uploadFile(file: myFile, repository: _uploadFileRepository);
      }

      final response = await _roleShopRepository.postDisputeDetails({
        "details": details.text,
        //  orderedItem: orderedItem,
        "userId": ConversationState.self.id,
        "metadata": {
          "merchantName": merchantName.text,
          "merchantLink": merchantLink.text,
          "productLink": productLink.text,
          "fullname": fullname.text,
          "email": email.text,
          "phone": phone.text,
          "type": typeNotifier.value,
        }, //optiona
        disputeType: "general",

        "media": media
      });

      if (response.success) {}
    } catch (error) {
      debugPrint(error.toString());
      //  return null;
    }
    return true;
  }
}

final supportDisputeProvider = StateNotifierProvider<SupportDisputeNotifier, SupportDisputeState>(
  (ref) {
    return SupportDisputeNotifier(ProfileRepo(), UploadFileRepository());
  },
);
