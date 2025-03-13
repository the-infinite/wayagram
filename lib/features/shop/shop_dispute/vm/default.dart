import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/state/chat.dart';
import 'package:wayagram/features/chat/vm/chat.dart';

final sellerDisputeChatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) => ChatNotifier(ChatState.initial),
);
