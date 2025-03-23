// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/controller/socket.dart';
import 'package:wayagram/features/chat/dto/chat.dart';
import 'package:wayagram/features/chat/modals/attachment.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/types/attachment.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/widget/chat/input/reply_to.dart';
import 'package:wayagram/features/chat/widget/chat/input/selected_file.dart';
import 'package:wayagram/features/chat/widget/chat/input/voice_note.dart';

class ChatInputController {
  /// The type of message that the chat input is currently going to send.
  final _currentType = ValueNotifier<MessageType>(MessageType.text);

  /// Is the kind of file we are sending an image?
  final _isMedia = ValueNotifier(false);

  /// The message that this
  final _replyTo = ValueNotifier<MessageModel?>(null);

  /// The message that this
  final _isEditing = ValueNotifier(false);

  /// Is the sound recorder open yet?
  final _isRecorderOpen = ValueNotifier(false);

  /// We use this to keep track of the voice recorder.
  final _recorderState = ValueNotifier(RecorderState.stopped);

  /// Our voice recorder.
  RecorderController? _soundRecorder;

  /// Our nice way of keeping track of what you are currently focusing on.
  FocusNode? _focusNode;

  /// Our momentId.
  String? _momentId;

  /// Where we keep the voice note currently being sent in chat.
  final _voiceMessage = ValueNotifier<String?>(null);

  /// The text editing controller that is used to keep track of the text that
  /// is currently ready to be sent.
  final _textController = TextEditingController();

  /// The list of files currently put inside of this one.
  final _files = ValueNotifier<List<File>>([]);

  /// The message that we are currently focusing on.
  final _focusedMessage = ValueNotifier<MessageModel?>(null);

  /// This is the list of contact that are being sent here.
  final _contacts = ValueNotifier<List<String>>([]);

  /// A helper button used to check whether we can sense the current message or
  /// not.
  final _canSend = ValueNotifier(false);

  /// Am I currently typing.
  final _isTyping = ValueNotifier(false);

  /// Our static
  static final instance = ChatInputController._();

  /// The chat that is bound to this chat input controller.
  ChatModel? _chat;

  void Function(bool)? _focusListener;

