import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/forward.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/file.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/voice.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/text.dart';
import 'package:wayagram/features/chat/widget/chat/input/reply_to.dart';
import 'package:wayagram/features/chat/widget/chat/reaction/bubble.dart';
import 'package:wayagram/features/chat/widget/chat/reaction/selector.dart';
import 'package:wayagram/features/general_settings/chat_settings/vm.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

bool _isMediaFile(MessageModel data) {
  return [MessageType.file, MessageType.image, MessageType.video].contains(data.messageType);
}

class _MyBubbleWidget extends StatelessWidget {
  final MessageModel data;
  final ChatInputController controller;
  final ChatModel chat;
  final bool interactive;
  final bool isDark;
  final Color backgroundColor;
  final Color grayColor;
  final double textScale;

  // Construct.
  const _MyBubbleWidget({
    required this.data,
    required this.controller,
    required this.interactive,
    required this.chat,
    required this.isDark,
    required this.backgroundColor,
    required this.grayColor,
    required this.textScale,
  });

  @override
  Widget build(BuildContext context) {
    final timeString =
        "${data.readAt != null ? 'Read' : data.deliveredAt != null ? 'Delivered' : 'Sent'} ${WayaDateHelper.getTimestamp(data.readAt ?? data.deliveredAt ?? data.updatedAt)}";
    //? The time string.
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? First, the space before this component.
            const Gap(30),

            //? Finally, component itself.
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //? First, the message box.
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      //? First, the message container.
                      Container(
                        padding: _isMediaFile(data) && (data.content?.isEmpty ?? true)
                            ? const EdgeInsets.all(2)
                            : const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? WayaColors.primary600 : WayaColors.primary,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //? First, if this message was forwarded to this conversation...
                            if (data.forwardedFrom != null || data.edited) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //* Icon
                                  if (data.forwardedFrom != null) ...[
                                    WayaAssets.icons.cCornerUpRight.svg(
                                      height: 20,
                                      width: 20,
                                      colorFilter: ColorFilter.mode(
                                        WayaColors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),

                                    // Space.
                                    const Gap(5),

                                    //* Text.
                                    Text(
                                      "Forwarded",
                                      style: WayaTextStyles.bodySemiBold.copyWith(
                                        fontSize: 13.sp,
                                        color: WayaColors.white,
                                      ),
                                    ),
                                  ],

                                  //? If this was edited...
                                  if (data.forwardedFrom != null && data.edited) ...[
                                    Container(
                                      width: 5,
                                      height: 10,
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(200),
                                        color: WayaColors.white,
                                      ),
                                    )
                                  ],

                                  //? If this was edited.
                                  if (data.edited) ...[
                                    WayaAssets.icons.cPencil.svg(
                                      height: 20,
                                      width: 20,
                                      colorFilter: ColorFilter.mode(
                                        WayaColors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),

                                    // Space.
                                    const Gap(5),

                                    //* Text.
                                    Text(
                                      "Edited",
                                      style: WayaTextStyles.bodySemiBold.copyWith(
                                        fontSize: 13.sp,
                                        color: WayaColors.white,
                                      ),
                                    ),
                                  ],
                                ],
                              ),

                              // Some space.
                              const Gap(5),
                            ]

                            //? Second, we need to show the reply to of this message
                            //? if it exists.
                            else if (data.originalMessage != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark ? WayaColors.darkGrey : WayaColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ChatReplyToWidget(
                                  controller: controller,
                                  message: data.originalMessage!,
                                  chat: chat,
                                  interactive: false,
                                  isDarkMode: isDark,
                                ),
                              ),

