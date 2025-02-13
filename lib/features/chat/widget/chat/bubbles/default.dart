import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/forward.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/file.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/voice.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/text.dart';
import 'package:wayagram/features/chat/widget/chat/input/reply_to.dart';
import 'package:wayagram/features/chat/widget/chat/reaction/bubble.dart';
import 'package:wayagram/features/chat/widget/chat/reaction/selector.dart';

class _MyBubbleWidget extends StatelessWidget {
  final MessageModel data;
  final ChatInputController controller;
  final bool interactive;

  // Construct.
  const _MyBubbleWidget({
    required this.data,
    required this.controller,
    required this.interactive,
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: WayaColors.primary,
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
                                      color: WayaColors.white,
                                    ),

                                    // Space.
                                    const Gap(5),

                                    //* Text.
                                    Text(
                                      "Forwarded",
                                      style: WayaTextStyles.bodySemiBold.copyWith(
                                        fontSize: 13,
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
                                      color: WayaColors.white,
                                    ),

                                    // Space.
                                    const Gap(5),

                                    //* Text.
                                    Text(
                                      "Edited",
                                      style: WayaTextStyles.bodySemiBold.copyWith(
                                        fontSize: 13,
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
                                  color: WayaColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ChatReplyToWidget(
                                  controller: controller,
                                  message: data.originalMessage!,
                                  interactive: false,
                                ),
                              ),

                            //? Second below.
                            switch (data.messageType) {
                              MessageType.text => TextMessageWidget(
                                  data: data,
                                  textColor: WayaColors.white,
                                ),
                              MessageType.voiceNote => VoiceMessageWidget(
                                  data: data,
                                  isSender: true,
                                ),
                              MessageType.file => FileMessageWidget(
                                  data: data,
                                  textColor: WayaColors.white,
                                ),
                              _ => Text(
                                  data.contentDescription,
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
                        color: data.isError ?? false ? WayaColors.error : WayaColors.greyColor400,
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
  final bool interactive;

  // Construct.
  const _YourBubbleWidget({
    required this.data,
    required this.controller,
    required this.interactive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7, bottom: 7, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              //? First, the message box.
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: WayaColors.greyColor200,
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
                              color: WayaColors.primary600,
                            ),

                            // Space.
                            const Gap(5),

                            //* Text.
                            Text(
                              "Forwarded",
                              style: WayaTextStyles.bodySemiBold.copyWith(
                                fontSize: 13,
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
                              color: WayaColors.primary600,
                            ),

                            // Space.
                            const Gap(5),

                            //* Text.
                            Text(
                              "Edited",
                              style: WayaTextStyles.bodySemiBold.copyWith(
                                fontSize: 13,
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
                          color: WayaColors.primary.withAlpha(90),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ChatReplyToWidget(
                          controller: controller,
                          message: data.originalMessage!,
                          interactive: false,
                        ),
                      ),

                    //? Second below.
                    switch (data.messageType) {
                      MessageType.text => TextMessageWidget(
                          data: data,
                          textColor: WayaColors.black,
                        ),
                      MessageType.voiceNote => VoiceMessageWidget(
                          data: data,
                          isSender: false,
                        ),
                      MessageType.file => FileMessageWidget(
                          data: data,
                          textColor: WayaColors.black,
                        ),
                      _ => Text(
                          data.contentDescription,
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
            Text(
              WayaDateHelper.getTimestamp(data.updatedAt),
              style: WayaTextStyles.labelSmall.copyWith(
                color: WayaColors.greyColor400,
              ),
            ),
        ],
      ),
    );
  }
}

class ChatBubbleWidget extends ConsumerStatefulWidget {
  // The message we are looking at here.
  final MessageModel data;
  final DateTime previousDate;
  final ChatInputController controller;
  final int index;
  final bool interactive;
  final bool isLast;

  // This is fine.
  const ChatBubbleWidget({
    super.key,
    required this.data,
    required this.controller,
    required this.index,
    required this.previousDate,
    this.interactive = true,
    this.isLast = false,
  });

  @override
  ConsumerState<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends ConsumerState<ChatBubbleWidget> {
  OverlayEntry? _entry;
  late final notifier = ref.watch(chatProvider.notifier);
  late final _focusNode = FocusNode();

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
                    color: WayaColors.black,
                  ),
                  text: "Reply",
                  textStyle: WayaTextStyles.bodySemiBold.copyWith(
                    fontSize: 13,
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
                    color: WayaColors.black,
                  ),
                  text: "Forward",
                  textStyle: WayaTextStyles.bodySemiBold.copyWith(
                    fontSize: 13,
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
                      color: WayaColors.black,
                    ),
                    text: "Copy",
                    textStyle: WayaTextStyles.bodySemiBold.copyWith(
                      fontSize: 13,
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
                      color: WayaColors.black,
                    ),
                    text: "Edit",
                    textStyle: WayaTextStyles.bodySemiBold.copyWith(
                      fontSize: 13,
                    ),
                  ),

                //* Fifth, delete this message for me.
                if (widget.data.dto == null)
                  WayaButton(
                    callback: () {
                      widget.controller.clearFocus();

                      // Delete this message.
                      notifier.deleteMessage(widget.data.id, MessageDeleteAction.deleteForMe);
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
                      color: WayaColors.error,
                    ),
                    text: "Delete for me",
                    textStyle: WayaTextStyles.bodySemiBold.copyWith(
                      fontSize: 13,
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
                      color: WayaColors.error,
                    ),
                    text: "Unsend",
                    textStyle: WayaTextStyles.bodySemiBold.copyWith(
                      fontSize: 13,
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
                      onDismiss: () {
                        widget.controller.clearFocus();
                      },
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
    widget.controller.setFocus(widget.data);

    // Update this lad.
    setState(() {
      _entry = _entry;
    });
  }

  /// Utility runnable used to resend this message when it failed.
  Future<void> _resendMessage() async {
    final notifier = ref.watch(chatProvider.notifier);

    //? If this is actually fine.
    notifier.sendMessage(widget.data.dto!, widget.data.id);
  }

  /// A utility function used to check whether I have seen this message and then
  /// notify others of it.
  Future<void> _checkStatusAndNotify() async {
    //? If this is not interactive, leave.
    if (!widget.interactive) return;

    //? If this message was sent by me, leave.
    if (widget.data.senderId == ConversationState.self.id) return;

    //* My read status.
    final status = widget.data.myStatus?.status;

    //? If this is already read, leave.
    if (status == MessageStatusCode.read) {
      debugPrint("MessageNotifier> Skipped the message because it has been read.");
      return;
    }

    //? If this is already deleted leave?
    if (status == MessageStatusCode.deleted) {
      debugPrint("MessageNotifier> Skipped the message because it has been deleted.");
      return;
    }

    //? If this is not delivered and it is not read...
    _focusNode.addListener(() {
      //? If this is already read, leave.
      if (status == MessageStatusCode.read) {
        debugPrint("MessageNotifier> Skipped the message because it has been read.");
        return;
      }

      //? If this is already deleted leave?
      if (status == MessageStatusCode.deleted) {
        debugPrint("MessageNotifier> Skipped the message because it has been deleted.");
        return;
      }

      //? now, move forward.
      if (!_focusNode.hasFocus) {
        debugPrint("MessageNotifier> Skipped the message because it does not have focus.");
        return;
      }

      //? If this is the last message, mark all as read.
      if (widget.isLast && status == MessageStatusCode.delivered) {
        debugPrint("MessageNotifier> Marking all messages as read.");
        notifier.markAllAsRead();
      }

      //? Since this is not the last message, mark this as read.
      else if (status == MessageStatusCode.delivered) {
        debugPrint("MessageNotifier> Marking message ${widget.data.id} as read.");
        notifier.updateMessageStatus(MessageStatusCode.read, widget.data.id);
      }

      //? Since this is still sent, then we can mark this as delivered.
      else {
        debugPrint("MessageNotifier> Marking message ${widget.data.id} as delivered.");
        notifier.updateMessageStatus(MessageStatusCode.delivered, widget.data.id);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    final user = ConversationState.self;

    //? Our other option.
    return PopScope(
      onPopInvokedWithResult: (isRemoved, _) {
        if (isRemoved) widget.controller.clearFocus();
      },
      child: WayaFutureSubscriber(
        future: _checkStatusAndNotify(),
        builder: (context, data) => Opacity(
          opacity: _entry == null ? 1 : 0,
          child: Focus(
            focusNode: _focusNode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //? The date separator.
                if (widget.interactive && !WayaDateHelper.isSameDay(widget.data.createdAt, widget.previousDate))
                  WayaTextStrip(
                    WayaDateHelper.getSocialDate(widget.data.createdAt),
                    style: WayaTextStyles.bodyMedium.copyWith(
                      fontSize: 14,
                    ),
                  ),

                //? This is fine.
                WayaSwiper(
                  swipeSensitivity: 5,
                  onLongPress: widget.interactive ? _showActions : null,
                  onTap: widget.data.isError ?? false ? _resendMessage : null,
                  rightSwipeWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //? First, the reply icon.
                      WayaAssets.icons.cCornerUpLeft.svg(
                        color: WayaColors.primary,
                      ),

                      // Some space.
                      const Gap(5),

                      //? Second, the text for replying.
                      Text(
                        "Reply",
                        style: WayaTextStyles.bodySemiBold.copyWith(
                          color: WayaColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  onRightSwipe: widget.interactive ? (details) => _replyTo() : null,
                  child: widget.data.senderId == user.id
                      ? _MyBubbleWidget(
                          data: widget.data,
                          controller: widget.controller,
                          interactive: widget.interactive,
                        )
                      : _YourBubbleWidget(
                          data: widget.data,
                          controller: widget.controller,
                          interactive: widget.interactive,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
