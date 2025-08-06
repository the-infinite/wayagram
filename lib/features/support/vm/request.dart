import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/support/state/request.dart';

class SupportRequestNotifier extends StateNotifier<SupportRequestState> {
  final ProfileRepo _roleProfileRepository;
  final email = TextEditingController();
  final fullname = TextEditingController();
  final phone = TextEditingController();
  final details = TextEditingController();
  final topicNotifier = ValueNotifier<Select?>(null);

  // Construct.
  SupportRequestNotifier(this._roleProfileRepository)
      : super(SupportRequestState.initial) {
    email.text = ConversationState.self.email ?? "";
    fullname.text = ConversationState.self.fullname;
    phone.text = ConversationState.self.phoneNumber ?? "";
  }

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

  void reset() {
    /*  email.clear();
    fullname.clear();
    phone.clear(); */
    details.clear();
    topicNotifier.value = null;
  }

  /// Controller function used to send the request to the server for posting this
  /// support ticket.
  Future<String?> sendRequestTicket(
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    var _ = {
      "topic": topicNotifier.value?.label ?? "",
      "details": details.text,
      "fullName": fullname.text,
      "email": email.text,
      "phoneNumber": phone.text
    };

    final response = await _roleProfileRepository.postSupportDetails({
      "topic": topicNotifier.value?.label ?? "",
      "details": details.text,
      "fullName": fullname.text,
      "email": email.text,
      "phoneNumber": phone.text
    });
    isLoading.value = false;
    if (response.success) {
      return response.data?['data']['ticketId'] ?? "ticketID";
    } else {
      return null;
    }
  }
}

final supportRequestProvider =
    StateNotifierProvider<SupportRequestNotifier, SupportRequestState>(
  (ref) {
    final profileRepo = ref.watch(profileRepositoryProvider);
    return SupportRequestNotifier(profileRepo);
  },
);
