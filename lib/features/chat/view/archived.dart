import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/conversation.dart';
import 'package:wayagram/features/chat/widget/search.dart';
import 'package:wayagram/shared/features/chat/widget/empty_conversation.dart';

class ArchivedChatsScreen extends ConsumerWidget {
  static const route = "/chats/archived";

  const ArchivedChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //? This is fine.
    final notifier = ref.watch(conversationProvider.notifier);
    final state = ref.watch(conversationProvider);

    //? This is the case.
    return PopScope(
      onPopInvokedWithResult: (isPopped, _) {
        //? We are no longer in archived.
        if (!isPopped) return;
        notifier.setArchived(false);
        notifier.dismissOverlay();
      },
      child: WayaScaffold(
        title: "Archived Chats",
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.zero,
        onRefresh: () async {
          notifier.dismissOverlay();
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
            if (state.archivedResults.isEmpty && state.hasLoadedArchived) ...[
              // Space.
              Gap(160.h),

              // The empty widget.
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: EmptyConversationsWidget(),
                ),
              ),

              // Space.
              Gap(60.h),
            ] else
              ...List.generate(
                state.archivedResults.length,
                (index) => ConversationWidget(
                  index: index,
                  chatId: state.archivedResults[index].id,
                  notifier: ref.read(chatProvider(state.archivedResults[index].id).notifier),
                  conversationNotifier: notifier,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
