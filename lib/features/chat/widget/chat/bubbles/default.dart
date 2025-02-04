import 'dart:ui';

import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/file.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/voice.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/text.dart';
import 'package:wayagram/features/chat/widget/chat/input/reply_to.dart';

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
                        //? First, we need to show the reply to of this message
                        //? if it exists.
                        if (data.originalMessage != null)
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

                  //? Second, the date and time relevant to it.
                  if (interactive)
                    Text(
                      "${data.readAt != null ? 'Read' : data.deliveredAt != null ? 'Delivered' : 'Sent'} ${WayaDateHelper.getTimestamp(data.readAt ?? data.deliveredAt ?? data.updatedAt)}",
                      style: WayaTextStyles.labelSmall.copyWith(
                        color: WayaColors.greyColor400,
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
                //? First, we need to show the reply to of this message
                //? if it exists.
                if (data.originalMessage != null)
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

class ChatBubbleWidget extends StatefulWidget {
  // The message we are looking at here.
  final MessageModel data;
  final ChatInputController controller;
  final int index;
  final bool interactive;

  // This is fine.
  const ChatBubbleWidget({
    super.key,
    required this.data,
    required this.controller,
    required this.index,
    this.interactive = true,
  });

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  OverlayEntry? _entry;

  /// This is the message we are replying to.
  void _replyTo() {
    widget.controller.setReplyTo(widget.data);
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
        // Okay, let's move this fairly.

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
                        _entry?.remove();

                        //? This is now empty.
                        setState(() {
                          _entry = null;
                        });
                      },
                    ),
                  ),
                ),
              ),

              //? The actual component.
              Positioned(
                left: 0,
                top: offset.dy,
                child: Container(
                  width: screenSize.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      //? First, an non-interactive chat widget.
                      SizedBox(
                        width: screenSize.width,
                        child: ChatBubbleWidget(
                          data: widget.data,
                          controller: widget.controller,
                          index: widget.index,
                          interactive: false,
                        ),
                      ),

                      //? Next, we do this there.
                      Container(
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
                                _entry?.remove();
                                setState(() {
                                  _entry = null;
                                });

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
                                fontSize: 12,
                              ),
                            ),

                            //* Second, the forward button.
                            WayaButton(
                              callback: () {
                                _entry?.remove();
                                setState(() {
                                  _entry = null;
                                });

                                // Forward this message.
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
                                fontSize: 12,
                              ),
                            ),

                            //* Third, the copy button.
                            WayaButton(
                              callback: () {
                                _entry?.remove();
                                setState(() {
                                  _entry = null;
                                });

                                // Copy to this message.
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
                                fontSize: 12,
                              ),
                            ),

                            //* Fourth, the edit button.
                            WayaButton(
                              callback: () {
                                _entry?.remove();
                                setState(() {
                                  _entry = null;
                                });

                                // Edit this message.
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
                                fontSize: 12,
                              ),
                            ),

                            //* Fifth, delete this message for me.
                            WayaButton(
                              callback: () {
                                _entry?.remove();
                                setState(() {
                                  _entry = null;
                                });

                                // Delete this message.
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
                                fontSize: 12,
                              ),
                            ),

                            //* Sixth, the divider.
                            const Divider(color: WayaColors.greyColor200),

                            //* Seventh, the "unsend" button.
                            WayaButton(
                              callback: () {
                                _entry?.remove();
                                setState(() {
                                  _entry = null;
                                });

                                // Delete this message.
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
                                fontSize: 12,
                              ),
                            ),

                            //* Some space.
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Insert this overlay.
    Overlay.of(context).insert(_entry!);

    // Update this lad.
    setState(() {
      _entry = _entry;
    });
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    final user = ConversationState.self;

    //? Our other option.
    return PopScope(
      onPopInvokedWithResult: (isRemoved, _) {
        if (isRemoved) {
          _entry?.remove();

          setState(() {
            _entry = null;
          });
        }
      },
      child: Opacity(
        opacity: _entry == null ? 1 : 0,
        child: WayaSwiper(
          swipeSensitivity: 5,
          onLongPress: widget.interactive ? _showActions : null,
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
      ),
    );
  }
}