  // The constructor.
  ChatInputController._() {
    //? Request for permission.
    Permission.microphone.request().then(
      (status) async {
        //
      },
    );
  }

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
      _contacts.dispose();
      _focusedMessage.dispose();
      _recorderState.dispose();
      _isRecorderOpen.dispose();
      _voiceMessage.dispose();
      _isTyping.dispose();
      _soundRecorder?.dispose();
      _soundRecorder = null;
    } catch (_) {}
  }

  /// A utility function used to reset the state of all controllers inside of this
  /// one to prepare it for the next conversation.
  void reset() {
    _textController.clear();
    _replyTo.value = null;
    _canSend.value = false;
    _isEditing.value = false;
    _contacts.value = [];
    _files.value = [];
    _focusNode?.unfocus(disposition: UnfocusDisposition.scope);
    _focusedMessage.value = null;
    _isMedia.value = false;
    _momentId = null;
    _isTyping.value = false;
    _currentType.value = MessageType.text;
    _voiceMessage.value = null;
  }

  /// A helper function used to resume recording audio from the microphone. It is
  /// worth noting that this function should make sure the state of everything is
  /// in order.
  Future<void> resumeRecording() async {
    //? Only resume when this should be able to.
    if (_soundRecorder!.recorderState != RecorderState.paused) return;

    try {
      //? Resume
      await _soundRecorder!.record();

      //? Then update state.
      _recorderState.value = _soundRecorder!.recorderState;
    } catch (_) {}
  }

  /// A helper function used to pause recording for a while in order to actually
  /// get your bearings and breathe.
  Future<void> pauseRecording() async {
    //? Only pause when this should be able to.
    if (!_soundRecorder!.isRecording) return;

    //? This is fine.
    try {
      //? pause the recording.
      await _soundRecorder!.pause();

      //? Then update state.
      _recorderState.value = _soundRecorder!.recorderState;
    } catch (_) {}
  }

  /// A helper function that can be used to close the recording and then get
  /// the path to the file that stores the recording in question.
  Future<File?> stopRecording() async {
    try {
      //? First, obtain the URI we need.
      final result = await _soundRecorder!.stop();

      //? If this is null, just stop at this point with a null.
      if (result == null) return null;

      //? Now, we obtain the file in that location.
      final recordedFile = File(result);

      //? After obtaining this...
      if (!await recordedFile.exists()) {
        return null;
      }

      //? After moving forward.
      _recorderState.value = _soundRecorder!.recorderState;
      _voiceMessage.value = recordedFile.path;

      // You can now
      _canSend.value = true;

      //? Now, return the recorded file.
      return recordedFile;
    } catch (_) {}

    //? Return this issue.
    return null;
  }

  /// A helper function used to set the message that this input widget is
  /// supposed to be replying to.
  void quoteMessage(MessageModel? message, [bool isEditing = false, String? momentId]) {
    _replyTo.value = message;
    _isEditing.value = isEditing;
    _momentId = momentId;

    //? If you can request focus
    if (_focusNode!.canRequestFocus) {
      _focusNode!.requestFocus();
    }
  }

  /// A helper function used to set the type of message that this is currently
  /// prepping to send.
  void setMessageType(MessageType type) {
    _currentType.value = type;
  }

  /// A helper function used to set whether it is media files we are sending or
  /// not
  void setMedia(bool value) {
    _isMedia.value = value;
  }

  /// A helper function used to set the text inside this text controller to
  /// something.
  void setText(String text) {
    reset();
    _textController.text = text;
    _canSend.value = text.isNotEmpty;
  }

  /// A helper function used to remove a given file from the list of selected
  /// files using its index.
  void removeFile(int index) {
    _files.value.removeAt(index);

    // Notify all listeners.
    _files.value = [..._files.value];

    //? Now, we can send, if this is not empty.
    _canSend.value = _files.value.isNotEmpty;
  }

  /// A helper function used to initialize this controller with a new chat.
  void setChat(ChatModel? chat) async {
    _chat = chat;
    _soundRecorder ??= RecorderController();

    //? If permission was not granted.
    if (!await _soundRecorder!.checkPermission()) return;

    // This is fine.
    try {
      //? This is fine.
      _soundRecorder!.reset();

      //? Toggle state.
      _recorderState.value = _soundRecorder!.recorderState;

      //? Now, switch this to completed.
      _isRecorderOpen.value = true;
    } catch (_) {}
  }

  /// A helper function used to focus on a given message.
  void setFocus(MessageModel message) {
    _focusedMessage.value = message;
    _focusListener?.call(true);
  }

  /// A wonderful way of setting what to do when we focus away from this chat.
  void setFocusListener(void Function(bool) listener) {
    _focusListener = listener;
  }

  /// A helper function used to remove the message we are currently focusing on
  /// from focus.
  void clearFocus() {
    _focusedMessage.value = null;
    _focusListener?.call(false);
    _focusListener = null;
  }

  /// A helper function used to get the chat body that we would use for the
  String get buildBody {
    return _textController.text.trim();
  }

  /// A helper used to get the chat that is currently being controlled by this
  /// controller.
  ChatModel get chat => _chat!;

  /// A list of all the emojis that the person texting can use for reactions.
  List<String> get reactions => ['❤️', '👍', '🔥', '😂', '😮', '😢', '😡'];

  /// A helper function used to retrieve all of the selected files.
  List<File> get selectedFiles => _files.value;

  /// Is this currently in the action of editing a message?
  bool get isEditing => _isEditing.value;

  /// A stream used to monitor the sound recorder for when it makes any sizeable
  /// progress.
  Stream<Duration>? get onRecordingProgress => _soundRecorder!.onCurrentDuration;

  /// The current state of the audio recorder.
  RecorderState get recorderState => _recorderState.value;

  /// The message we are currently focusing on.
  MessageModel? get focusedMessage => _focusedMessage.value;

  /// A helper function used to retrieve the sound recorder that is currently
  /// being used.
  RecorderController get soundRecorder => _soundRecorder!;

  /// A helper function used to get whether or not this is currently consuming
  /// media files.
  bool get isMedia => _isMedia.value;

  /// Helper function used to build the message that would be sent to the server.
  SendMessageDto get buildMessage {
    // This is fine.
    return SendMessageDto(
      chatId: chat.id,
      type: _currentType.value,
      momentId: _momentId,
      originalMessageId: _replyTo.value?.id,
      originalMessage: _replyTo.value,
      content: buildBody,
      media: [if (_voiceMessage.value != null) _voiceMessage.value!, ..._files.value.map((file) => file.absolute.path)],
      contacts: _contacts.value.isEmpty ? null : _contacts.value,
    );
  }
}

