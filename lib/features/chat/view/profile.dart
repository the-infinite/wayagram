import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/cache/chat.dart';

import 'profile/dispute.dart';
import 'profile/group.dart';
import 'profile/personal.dart';

class ChatProfilePage extends ConsumerStatefulWidget {
  static const route = "/conversation/chat/profile";
  final String chatId;

  // Construct.
  const ChatProfilePage({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatProfilePageState();
}

class _ChatProfilePageState extends ConsumerState<ChatProfilePage> {
  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(conversationProvider);
    final state = ref.watch(chatProvider);

    //? If this is after the state of this has been reset.
    if (state.chat == null) return const SizedBox();

    //? If this is a group chat.
    if (state.chat!.chatType == ChatType.group) {
      return ValueListenableBuilder(
        valueListenable: wayaChatsCache,
        builder: (context, redraws, _) => GroupChatProfilePage(
          chat: wayaChatsCache.getCachedData(state.chat!.id)!,
          ref: ref,
        ),
      );
    }

    //? If this is a dispute chat.
    if (state.chat!.chatType == ChatType.dispute) {
      return ValueListenableBuilder(
        valueListenable: wayaChatsCache,
        builder: (context, redraws, _) => DisputeChatProfilePage(
          chat: wayaChatsCache.getCachedData(state.chat!.id)!,
          ref: ref,
        ),
      );
    }

    //? This is fine.
    return ValueListenableBuilder(
      valueListenable: wayaChatsCache,
      builder: (context, redraws, _) => PersonalChatProfilePage(
        chat: wayaChatsCache.getCachedData(state.chat!.id)!,
        ref: ref,
      ),
    );
  }
}
