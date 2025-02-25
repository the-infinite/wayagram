import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/buyer_dispute/state/default.dart';

class BuyerDisputeNotifier extends StateNotifier<BuyerDisputeState> {
  BuyerDisputeNotifier(super.state);

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
  void reset() {}

  /// Controller function used to send the request to the server for posting this
  /// support ticket.
  Future<bool> sendDisputeTicket(String reason, String? details) async {
    // For now, just waste time.
    await Future.delayed(const Duration(milliseconds: 800));

    // For now, always return true.
    return true;
  }
}

final buyerDisputeProvider = StateNotifierProvider<BuyerDisputeNotifier, BuyerDisputeState>(
  (ref) => BuyerDisputeNotifier(BuyerDisputeState.initial),
);
