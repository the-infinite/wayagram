import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/support/state/dispute.dart';

class SupportDisputeNotifier extends StateNotifier<SupportDisputeState> {
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
  SupportDisputeNotifier(super.state);

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
    fullname.clear();
    email.clear();
    phone.clear();
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
    // For now, just waste time.
    await Future.delayed(const Duration(milliseconds: 800));

    // For now, always return true.
    return true;
  }
}

final supportDisputeProvider = StateNotifierProvider<SupportDisputeNotifier, SupportDisputeState>(
  (ref) {
    return SupportDisputeNotifier(SupportDisputeState.initial);
  },
);
