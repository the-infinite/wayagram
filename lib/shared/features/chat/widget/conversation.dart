// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/conversation_vm.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/chat/widget/conversation.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

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

class ShareChatsWidget extends ConsumerWidget {
  //? Is this expanded?
  final bool isExpanded;
  final String? url;
  final String entityId;
  final PageVm notifier;

  //? Is this expanded?
  const ShareChatsWidget({
    super.key,
    required this.notifier,
    required this.entityId,
    this.isExpanded = false,
    this.url,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationProvider);

    //? This is fine.
    return SizedBox(
      height: 102.h,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: state.conversations.length,
        itemBuilder: (context, index) {
          //? This is basically as it should be.
          final chat = state.conversations[index];
          final chatController = ChatInputController.instance;
          final chatNotifier = ref.read(chatProvider(chat.id).notifier);

          //? This is fine.
          return Padding(
            padding: index == 0 ? EdgeInsets.zero : EdgeInsets.only(left: 10.w),
            child: GestureDetector(
              onTap: () async {
                //> preload the previous chat
                chatNotifier.setChat(chat);

                //> prefill the text form field with the link
                chatController.setText(url ?? '');

                //> on to the chat page
                await WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));

                //? Then share.
                try {
                  notifier.sharePost(context, postId: entityId);
                } catch (_) {}
              },
              child: SizedBox(
                width: 62.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //? The profile picture.
                    ChatProfilePicture(
                      user: chat.other.userData!,
                      lastSeen: chat.other.chatUser?.lastSeen,
                      showActive: false,
                      chat: chat,
                      radius: 31.w,
                    ),

                    //? The name of the chat.
                    Text(
                      chat.name ?? chat.other.userData?.fullname ?? chat.other.chatUser?.displayName ?? "WayaGram User",
                      textAlign: TextAlign.center,
                      style: WayaTextStyles.titleMedium.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
