import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/support/state/request.dart';

class SupportRequestNotifier extends StateNotifier<SupportRequestState> {
  final email = TextEditingController();
  final fullname = TextEditingController();
  final phoneNumber = TextEditingController();
  final details = TextEditingController();
  final topicNotifier = ValueNotifier<Select?>(null);

  // Construct.
  SupportRequestNotifier(super.state);

  // OUr support topics.
  List<Select> get supportTopics {
    return [
      // This is fine too.
      Select(
        label: "Transaction Error",
        value: "transaction-error",
      ),

      // This is fine.
      Select(
        label: "Product Misrepresentation",
        value: "product-misrepresentation",
      ),
    ];
  }

  /// Helper used to reset everything in this form.
  void reset() {
    email.clear();
    fullname.clear();
    phoneNumber.clear();
    details.clear();
    topicNotifier.value = null;
  }

  /// Controller function used to send the request to the server for posting this
  /// support ticket.
  Future<bool> sendRequestTicket() async {
    // For now, just waste time.
    await Future.delayed(const Duration(milliseconds: 800));

    // For now, always return true.
    return true;
  }
}

final supportRequestProvider = StateNotifierProvider<SupportRequestNotifier, SupportRequestState>(
  (ref) {
    return SupportRequestNotifier(SupportRequestState.initial);
  },
);
