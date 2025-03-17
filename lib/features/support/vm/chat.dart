import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/state/chat.dart';
import 'package:wayagram/features/chat/vm/chat.dart';

final supportChatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ChatState.initial);
});