                            //? Second below.
                            switch (data.messageType) {
                              MessageType.text => TextMessageWidget(
                                  data: data,
                                  textColor: WayaColors.white,
                                  isMyMessage: true,
                                ),
                              MessageType.voiceNote => VoiceMessageWidget(
                                  data: data,
                                  isSender: true,
                                ),
                              MessageType.file || MessageType.image || MessageType.video => FileMessageWidget(
                                  data: data,
                                  textColor: WayaColors.white,
                                ),
                              _ => Text(
                                  data.contentDescription,
                                  style: WayaTextStyles.bodyMedium.copyWith(
                                    fontSize: 15.sp * ChatSettingsNotifier.instance.textScale,
                                    fontWeight: FontWeight.normal,
                                    color: WayaColors.white,
                                  ),
                                ),
                            }
                          ],
                        ),
                      ),

                      //? Second, the reaction part of things.
                      if (interactive && (data.messageReaction?.isNotEmpty ?? false))
                        Positioned(
                          left: 5,
                          top: -15,
                          child: Container(
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                              color: WayaColors.primary50,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                data.reactionPairs.length,
                                (index) {
                                  final part = data.reactionPairs.entries.elementAt(index);

                                  //? This is fine.
                                  return ReactionWidgetBubble(
                                    reaction: part.key,
                                    count: part.value,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  //? Third, the date and time relevant to it.
                  if (interactive)
                    Text(
                      data.isError ?? false
                          ? "Failed to send. Tap to retry."
                          : data.dto != null
                              ? "Sending"
                              : timeString,
                      style: WayaTextStyles.labelSmall.copyWith(
                        color: data.isError ?? false ? WayaColors.error : grayColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YourBubbleWidget extends StatelessWidget {
  final MessageModel data;
  final ChatInputController controller;
  final ChatModel chat;
  final bool interactive;
  final bool isDark;
  final Color backgroundColor;
  final Color grayColor;
  final double textScale;

  // Construct.
  const _YourBubbleWidget({
    required this.data,
    required this.controller,
    required this.interactive,
    required this.chat,
    required this.isDark,
    required this.backgroundColor,
    required this.grayColor,
    required this.textScale,
  });

  @override
  Widget build(BuildContext context) {
    final user = chat.chatMembers.firstWhere((member) => member.userId == data.senderId).combined;

    // This is fine.
    return Padding(
      padding: EdgeInsets.only(top: 7.h, bottom: 7.h, right: 30.w),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 5.w,
          children: [
            //? If this is a group chat, and we know this user.
            if (chat.chatType == ChatType.group && user != null)
              ChatProfilePicture(
                user: user.$1,
                chat: chat,
                useGroup: false,
                canMove: false,
                showActive: false,
                radius: 13.r,
              ),

            //? Our column here for good measure.
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      //? First, the message box.
                      Container(
                        padding: _isMediaFile(data) && (data.content?.isEmpty ?? true)
                            ? const EdgeInsets.all(2)
                            : const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? WayaColors.white50 : WayaColors.greyColor200,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //? First, if this message was forwarded to this conversation...
                            if (data.forwardedFrom != null || data.edited) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //* Icon
                                  if (data.forwardedFrom != null) ...[
                                    WayaAssets.icons.cCornerUpRight.svg(
                                      height: 20,
                                      width: 20,
                                      colorFilter: ColorFilter.mode(
                                        WayaColors.primary600,
                                        BlendMode.srcIn,
                                      ),
                                    ),

                                    // Space.
                                    const Gap(5),

                                    //* Text.
                                    Text(
                                      "Forwarded",
                                      style: WayaTextStyles.bodySemiBold.copyWith(
                                        fontSize: 13.sp,
                                        color: WayaColors.primary600,
                                      ),
                                    ),
                                  ],

                                  //? If this was edited...
                                  if (data.forwardedFrom != null && data.edited) ...[
                                    Container(
                                      width: 5,
                                      height: 10,
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(200),
                                        color: WayaColors.primary600,
                                      ),
                                    )
                                  ],

                                  //? If this was edited.
                                  if (data.edited) ...[
                                    WayaAssets.icons.cPencil.svg(
                                      height: 20,
                                      width: 20,
                                      colorFilter: ColorFilter.mode(
                                        WayaColors.primary600,
                                        BlendMode.srcIn,
                                      ),
                                    ),

                                    // Space.
                                    const Gap(5),

                                    //* Text.
                                    Text(
                                      "Edited",
                                      style: WayaTextStyles.bodySemiBold.copyWith(
                                        fontSize: 13.sp,
                                        color: WayaColors.primary600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),

                              // Some space.
                              const Gap(5),
                            ]

                            //? Second, we need to show the reply to of this message
                            //? if it exists.
                            else if (data.originalMessage != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: WayaColors.primary50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ChatReplyToWidget(
                                  controller: controller,
                                  message: data.originalMessage!,
                                  chat: chat,
                                  interactive: false,
                                ),
                              ),

                            //? Second below.
                            switch (data.messageType) {
                              MessageType.text => TextMessageWidget(
                                  data: data,
                                  textColor: isDark ? WayaColors.white : WayaColors.black,
                                ),
                              MessageType.voiceNote => VoiceMessageWidget(
                                  data: data,
                                  isSender: false,
                                ),
                              MessageType.file || MessageType.image || MessageType.video => FileMessageWidget(
                                  data: data,
                                  textColor: isDark ? WayaColors.white : WayaColors.black,
                                ),
                              _ => Text(
                                  data.contentDescription,
                                  style: WayaTextStyles.bodyMedium.copyWith(
                                    fontSize: 15.sp * ChatSettingsNotifier.instance.textScale,
                                    color: isDark ? WayaColors.white : WayaColors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                            }
                          ],
                        ),
                      ),

                      //? Second, the reaction part of things.
                      if (interactive && (data.messageReaction?.isNotEmpty ?? false))
                        Positioned(
                          right: 5,
                          top: -15,
                          child: Container(
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                              color: WayaColors.primary50,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                data.reactionPairs.length,
                                (index) {
                                  final part = data.reactionPairs.entries.elementAt(index);

                                  //? This is fine.
                                  return ReactionWidgetBubble(
                                    reaction: part.key,
                                    count: part.value,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  //? Second, the date and time relevant to it.
                  if (interactive)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? If this is a group, for the person who sent the message.
                        if (chat.chatType == ChatType.group && user != null)
                          Text(
                            "${user.$2.displayName} • ",
                            style: WayaTextStyles.labelSmall.copyWith(
                              color: grayColor,
                            ),
                          ),

                        //? For the time the message was sent...
                        Text(
                          WayaDateHelper.getTimestamp(data.updatedAt),
                          style: WayaTextStyles.labelSmall.copyWith(
                            color: grayColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubbleWidget extends ConsumerStatefulWidget {
  // The message we are looking at here.
  final MessageModel data;
  final ChatModel? chat;
  final bool isDark;
  final Color? backgroundColor;
  final Color? grayColor;
  final double? textScale;
  final DateTime previousDate;
  final ChatInputController controller;
  final int index;
  final FocusNode inputFocus;
  final bool interactive;
  final bool isLast;

  // This is fine.
  const ChatBubbleWidget({
    super.key,
    required this.chat,
    required this.data,
    required this.controller,
    required this.index,
    required this.previousDate,
    required this.inputFocus,
    this.isDark = false,
    this.interactive = true,
    this.isLast = false,
    this.backgroundColor,
    this.grayColor,
    this.textScale,
  });

  @override
  ConsumerState<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends ConsumerState<ChatBubbleWidget> {
  OverlayEntry? _entry;
  late final notifier = ref.read(chatProvider(widget.chat?.id ?? widget.data.chatId).notifier);
  late final conversationNotifier = ref.read(conversationProvider.notifier);

  /// This is the message we are replying to.
  void _replyTo() {
    widget.controller.quoteMessage(widget.data);
  }

  /// This helps us to know what we are doing.
  void _forwardTo() async {
    final result = await WayaUtils.showModalSheet(
      context,
      child: ForwardMessageModal(
        message: widget.data,
      ),
    );

    //? Do nothing.
    if (result == null) return;
  }

  /// Edit this message.
  void _editMessage() async {
    widget.controller.setText(widget.data.content ?? '');
    widget.controller.quoteMessage(widget.data, true);
  }

  /// On long press, show the chat context actions.
  Future<void> _showActions() async {
    if (_entry != null) return;

    // If this is defined, remove it.
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final screenSize = MediaQuery.sizeOf(context);

    // If we do  not find the renderBox
    if (size == null || renderBox == null) {
      return;
    }

    // This is fine.
    final offset = renderBox.localToGlobal(Offset.zero);
    final isMe = widget.data.senderId == ConversationState.self.id;
    final messageController = notifier.getController(widget.data);

    // This is fine.
    _entry = OverlayEntry(
      builder: (context) {
        //? From where we listen for the size of this component.
        final sizeNotifier = ValueNotifier(Size.zero);

        // Okay, let's move this fairly.
        final actions = WayaMeasurableWidget(
          onSized: (size) {
            sizeNotifier.value = size;
          },
          child: Container(
            width: screenSize.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: WayaColors.greyColor200,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* First, the reply button.
                WayaButton(
                  callback: () {
                    widget.controller.clearFocus();

                    // Reply to this message.
                    _replyTo();
                  },
                  height: null,
                  alignment: Alignment.centerLeft,
                  verticalPadding: 8,
                  horizontalPadding: 8,
                  textColor: WayaColors.black,
                  color: Colors.transparent,
                  leadingIcon: WayaAssets.icons.cCornerUpLeft.svg(
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      WayaColors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  text: "Reply",
                  textStyle: WayaTextStyles.bodySemiBold.copyWith(
                    fontSize: 13.sp,
                  ),
                ),

                //* Second, the forward button.
                WayaButton(
                  callback: () {
                    widget.controller.clearFocus();

                    // Forward this message.
                    _forwardTo();
                  },
                  height: null,
                  alignment: Alignment.centerLeft,
                  verticalPadding: 8,
                  horizontalPadding: 8,
                  textColor: WayaColors.black,
                  color: Colors.transparent,
                  leadingIcon: WayaAssets.icons.cCornerUpRight.svg(
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      WayaColors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  text: "Forward",
                  textStyle: WayaTextStyles.bodySemiBold.copyWith(
                    fontSize: 13.sp,
                  ),
                ),

                //* Third, the copy button.
                if (widget.data.content != null && (widget.data.content?.isNotEmpty ?? false))
                  WayaButton(
                    callback: () {
                      widget.controller.clearFocus();

                      // Copy to this message.
                      WayaUtils.copyText(widget.data.content ?? '');
                    },
                    height: null,
                    alignment: Alignment.centerLeft,
                    verticalPadding: 8,
                    horizontalPadding: 8,
                    textColor: WayaColors.black,
                    color: Colors.transparent,
                    leadingIcon: WayaAssets.icons.cCopy.svg(
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        WayaColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    text: "Copy",
                    textStyle: WayaTextStyles.bodySemiBold.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),

                //* Fourth, the edit button.
                if (isMe)
                  WayaButton(
                    callback: () {
                      widget.controller.clearFocus();

                      // Edit this message.
                      _editMessage();
                    },
                    height: null,
                    alignment: Alignment.centerLeft,
                    verticalPadding: 8,
                    horizontalPadding: 8,
                    textColor: WayaColors.black,
                    color: Colors.transparent,
                    leadingIcon: WayaAssets.icons.cPencil.svg(
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        WayaColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    text: "Edit",
                    textStyle: WayaTextStyles.bodySemiBold.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),

                //* Fifth, delete this message for me.
                if (widget.data.dto == null)
                  WayaButton(
                    callback: () async {
                      widget.controller.clearFocus();

                      //? Delete this message.
                      await notifier.deleteMessage(widget.data.id, MessageDeleteAction.deleteForMe);

                      //? Finally, refetch the conversation.
                      conversationNotifier.getChatDetails(widget.data.chatId);
                    },
                    height: null,
                    alignment: Alignment.centerLeft,
                    verticalPadding: 8,
                    horizontalPadding: 8,
                    color: Colors.transparent,
                    textColor: WayaColors.error,
                    leadingIcon: WayaAssets.icons.cBin.svg(
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        WayaColors.error,
                        BlendMode.srcIn,
                      ),
                    ),
                    text: "Delete for me",
                    textStyle: WayaTextStyles.bodySemiBold.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),

                //* Sixth, the divider.
                if (isMe)
                  const Divider(
                    color: WayaColors.greyColor200,
                  ),

                //* Seventh, the "unsend" button.
                if (isMe)
                  WayaButton(
                    callback: () {
                      widget.controller.clearFocus();

                      // Delete this message.
                      if (widget.data.dto != null) {
                        notifier.removeMessage(widget.data.id);
                        return;
                      }

                      //? Then delete this message.
                      notifier.deleteMessage(widget.data.id, MessageDeleteAction.deleteForEveryone).then(
                        (success) {
                          if (success) {
                            conversationNotifier.getChatDetails(widget.data.chatId);
                            widget.controller.setText(widget.data.content ?? '');
                          }
                        },
                      );
                    },
                    height: null,
                    alignment: Alignment.centerLeft,
                    verticalPadding: 8,
                    horizontalPadding: 8,
                    color: Colors.transparent,
                    textColor: WayaColors.error,
                    leadingIcon: WayaAssets.icons.cMultiplyCircle.svg(
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        WayaColors.error,
                        BlendMode.srcIn,
                      ),
                    ),
                    text: "Delete for everyone",
                    textStyle: WayaTextStyles.bodySemiBold.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),

                //* Some space.
                const SizedBox(height: 10),
              ],
            ),
          ),
        );

        // This is fair enough.
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              //? Our background.
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Opacity(
                  opacity: 0.6,
                  child: SizedBox(
                    child: ModalBarrier(
                      dismissible: true,
                      color: Colors.white,
                      onDismiss: () => widget.controller.clearFocus(),
                    ),
                  ),
                ),
              ),

              //? The actual component.
              ValueListenableBuilder(
                valueListenable: sizeNotifier,
                builder: (context, popupSize, _) {
                  //? First, calculate the extent to which this thing is going to stretch on screen.
                  final popupExtent = offset.dy + size.height + popupSize.height + 5 + 60;

                  //? If this is lower than a quarter of the screen...
                  if (popupExtent > screenSize.height) {
                    return Positioned(
                      left: 0,
                      top: offset.dy - popupSize.height,
                      child: Container(
                        width: screenSize.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            //? First, the actions that are available on this
                            //? message.
                            actions,

                            //? Second, an non-interactive chat widget.
                            SizedBox(
                              width: screenSize.width,
                              child: ChatBubbleWidget(
                                data: widget.data,
                                inputFocus: widget.inputFocus,
                                chat: widget.chat,
                                previousDate: widget.previousDate,
                                controller: widget.controller,
                                index: widget.index,
                                interactive: false,
                              ),
                            ),

                            //? Finally the reaction side of things.
                            ChatReactionInput(
                              controller: widget.controller,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  //? Since this can be positioned this way...
                  return Positioned(
                    left: 0,
                    top: offset.dy - 60,
                    child: Container(
                      width: screenSize.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          //? First the reaction side of things.
                          ChatReactionInput(
                            controller: widget.controller,
                          ),

                          //? Second, an non-interactive chat widget.
                          SizedBox(
                            width: screenSize.width,
                            child: ChatBubbleWidget(
                              data: widget.data,
                              chat: widget.chat,
                              inputFocus: widget.inputFocus,
                              previousDate: widget.previousDate,
                              controller: widget.controller,
                              index: widget.index,
                              interactive: false,
                            ),
                          ),

                          //? Next, we do this there.
                          actions,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    // Add our focus listener.
    widget.controller.setFocusListener(
      (isFocused) {
        //? If this is not focused.
        if (!isFocused && _entry != null) {
          //? Only remove this when it is mounted.
          _entry?.remove();

          //? Notify your listeners.
          setState(() {
            _entry = null;
          });
        }
      },
    );

    // Insert this overlay.
    Overlay.of(context).insert(_entry!);
    widget.controller.setFocus(messageController!.data);

    // Update this lad.
    setState(() {
      _entry = _entry;
    });
  }

  /// Utility runnable used to resend this message when it failed.
  Future<void> _resendMessage() async {
    debugPrint("Resending ${widget.data.chatId}");

    final notifier = ref.read(chatProvider(widget.chat!.id).notifier);

    //? If this is actually fine.
    notifier.sendMessage(widget.data.dto!, widget.data.id);
  }

  /// A utility function used to check whether I have seen this message and then
  /// notify others of it.
  //   Future<void> _checkStatusAndNotify() async {
  //     //? The member data.
  //     final me = widget.chat?.self;
  //     final other = widget.chat?.other;

  //     //? If this is not interactive, leave.
  //     if (!widget.interactive) return;

  //     //? If this message was sent by me, leave.
  //     if (widget.data.senderId == ConversationState.self.id) return;

  //     //? If this user does not have read receipts...
  //     if (widget.chat?.chatType == ChatType.personal && !(me?.chatUser?.canSeeReadReceipt ?? true)) return;

  //     //? If the other user does not have read receipts...
  //     if (widget.chat?.chatType == ChatType.personal && !(other?.chatUser?.canSeeReadReceipt ?? true)) return;

  //     //* My read status.
  //     final status = widget.data.myStatus?.status;

  //     //? If this is already read, leave.
  //     if (status == MessageStatusCode.read) {
  //       return;
  //     }

  //     //? If this is already deleted leave?
  //     if (status == MessageStatusCode.deleted) {
  //       return;
  //     }

  //     //? Since this is not the last message, mark this as read.
  //     if (status == MessageStatusCode.delivered) {
  //       notifier.updateMessageStatus(MessageStatusCode.read, widget.data.id);
  //     }

  //     //? Since this is still sent, then we can mark this as delivered.
  //     else {
  //       notifier.updateMessageStatus(MessageStatusCode.delivered, widget.data.id);
  //     }

  //     //? Fire all pending callbacks right away.
  //     debounce(
  //       () => VisibilityDetectorController.instance.notifyNow(),
  //       key: "vd-msg-${widget.data.id}",
  //       delay: const Duration(milliseconds: 400),
  //     );
  //   }

  @override
  void dispose() {
    super.dispose();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    final user = ConversationState.self;
    final messageController = notifier.getController(widget.data);

    //? If this has been deleted.
    if (messageController == null) {
      return const SizedBox();
    }

    //? If these do not match...
    if (widget.data.id != messageController.data.id) {
      return const SizedBox();
    }

    //? Our other option.
    return ValueListenableBuilder(
      valueListenable: messageController,
      builder: (context, redraws, _) => PopScope(
        onPopInvokedWithResult: (isRemoved, _) {
          if (isRemoved) widget.controller.clearFocus();
        },
        child: Opacity(
          opacity: _entry == null ? 1 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? The date separator.
              if (widget.interactive && !WayaDateHelper.isSameDay(widget.data.createdAt, widget.previousDate))
                WayaTextStrip(
                  WayaDateHelper.getSocialDate(widget.data.createdAt),
                  backgroundColor: widget.backgroundColor ?? WayaColors.scaffoldColor2,
                  style: WayaTextStyles.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: widget.grayColor,
                  ),
                ),

              //? This is fine.
              WayaSwiper(
                swipeSensitivity: 5,
                onLongPress: widget.interactive ? _showActions : null,
                onTap: widget.data.dto != null ? _resendMessage : null,
                rightSwipeWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? First, the reply icon.
                    WayaAssets.icons.cCornerUpLeft.svg(
                      colorFilter: ColorFilter.mode(
                        WayaColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),

                    // Some space.
                    const Gap(5),

                    //? Second, the text for replying.
                    Text(
                      "Reply",
                      style: WayaTextStyles.bodySemiBold.copyWith(
                        color: WayaColors.primary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                onVerticalSwipe: widget.interactive ? () => widget.inputFocus.unfocus() : null,
                onRightSwipe: widget.interactive ? (details) => _replyTo() : null,
                child: widget.data.senderId == user.id
                    ? _MyBubbleWidget(
                        data: messageController.data,
                        chat: widget.chat!,
                        controller: widget.controller,
                        interactive: widget.interactive,
                        isDark: widget.isDark,
                        backgroundColor: widget.backgroundColor ?? WayaColors.scaffoldColor2,
                        grayColor: widget.grayColor ?? WayaColors.greyColor500,
                        textScale: widget.textScale ?? 1,
                      )
                    : _YourBubbleWidget(
                        data: messageController.data,
                        chat: widget.chat!,
                        controller: widget.controller,
                        interactive: widget.interactive,
                        isDark: widget.isDark,
                        backgroundColor: widget.backgroundColor ?? WayaColors.scaffoldColor2,
                        grayColor: widget.grayColor ?? WayaColors.greyColor500,
                        textScale: widget.textScale ?? 1,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
