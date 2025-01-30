import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/conversation.dart';
import 'package:wayagram/features/chat/widget/search.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  late final conversationState = ref.watch(conversationProvider);
  late final notifier = ref.watch(conversationProvider.notifier);
  late final profile = ref.watch(profileVmProvider).userAccountModel?.data?.userdata?.user;

  /// Helper function used to initiate a conversation with a new person or group.
  void _startConversation() async {}

  /// Used to filter the notification controller
  void _filterChats(String filter) {}

  @override
  Widget build(BuildContext context) {
    // For the size of the component.
    // final size = MediaQuery.sizeOf(context);

    // This is fine.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      automaticallyImplyLeading: false,
      backgroundColor: WayaColors.white,
      padding: const EdgeInsets.only(bottom: 20),
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: double.infinity,
        backgroundColor: WayaColors.white,
        leading: Container(
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
        actions: [
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //? First, the search bar for the chats.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchConversationWidget(
              onTextChange: _filterChats,
            ),
          ),

          // Some space.
          const Gap(20),

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
              chat: conversationState.conversations[index],
            ),
          ),

          // Finally, more space.
          const Gap(20),
        ],
      ),
    );
  }
}
