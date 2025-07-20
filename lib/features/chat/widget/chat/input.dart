// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/controller/socket.dart';
import 'package:wayagram/features/chat/dto/chat.dart';
import 'package:wayagram/features/chat/modals/attachment.dart';
import 'package:wayagram/features/chat/modals/delete.dart';
import 'package:wayagram/features/chat/modals/unblock.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/types/attachment.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
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

  /// Our current widget reference.
  WidgetRef? _ref;

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

  /// A helper function that can be used to close the recording and then delete
  /// the file if it has already been made.
  Future<bool> cancelRecording() async {
    try {
      //? First, obtain the URI we need.
      final result = _voiceMessage.value ?? await _soundRecorder!.stop();

      //? If this is null, just stop at this point with a null.
      if (result == null) return false;

      //? Now, we obtain the file in that location.
      final recordedFile = File(result);

      //? After obtaining this...
      if (!await recordedFile.exists()) {
        return true;
      }

      //? After moving forward.
      _recorderState.value = _soundRecorder!.recorderState;
      _currentType.value = MessageType.text;
      _voiceMessage.value = null;
      _canSend.value = _textController.text.trim().isNotEmpty;

      //? Then we move forward.
      await recordedFile.delete();

      //? Now, return the recorded file.
      return !await recordedFile.exists();
    } catch (_) {}

    //? Return this issue.
    return false;
  }

  /// A helper function used to set the message that this input widget is
  /// supposed to be replying to.
  void quoteMessage(MessageModel? message,
      [bool isEditing = false, String? momentId]) {
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

  /// A helper function used to set the current widget reference.
  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  /// A helper used to get the current widget reference.
  WidgetRef? get ref => _ref;

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
  Stream<Duration>? get onRecordingProgress =>
      _soundRecorder!.onCurrentDuration;

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
      id: WayaValueHelper.createUid(),
      chatId: chat.id,
      type: _currentType.value,
      momentId: _momentId,
      originalMessageId: _replyTo.value?.id,
      originalMessage: _replyTo.value,
      content: buildBody,
      media: [
        if (_voiceMessage.value != null) _voiceMessage.value!,
        ..._files.value.map((file) => file.absolute.path)
      ],
      contacts: _contacts.value.isEmpty ? null : _contacts.value,
    );
  }
}

/// The widget that is used to denote/represent the
class ChatInputWidget extends StatefulWidget {
  final ChatInputController controller;
  final ChatNotifier notifier;
  final FocusNode focusNode;
  final bool voiceEnabled;
  final bool padded;
  final Future<ChatModel?> Function() createChat;
  final bool isDark;
  final Color? backgroundColor;
  final Color? grayColor;

  // Construct.
  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.notifier,
    required this.createChat,
    required this.focusNode,
    this.isDark = false,
    this.voiceEnabled = true,
    this.padded = true,
    this.backgroundColor,
    this.grayColor,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final deleteController = ValueNotifier(false);
  final unblockController = ValueNotifier(false);

  /// Helper function used to add an attachment.
  void _addAttachment(BuildContext context) async {
    //? Try to access all of the storage here.
    if (!await Permission.manageExternalStorage.request().isGranted) {
      //WayaSnackBar.showToast("You denied the storage permission");
      //return;
    }

    //? Ask for the camera permission too.
    if (!await Permission.camera.request().isGranted) {
      //WayaSnackBar.showToast("You denied the storage permission");
      //return;
    }
    //? Okay.
    final result = await WayaUtils.showModalSheet<AttachmentResult>(
      context,
      backgroundColor: widget.backgroundColor,
      child: ChatAttachmentDialog(
        controller: widget.controller,
        isDarkMode: widget.isDark,
        backgroundColor: widget.backgroundColor,
        grayColor: widget.grayColor,
      ),
    );

    // If this is defined...
    if (result == null) return;

    //? If there is actual data here and it is a file...
    if (result.type != MessageType.contact) {
      //? Change this to file.
      widget.controller._currentType.value = result.type;

      //? Add all of the files that need to be added.
      widget.controller._files.value
          .addAll(result.files?.map((file) => File(file)) ?? []);

      //? Update the value of this thing's controller.
      widget.controller._files.value = [...widget.controller._files.value];

      //? Now, we can send, if this is not empty.
      widget.controller._canSend.value =
          widget.controller._files.value.isNotEmpty;
    }
  }

