import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/widget/chat/input/reply_to.dart';

class ChatInputController {
  /// The type of message that the chat input is currently going to send.
  final _currentType = ValueNotifier<MessageType>(MessageType.text);

  /// Is the kind of file we are sending an image?
  final _isMedia = ValueNotifier(false);

  /// The message that this
  final _replyTo = ValueNotifier<MessageModel?>(null);

  /// The text editing controller that is used to keep track of the text that
  /// is currently ready to be sent.
  final _textController = TextEditingController();

  /// The list of files currently put inside of this one.
  final _files = ValueNotifier<List<File>>([]);

  /// A helper button used to check whether we can sense the current message or
  /// not.
  final _canSend = ValueNotifier(false);

  /// A utility function used to dispose all the controllers that this controller
  /// is bound to.
  void dispose() {
    try {
      _isMedia.dispose();
      _files.dispose();
      _currentType.dispose();
      _textController.dispose();
      _canSend.dispose();
      _replyTo.dispose();
    } catch (_) {}
  }

  /// A helper function used to set the message that this input widget is
  /// supposed to be replying to.
  void setReplyTo(MessageModel? message) {
    _replyTo.value = message;
  }

  /// A helper function used to set the type of message that this is currently
  /// prepping to send.
  void setMessageType(MessageType type) {
    _currentType.value = type;
  }
}

/// The widget that is used to denote/represent the
class ChatInputWidget extends StatelessWidget {
  final ChatInputController controller;

  // Construct.
  const ChatInputWidget({
    super.key,
    required this.controller,
  });

  /// Helper function used to add an attachment.
  void _addAttachment() async {}

  /// Helper function used to start recording a voice note.
  void _recordVoiceNote() async {}

  /// Helper function used to send a message.
  void _sendMessage() async {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //? Extra, the divider.
          Divider(color: WayaColors.greyColor200, height: 0),

          //? First, some space before the reply-to
          const Gap(6),

          //? Second, the reply to ..
          ValueListenableBuilder(
            valueListenable: controller._replyTo,
            builder: (context, message, _) {
              //? If this is not defined...
              if (message == null) return const SizedBox();

              //? Since it is defined...
              return ChatReplyToWidget(
                message: message,
                controller: controller,
              );
            },
          ),

          //? Third, the space after the reply to
          const Gap(6),

          //? Finally, the row for actual chat controls.
          ValueListenableBuilder(
            valueListenable: controller._currentType,
            builder: (context, messageType, _) {
              //? Return the row of components that also represent and contain the
              //? message input field.
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //? First, the button for attaching content.
                  WayaButton(
                    callback: _addAttachment,
                    height: null,
                    color: WayaColors.greyColor200,
                    horizontalPadding: 10,
                    verticalPadding: 10,
                    centerWidget: WayaAssets.icons.cButtonAttach.svg(
                      color: WayaColors.black,
                      height: 18,
                      width: 18,
                    ),
                  ),

                  // Some space.
                  const Gap(5),

                  //? Second, the input text
                  Expanded(
                    child: WayaTextFormField(
                      hintText: "Write a message here",
                      showBorder: false,
                      maxLines: 5,
                      onChanged: (value) {
                        //? If this is a text message...
                        if (controller._currentType.value == MessageType.text) {
                          controller._canSend.value = value.trim().isNotEmpty;
                        }

                        // TODO: Repeat this logic for other message types.
                      },
                      isDense: true,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                      fillColor: WayaColors.greyColor200,
                      controller: controller._textController,
                    ),
                  ),

                  // Some space.
                  const Gap(5),

                  //? Third, the button for either sending messages.
                  ValueListenableBuilder(
                    valueListenable: controller._canSend,
                    builder: (context, canSend, _) {
                      //? Since we cannot send yet, show this message type's
                      //? protocol icon.
                      return AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: canSend ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        firstChild: WayaButton(
                          callback: _sendMessage,
                          height: null,
                          color: WayaColors.primary,
                          horizontalPadding: 10,
                          verticalPadding: 10,
                          centerWidget: WayaAssets.icons.cSend.svg(
                            color: WayaColors.white,
                            height: 18,
                            width: 18,
                          ),
                        ),
                        secondChild: WayaButton(
                          callback: _recordVoiceNote,
                          height: null,
                          color: WayaColors.greyColor200,
                          horizontalPadding: 10,
                          verticalPadding: 10,
                          centerWidget: WayaAssets.icons.cButtonVoicenote.svg(
                            color: WayaColors.black,
                            height: 18,
                            width: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
