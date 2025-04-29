import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/conversation.dart';

class ConversationFeedWidget extends ConsumerWidget {
  //? Is this expanded?
  final bool isExpanded;

  //? Is this expanded?
  const ConversationFeedWidget({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationProvider);
    final notifier = ref.watch(conversationProvider.notifier);

    //? This is fine.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        isExpanded ? state.conversations.length : min(state.conversations.length, 3),
        (index) => ConversationWidget(
          index: index,
          chatId: state.conversations[index].id,
          notifier: ref.read(chatProvider(state.conversations[index].id).notifier),
          conversationNotifier: notifier,
          isInteractive: false,
        ),
      ),
    );
  }
}
