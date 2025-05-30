import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/typing.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/support/vm/chat.dart';

class SupportChatScreen extends ConsumerStatefulWidget {
  static const route = "/support/chat";
  const SupportChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
  late final notifier = ref.read(supportChatProvider.notifier);
  final handler = WayaObservableScrollController();
  final focusNode = FocusNode();
  final inputController = ChatInputController.instance;
  ChatModel? _currentChat;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        try {
          //inputController.setChat();
        } catch (_) {}
      },
    );

    //? This is fine.
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        try {
          // inputController.setChat();
        } catch (_) {}
      },
    );

    //? This is fine.
    super.reassemble();
  }

  // Helper function used to start a new support conversation.
  void _startSupportChat() async {}

  //? This is fine.
  Future<ChatModel?> _startConversation() async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // This is fine too.
    final theme = Theme.of(context);
    final state = ref.watch(supportChatProvider);

    //? Our support chat screen in all of its design and glory.
    return PopScope(
      onPopInvokedWithResult: (popping, _) {
        if (!popping) return;
        inputController.reset();
        notifier.setInactive();
      },
      child: WayaScaffold(
        isLoading: false,
        isScrollable: false,
        padding: EdgeInsets.zero,
        resizeToAvoidBottomInset: true,
        title: "Livechat Support",
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? First, the divider.
              Divider(color: theme.colorScheme.greyColor200, height: 1),

              //? Second, the chat messages.
              if (state.messages.isEmpty && state.hasLoaded)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //* First, the image.
                      WayaAssets.icons.mSupport.svg(
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),

                      // Some space.
                      const Gap(20),

                      //* Some text
                      Text(
                        "Have a problem?",
                        style: WayaTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                        ),
                      ),

                      // Some space.
                      const Gap(10),

                      //* Some text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Start a conversation with a support agent today",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: WayaTextStyles.hintStyle,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: WayaPaginatedListView<MessageModel>(
                    handler: handler,
                    nextPage: state.page,
                    itemCount: state.messages.length,
                    isAtEnd: !state.hasNextPage,
                    shouldFetch: !state.isLoading,
                    direction: Axis.vertical,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    physics: const AlwaysScrollableScrollPhysics(),
                    reverse: true,
                    getPage: (page) async {
                      return notifier.getSupportMessages();
                    },
                    builder: (context, index) => ChatBubbleWidget(
                      index: index,
                      inputFocus: focusNode,
                      chat: state.chat,
                      previousDate: index == 0 ? DateTime(1970) : state.messages[index - 1].createdAt,
                      data: state.messages[index],
                      controller: inputController,
                      isLast: index == state.messages.length - 1,
                    ),
                    child: state.typing
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PersonalTypingIndicator(),
                            ],
                          )
                        : null,
                  ),
                ),

              //? Third, the chat input widget.
              if (_currentChat == null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 10.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(50),
                  ),
                  child: Text.rich(
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: theme.textTheme.bodyMedium,
                    TextSpan(
                      children: [
                        //? First, the text itself.
                        TextSpan(
                          text: "Chat ended, ",
                        ),

                        //? Second, the other guy here.
                        TextSpan(
                          text: "start a new conversation ",
                          recognizer: TapGestureRecognizer()..onTap = _startSupportChat,
                          style: theme.textTheme.bodySemiBold.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        //? Third, the closing part of the text.
                        TextSpan(
                          text: "to chat with an agent",
                        ),
                      ],
                    ),
                  ),
                )
              else
                ChatInputWidget(
                  controller: inputController,
                  notifier: notifier,
                  voiceEnabled: false,
                  createChat: _startConversation,
                  focusNode: focusNode,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
