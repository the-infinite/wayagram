import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/repo/message_repository.dart';
import 'package:wayagram/features/chat/state/chat.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/shop/shop_dispute/data/repo/shop_dispute_repository.dart';

final supportChatProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final messageRepo = ref.watch(messageRepositoryProvider);
  final shopDisp = ref.watch(shopDisputeRepositoryProvider);
  return ChatNotifier(ChatState.initial, messageRepo, shopDisp);
});