  /// Helper function used to start recording a voice note.
  void _recordVoiceNote() async {
    try {
      //? If this cannot yet record, leave.
      if (!widget.controller._isRecorderOpen.value) return;

      //? Start recording audio.
      await widget.controller._soundRecorder!.record(
        path: await WayaFileHelper.getVoiceNoteFilePath(
            widget.controller.chat.id),
        androidEncoder: AndroidEncoder.aac,
        androidOutputFormat: AndroidOutputFormat.mpeg4,
        iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
        sampleRate: 44100,
      );

      //? Now notify the caller that you are recording.
      widget.controller._recorderState.value =
          widget.controller._soundRecorder!.recorderState;
      widget.controller._currentType.value = MessageType.voiceNote;
      widget.controller._isRecorderOpen.value = true;

      //? This is fine.
      widget.controller._canSend.value = false;
      widget.controller._textController.clear();
    } catch (_) {}
  }

  /// Helper function used to send a message.
  void _sendMessage() async {
    //? If this conversation does not yet exist...
    if (widget.controller._chat == null) {
      final chat = await widget.createChat();
      widget.controller.setChat(chat);
      if (chat != null) widget.notifier.setChat(chat);
    }

    //? Since we are fine, do all the needful.
    final message = widget.controller.buildMessage;
    final quoted = widget.controller._replyTo.value;
    final isEdit = widget.controller.isEditing;

    //? Reset the input controller before sending the message so it looks fast.
    widget.controller.reset();

    //? If this is editing a message.
    if (isEdit) {
      //? If this is greater than 5 minutes ago...
      final result =
          await widget.notifier.editMessage(quoted!.id, message.content ?? '');

      //? This is fine.
      if (!result) return;
    }

    //? If we are not editing and this contains multiple media...
    else if ((message.media?.length ?? 0) > 1) {
      final messages = message.fragmentMedia;

      //? This is fine.
      for (final singleMessage in messages) {
        //? Send the message.
        final result = await widget.notifier.sendMessage(singleMessage);

        //? If this failed..
        if (result == null) return;
      }
    }

    //? If we are not editing and this contains one media.
    else {
      //? Send the message.
      final result = await widget.notifier.sendMessage(message);

      //? If this succeeded...
      if (result == null) return;
    }

    // Notify the message listeners of the chat that we have read.
    WayaSocketController.instance.updateChats();
  }

