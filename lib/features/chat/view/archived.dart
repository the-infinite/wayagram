import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/conversation.dart';
import 'package:wayagram/features/chat/widget/search.dart';

class ArchivedChatsScreen extends ConsumerWidget {
  static const route = "/chats/archived";

  const ArchivedChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //? This is fine.
    final notifier = ref.watch(conversationProvider.notifier);
    final chatNotifier = ref.watch(chatProvider.notifier);
    final state = ref.watch(conversationProvider);

    //? This is the case.
    return PopScope(
      onPopInvokedWithResult: (isPopped, _) {
        //? We are no longer in archived.
        if (isPopped) notifier.setArchived(false);
      },
      child: WayaScaffold(
        title: "Archived Chats",
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.zero,
        onRefresh: () async {
          await notifier.getArchivedChats(false);
        },
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //? First, the search bar for the chats.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchConversationWidget(
                onTextChange: (value) {
                  notifier.setFilter(value);
                },
                isArchived: true,
              ),
            ),

            // Some space.
            const Gap(10),

            //? Now, the pinned chats.
            ...List.generate(
              state.archivedResults.length,
              (index) => ConversationWidget(
                index: index,
                chat: state.archivedResults[index],
                notifier: chatNotifier,
                conversationNotifier: notifier,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
