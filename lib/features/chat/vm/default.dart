import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/state/default.dart';

class ConversationVm extends StateNotifier<ConversationState> {
  ConversationVm(super.state);
}

/// The state provider for conversations.
final conversationProvider = StateNotifierProvider<ConversationVm, ConversationState>((ref) {
  return ConversationVm(ConversationState.initial);
});