  @override
  void dispose() {
    deleteController.dispose();
    unblockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    final theme = Theme.of(context);

    //? For each time this gets constructed, notify the controller that the focus
    //? listener might have changed.
    widget.controller._focusNode = widget.focusNode;

    //? Return your widget.
    return Padding(
      padding: widget.padded
          ? const EdgeInsets.only(left: 15, right: 15, bottom: 12)
          : EdgeInsets.zero,
      child: WayaErrorWidget(
        onError: (context, e) => const SizedBox(),
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            final conversationState = ref.watch(conversationProvider);
            final conversationNotifier =
                ref.read(conversationProvider.notifier);
            final chat = widget.controller._chat;

            //? How fair enough.
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //? Extra, the divider.
                Divider(color: WayaColors.greyColor200, height: 0),

                //? First, some space before the reply-to
                const Gap(6),

                //? If this is a personal chat and the user is blocked...
                if (chat != null &&
                    chat.chatType == ChatType.personal &&
                    conversationState.isBlocked(chat.other.userId)) ...[
                  //? A notice that tells the user that he or she cannot message this person.
                  Text(
                    "You can't send messages to this user",
                    textAlign: TextAlign.center,
                    style: WayaTextStyles.hintStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  //? Third, a way to either delete the conversation or to unblock it.
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      spacing: 10.w,
                      children: [
                        //? First, a button to delete this chat.
                        Expanded(
                          child: WayaProgressiveButton(
                            notifier: deleteController,
                            callback: () async {
                              final result =
                                  await WayaUtils.showModalSheet<bool>(
                                context,
                                isDismissible: false,
                                child: DeleteChatModal(
                                  chat: chat,
                                  notifier: conversationNotifier,
                                ),
                              );

                              //? This is fine.
                              if (result ?? false) {
                                WayaNav.goBack(closeOverlays: true);
                              }
                            },
                            text: "Delete chat",
                            color: WayaColors.error,
                          ),
                        ),

                        //? Second a button to unblock this user.
                        Expanded(
                          child: WayaProgressiveButton(
                            notifier: unblockController,
                            callback: () async {
                              final result =
                                  await WayaUtils.showModalSheet<bool?>(
                                context,
                                child: UnblockUserDialog(
                                  user: chat.other.userData!,
                                  profile: chat.other.profileData!,
                                  ref: ref,
                                ),
                              );

                              // If this is defined...
                              if (result == null) return;

                              //? Then pop.
                              if (result) {
                                WayaSnackBar.showToast(
                                    "This user has been unblocked successfully");
                              }
                            },
                            text: "Unblock user",
                            color: WayaColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]

                //? All is good and fine.
                else ...[
                  //? First, the typing indicator.
                  ValueListenableBuilder(
                    valueListenable: widget.notifier.typingNotifier,
                    builder: (context, redraws, _) {
                      //? The users typing.
                      final usersTyping = widget.notifier.usersTyping;

                      //? If there are no users typing....
                      if (usersTyping.isEmpty) {
                        return const SizedBox();
                      }

                      //? Since there are people typing.
                      //? First, build the text.
                      String text =
                          "${chat!.find(usersTyping.first)!.userData!.fullname} is typing";

                      //? If exactly two users are typing...
                      if (usersTyping.length == 2) {
                        final first = chat.find(usersTyping.first)!;
                        final last = chat.find(usersTyping.last)!;

                        //? Now, let's look for others.
                        text =
                            "${first.userData!.fullname} and ${last.userData!.fullname} are typing";
                      }

                      //? If this has three people exactly...
                      if (usersTyping.length == 3) {
                        final first =
                            chat.find(usersTyping.elementAt(0))!.userData;
                        final second =
                            chat.find(usersTyping.elementAt(1))!.userData;
                        final last =
                            chat.find(usersTyping.elementAt(2))!.userData;

                        //? Now, build it.
                        text =
                            "${first?.fullname}, ${second?.fullname} and ${last?.fullname} are typing";
                      }

                      //? If this has more than 3 users...
                      if (usersTyping.length > 3) {
                        final first =
                            chat.find(usersTyping.elementAt(0))!.userData;
                        final second =
                            chat.find(usersTyping.elementAt(1))!.userData;
                        final last =
                            chat.find(usersTyping.elementAt(2))!.userData;

                        //? Now, build it.
                        text =
                            "${first?.fullname}, ${second?.fullname}, ${last?.fullname} and ${usersTyping.length - 3} others are typing";
                      }

                      //? Show the user the pill containing who is typing.
                      return IntrinsicWidth(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary50,
                            borderRadius: BorderRadius.circular(100000.r),
                          ),
                          child: Text(
                            text,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyBold.copyWith(
                              color: theme.colorScheme.primary,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  //? Second, the reply to ..
                  ValueListenableBuilder(
                    valueListenable: widget.controller._replyTo,
                    builder: (context, message, _) {
                      //? If this is not defined...
                      if (message == null) return const SizedBox();

                      //? Since it is defined...
                      return ChatReplyToWidget(
                        message: message,
                        controller: widget.controller,
                        chat: chat!,
                        isDarkMode: widget.isDark,
                      );
                    },
                  ),

                  //? Third, the space after the reply to
                  const Gap(6),

                  //? Fourth, the selected media space.
                  ValueListenableBuilder(
                    valueListenable: widget.controller._files,
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
                            controller: widget.controller,
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
                    valueListenable: widget.controller._currentType,
                    builder: (context, messageType, _) {
                      //? Return the row of components that also represent and contain the
                      //? message input field.
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: messageType == MessageType.voiceNote
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          //? First, the button for attaching content.
                          messageType == MessageType.voiceNote
                              ? const SizedBox()
                              : WayaButton(
                                  callback: () => _addAttachment(context),
                                  height: null,
                                  color: widget.isDark
                                      ? WayaColors.darkGrey
                                      : WayaColors.greyColor200,
                                  horizontalPadding: 10,
                                  verticalPadding: 10,
                                  centerWidget:
                                      WayaAssets.icons.cButtonAttach.svg(
                                    color: widget.isDark
                                        ? Colors.white
                                        : WayaColors.black,
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
                                  messageType == MessageType.voiceNote
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 350),
                              firstChild: messageType != MessageType.voiceNote
                                  ? const SizedBox()
                                  : ValueListenableBuilder(
                                      valueListenable:
                                          widget.controller._recorderState,
                                      builder: (context, _, __) =>
                                          ChatVoiceMessageInput(
                                        controller: widget.controller,
                                      ),
                                    ),
                              secondChild: TextField(
                                maxLines: 5,
                                minLines: 1,
                                focusNode: widget.focusNode,
                                onChanged: (value) {
                                  //? If this is a text message, allowing a user to send
                                  //? a message would need to ENTIRELY depend on the
                                  //? contents of the message text.
                                  if (widget.controller._currentType.value ==
                                      MessageType.text) {
                                    widget.controller._canSend.value =
                                        value.trim().isNotEmpty;
                                  }

                                  //? If this has no chat yet...
                                  if (widget.controller._chat == null) return;

                                  //? If this is not in the state we are thinking of...
                                  if (!widget.controller._isTyping.value) {
                                    WayaSocketController.instance.emit(
                                        WayaChatSocketArgs.typing(
                                            widget.controller.chat.id, true));
                                    widget.controller._isTyping.value = true;
                                  }

                                  //? Since this is the case, emit the typing event so
                                  //? everyone knows this user is typing.
                                  debounce(
                                      key: "control-typing",
                                      delay: const Duration(milliseconds: 800),
                                      () {
                                    WayaSocketController.instance.emit(
                                        WayaChatSocketArgs.typing(
                                            widget.controller.chat.id, false));
                                    widget.controller._isTyping.value = false;
                                  })();
                                },
                                style: WayaTextStyles.labelMedium.copyWith(
                                  color: widget.isDark ? Colors.white : null,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 9.h),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  fillColor: widget.isDark
                                      ? WayaColors.darkGrey
                                      : WayaColors.greyColor200,
                                  filled: true,
                                  hintText: "Write a message here",
                                  hintStyle: WayaTextStyles.hintStyle.copyWith(
                                    color: widget.isDark ? Colors.white : null,
                                  ),
                                  labelStyle:
                                      WayaTextStyles.labelSmall.copyWith(
                                    color: widget.isDark ? Colors.white : null,
                                  ),
                                ),
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                controller: widget.controller._textController,
                              ),
                            ),
                          ),

                          // Some space.
                          Gap(12.w),

                          //? Third, the button for either sending messages.
                          ValueListenableBuilder(
                            valueListenable: widget.controller._canSend,
                            builder: (context, canSend, _) {
                              //? If voice messages cannot be sent
                              if (!widget.voiceEnabled) {
                                return AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 350),
                                  crossFadeState: canSend
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
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
                                    color: widget.isDark
                                        ? WayaColors.darkGrey
                                        : WayaColors.greyColor200,
                                    horizontalPadding: 10,
                                    verticalPadding: 10,
                                    centerWidget: WayaAssets.icons.cSend.svg(
                                      color: widget.isDark
                                          ? Colors.white
                                          : WayaColors.black,
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
                                crossFadeState: canSend
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
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
                                  valueListenable:
                                      widget.controller._recorderState,
                                  builder: (context, recorderState, _) {
                                    return AnimatedCrossFade(
                                      crossFadeState: recorderState ==
                                                  RecorderState.stopped ||
                                              recorderState ==
                                                  RecorderState.initialized
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                      duration:
                                          const Duration(milliseconds: 350),
                                      firstChild: WayaButton(
                                        callback: _recordVoiceNote,
                                        height: null,
                                        color: widget.isDark
                                            ? WayaColors.darkGrey
                                            : WayaColors.greyColor200,
                                        horizontalPadding: 10,
                                        verticalPadding: 10,
                                        centerWidget: WayaAssets
                                            .icons.cButtonVoicenote
                                            .svg(
                                          color: widget.isDark
                                              ? Colors.white
                                              : WayaColors.black,
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                      secondChild: WayaButton(
                                        callback:
                                            widget.controller.stopRecording,
                                        height: null,
                                        color: widget.isDark
                                            ? WayaColors.darkGrey
                                            : WayaColors.greyColor200,
                                        horizontalPadding: 10,
                                        verticalPadding: 10,
                                        centerWidget:
                                            WayaAssets.icons.cStop.svg(
                                          color: widget.isDark
                                              ? Colors.white
                                              : WayaColors.black,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