/// The widget that is used to denote/represent the
class ChatInputWidget extends StatelessWidget {
  final ChatInputController controller;
  final ChatNotifier notifier;
  final FocusNode focusNode;
  final bool voiceEnabled;
  final bool padded;
  final Future<ChatModel?> Function() createChat;

  // Construct.
  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.notifier,
    required this.createChat,
    required this.focusNode,
    this.voiceEnabled = true,
    this.padded = true,
  });

  /// Helper function used to add an attachment.
  void _addAttachment(BuildContext context) async {
    final result = await WayaUtils.showModalSheet<AttachmentResult>(
      context,
      child: ChatAttachmentDialog(
        controller: controller,
      ),
    );

    // If this is defined...
    if (result == null) return;

    //? If there is actual data here and it is a file...
    if (result.type != MessageType.contact) {
      //? Change this to file.
      controller._currentType.value = result.type;

      //? Add all of the files that need to be added.
      controller._files.value.addAll(result.files?.map((file) => File(file)) ?? []);

      //? Update the value of this thing's controller.
      controller._files.value = [...controller._files.value];

      //? Now, we can send, if this is not empty.
      controller._canSend.value = controller._files.value.isNotEmpty;
    }
  }

  /// Helper function used to start recording a voice note.
  void _recordVoiceNote() async {
    try {
      //? If this cannot yet record, leave.
      if (!controller._isRecorderOpen.value) return;

      //? Start recording audio.
      await controller._soundRecorder!.record(
        path: await WayaFileHelper.getVoiceNoteFilePath(controller.chat.id),
        androidEncoder: AndroidEncoder.aac,
        androidOutputFormat: AndroidOutputFormat.mpeg4,
        iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
        sampleRate: 44100,
      );

      //? Now notify the caller that you are recording.
      controller._recorderState.value = controller._soundRecorder!.recorderState;
      controller._currentType.value = MessageType.voiceNote;
      controller._isRecorderOpen.value = true;

      //? This is fine.
      controller._canSend.value = false;
      controller._textController.clear();
    } catch (_) {}
  }

  /// Helper function used to send a message.
  void _sendMessage() async {
    //? If this conversation does not yet exist...
    if (controller._chat == null) {
      final chat = await createChat();
      controller.setChat(chat);
      if (chat != null) notifier.setChat(chat);
    }

    //? Since we are fine, do all the needful.
    final message = controller.buildMessage;
    final quoted = controller._replyTo.value;
    final isEdit = controller.isEditing;

    //? Reset the input controller before sending the message so it looks fast.
    controller.reset();

    //? If this is editing a message.
    if (isEdit) {
      //? If this is greater than 5 minutes ago...
      final result = await notifier.editMessage(quoted!.id, message.content ?? '');

      //? This is fine.
      if (!result) return;
    }

    //? If we are not editing and this contains multiple media...
    else if ((message.media?.length ?? 0) > 1) {
      final messages = message.fragmentMedia;

      //? This is fine.
      for (final singleMessage in messages) {
        //? Send the message.
        final result = await notifier.sendMessage(singleMessage);

        //? If this failed..
        if (result == null) return;
      }
    }

    //? If we are not editing and this contains one media.
    else {
      //? Send the message.
      final result = await notifier.sendMessage(message);

      //? If this succeeded...
      if (result == null) return;
    }

    // Notify the message listeners of the chat that we have read.
    WayaSocketController.instance.updateChats();
  }

  @override
  Widget build(BuildContext context) {
    //? For each time this gets constructed, notify the controller that the focus
    //? listener might have changed.
    controller._focusNode = focusNode;

    //? Return your widget.
    return Padding(
      padding: padded ? const EdgeInsets.only(left: 15, right: 15, bottom: 12) : EdgeInsets.zero,
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

          //? Fourth, the selected media space.
          ValueListenableBuilder(
            valueListenable: controller._files,
            builder: (context, selectedFiles, _) {
              //? If there is nothing to show...
              if (selectedFiles.isEmpty) return const SizedBox();

              //? Since there is something to show.
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // The actual chat file  component.
                  ChatFileListWidget(
                    controller: controller,
                    interactive: true,
                  ),

                  // Space after the selected media widget.
                  const Gap(6),
                ],
              );
            },
          ),

          //? Finally, the row for actual chat controls.
          ValueListenableBuilder(
            valueListenable: controller._currentType,
            builder: (context, messageType, _) {
              //? Return the row of components that also represent and contain the
              //? message input field.
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                    messageType == MessageType.voiceNote ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  //? First, the button for attaching content.
                  messageType == MessageType.voiceNote
                      ? const SizedBox()
                      : WayaButton(
                          callback: () => _addAttachment(context),
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
                  Gap(12.w),

                  //? Second, the input text
                  Expanded(
                    child: AnimatedCrossFade(
                      crossFadeState:
                          messageType == MessageType.voiceNote ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 350),
                      firstChild: messageType != MessageType.voiceNote
                          ? const SizedBox()
                          : ValueListenableBuilder(
                              valueListenable: controller._recorderState,
                              builder: (context, _, __) {
                                return ChatVoiceMessageInput(
                                  controller: controller,
                                );
                              },
                            ),
                      secondChild: TextField(
                        maxLines: 5,
                        minLines: 1,
                        focusNode: focusNode,
                        onChanged: (value) {
                          //? If this is a text message, allowing a user to send
                          //? a message would need to ENTIRELY depend on the
                          //? contents of the message text.
                          if (controller._currentType.value == MessageType.text) {
                            controller._canSend.value = value.trim().isNotEmpty;
                          }

                          //? If this has no chat yet...
                          if (controller._chat == null) return;

                          //? If this is not in the state we are thinking of...
                          if (!controller._isTyping.value) {
                            WayaSocketController.instance.emit(WayaChatSocketArgs.typing(controller.chat.id, true));
                            controller._isTyping.value = true;
                          }

                          //? Since this is the case, emit the typing event so
                          //? everyone knows this user is typing.
                          debounce(key: "control-typing", delay: const Duration(milliseconds: 800), () {
                            WayaSocketController.instance.emit(WayaChatSocketArgs.typing(controller.chat.id, false));
                            controller._isTyping.value = false;
                          })();
                        },
                        style: WayaTextStyles.labelMedium,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          fillColor: WayaColors.greyColor200,
                          filled: true,
                          hintText: "Write a message here",
                          hintStyle: WayaTextStyles.hintStyle,
                          labelStyle: WayaTextStyles.labelSmall,
                        ),
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        controller: controller._textController,
                      ),
                    ),
                  ),

                  // Some space.
                  Gap(12.w),

                  //? Third, the button for either sending messages.
                  ValueListenableBuilder(
                    valueListenable: controller._canSend,
                    builder: (context, canSend, _) {
                      //? If voice messages cannot be sent
                      if (!voiceEnabled) {
                        return AnimatedCrossFade(
                          duration: const Duration(milliseconds: 350),
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
                            callback: null,
                            height: null,
                            color: WayaColors.greyColor200,
                            horizontalPadding: 10,
                            verticalPadding: 10,
                            centerWidget: WayaAssets.icons.cSend.svg(
                              color: WayaColors.black,
                              height: 18,
                              width: 18,
                            ),
                          ),
                        );
                      }

                      //? Since we cannot send yet, show this message type's
                      //? protocol icon.
                      return AnimatedCrossFade(
                        duration: const Duration(milliseconds: 350),
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
                        secondChild: ValueListenableBuilder(
                          valueListenable: controller._recorderState,
                          builder: (context, recorderState, _) {
                            return AnimatedCrossFade(
                              crossFadeState:
                                  recorderState == RecorderState.stopped || recorderState == RecorderState.initialized
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 350),
                              firstChild: WayaButton(
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
                              secondChild: WayaButton(
                                callback: controller.stopRecording,
                                height: null,
                                color: WayaColors.greyColor200,
                                horizontalPadding: 10,
                                verticalPadding: 10,
                                centerWidget: WayaAssets.icons.cStop.svg(
                                  color: WayaColors.black,
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            );
                          },
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
