import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/controller/socket.dart';
import 'package:wayagram/shared/features/chat/modal/start_conversation.dart';
import 'package:wayagram/features/chat/view/archived.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/conversation.dart';
import 'package:wayagram/features/chat/widget/search.dart';
import 'package:wayagram/shared/features/chat/widget/empty_conversation.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  late final chatNotifier = ref.watch(chatProvider.notifier);
  late final notifier = ref.watch(conversationProvider.notifier);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await WayaSocketController.instance.connect(ref);
        await WayaSocketController.instance.listen();
        notifier.getChats(true);
        notifier.getArchivedChats(true);
      },
    );

    //? This is fine.
    super.initState();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await WayaSocketController.instance.disconnect();
        await WayaSocketController.instance.connect(ref);
        await WayaSocketController.instance.listen();
        notifier.getChats(true);
        notifier.getArchivedChats(true);
      },
    );

    //? This is fine.
    super.reassemble();
  }

  /// Helper function used to initiate a conversation with a new person or group.
  void _startConversation() async {
    final result = await WayaUtils.showModalSheet(
      context,
      child: StartConversationModal(),
    );

    //? Do nothing.
    if (result == null) return;
  }

  @override
  Widget build(BuildContext context) {
    final conversationState = ref.watch(conversationProvider);

    //? When watch this one
    return WayaScaffold(
      isLoading: false,
      isScrollable: conversationState.conversations.isNotEmpty,
      onRefresh: () async {
        await notifier.getChats(true);
        await notifier.getArchivedChats(true);
      },
      automaticallyImplyLeading: false,
      backgroundColor: WayaColors.white,
      padding: const EdgeInsets.only(bottom: 20),
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: double.infinity,
        backgroundColor: WayaColors.white,
        surfaceTintColor: Colors.transparent,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //? First, the title.
            Container(
              height: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Messages",
                style: WayaTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),

            // Next, boundless space.
            const Spacer(),

            //? Second, the archived chats button.
            InkWell(
              borderRadius: BorderRadius.circular(200),
              splashColor: WayaColors.primary.withAlpha(30),
              focusColor: WayaColors.primary.withAlpha(30),
              highlightColor: WayaColors.primary.withAlpha(30),
              onTap: () {
                notifier.setArchived(true);
                WayaNav.toNamed(ArchivedChatsScreen.route);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: WayaColors.primary50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //? First, the reply icon.
                    Icon(
                      CupertinoIcons.archivebox_fill,
                      color: WayaColors.primary,
                      size: 18,
                    ),

                    // Some space.
                    const Gap(5),

                    //? Second, the text for replying.
                    Text(
                      "Archived chats",
                      style: WayaTextStyles.bodySemiBold.copyWith(
                        color: WayaColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Some space.
            const Gap(10),

            //? Third and last, the start conversation button.
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IntrinsicHeight(
                child: WayaButton(
                  callback: _startConversation,
                  height: null,
                  centerWidget: WayaAssets.icons.cPlus.svg(
                    color: WayaColors.white,
                    height: 24,
                    width: 24,
                  ),
                  color: WayaColors.primary,
                  horizontalPadding: 10,
                  verticalPadding: 10,
                ),
              ),
            ),
          ],
        ),
      ),
      body: conversationState.conversations.isEmpty && conversationState.hasLoaded
          ? SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: EmptyConversationsWidget(
                  showButton: true,
                ),
              ),
            )
          : Column(
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
                  ),
                ),

                // Some space.
                const Gap(20),

                //? If the chats are filtered...
                if (conversationState.searchFilter.isNotEmpty) ...[
                  //* The title comes first.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Search results",
                      style: WayaTextStyles.titleMedium.copyWith(
                        color: WayaColors.greyColor500,
                      ),
                    ),
                  ),

                  // Some space.
                  const Gap(5),

                  //? Now, the pinned chats.
                  ...List.generate(
                    conversationState.results.length,
                    (index) => ConversationWidget(
                      index: index,
                      chat: conversationState.results[index],
                      notifier: chatNotifier,
                      conversationNotifier: notifier,
                    ),
                  ),
                ] else ...[
                  //? Second, the pinned chats.
                  if (conversationState.pinned.isNotEmpty) ...[
                    //* The title comes first.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Pinned Chats",
                        style: WayaTextStyles.titleMedium.copyWith(
                          color: WayaColors.greyColor500,
                        ),
                      ),
                    ),

                    // Some space.
                    const Gap(5),

                    //? Now, the pinned chats.
                    ...List.generate(
                      conversationState.pinned.length,
                      (index) => ConversationWidget(
                        index: index,
                        chat: conversationState.pinned[index],
                        notifier: chatNotifier,
                        conversationNotifier: notifier,
                      ),
                    ),

                    // Finally, more space.
                    const Gap(20),
                  ],

                  //* The title comes first.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "All Chats",
                      style: WayaTextStyles.titleMedium.copyWith(
                        color: WayaColors.greyColor500,
                      ),
                    ),
                  ),

                  // Some space.
                  const Gap(5),

                  //? Now, the pinned chats.
                  ...List.generate(
                    conversationState.unpinned.length,
                    (index) => ConversationWidget(
                      index: index,
                      chat: conversationState.unpinned[index],
                      notifier: chatNotifier,
                      conversationNotifier: notifier,
                    ),
                  ),

                  // Finally, more space.
                  const Gap(20),
                ]
              ],
            ),
    );
  }
}
