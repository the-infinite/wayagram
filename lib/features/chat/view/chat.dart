// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/conversation_vm.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/my_bubble_widget.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/general_settings/chat_settings/vm.dart';
import 'package:wayagram/shared/cache/chat.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class SingleChatScreen extends ConsumerStatefulWidget {
  static const route = "/conversation/chat";
  final String chatId;

  // This is fine.
  const SingleChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends ConsumerState<SingleChatScreen>
    with AutomaticKeepAliveClientMixin {
  late final ChatNotifier notifier;
  late final ConversationVm conversationNotifier;
  final focusNode = FocusNode();
  final handler = WayaObservableScrollController();
  bool _initialized = false;

  @override
  void initState() {
    notifier = ref.read(chatProvider(widget.chatId).notifier);
    conversationNotifier = ref.read(conversationProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ChatInputController.instance.setRef(ref);
        notifier.getMessages(true);
      },
    );

    //? This is fine.
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    focusNode.dispose();
    handler.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ChatInputController.instance.setRef(ref);
        notifier.getMessages(true, true);
      },
    );

    //? This is fine.
    super.reassemble();
  }

  // We start a video call.
  void _startAudioCall() async {
    WayaNavigationHelper.showComingSoonModal(true);
  }

  // We start a video call.
  void _startVideoCall() async {
    WayaNavigationHelper.showComingSoonModal(true);
  }

  Future<ChatModel?> _startConversation() async {
    return null;
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: ChatSettingsNotifier.instance,
      builder: (context, redraws, _) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(chatProvider(widget.chatId));
          if (state.chat == null) return const SizedBox.shrink();

          return _ChatScreen(
            chatId: widget.chatId,
            state: state,
            notifier: notifier,
            focusNode: focusNode,
            handler: handler,
            onInitialized: _handleInitialization,
            onStartVideoCall: _startVideoCall,
            onStartAudioCall: _startAudioCall,
            onCreateChat: _startConversation,
          );
        },
      ),
    );
  }

  void _handleInitialization(ChatModel chat) {
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initialized = true;
        ChatInputController.instance.setChat(chat);
      });
    }
  }
}

class _ChatScreen extends StatelessWidget {
  final String chatId;
  final dynamic state;
  final ChatNotifier notifier;
  final FocusNode focusNode;
  final WayaObservableScrollController handler;
  final Function(ChatModel) onInitialized;
  final VoidCallback onStartVideoCall;
  final VoidCallback onStartAudioCall;
  final Future<ChatModel?> Function() onCreateChat;

  const _ChatScreen({
    required this.chatId,
    required this.state,
    required this.notifier,
    required this.focusNode,
    required this.handler,
    required this.onInitialized,
    required this.onStartVideoCall,
    required this.onStartAudioCall,
    required this.onCreateChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = ChatSettingsNotifier.instance;
    final chat = state.chat!;
    final inputController = ChatInputController.instance;
    final themeData = _ChatThemeData.fromConfig(config);

    onInitialized(chat);

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
        backgroundColor: themeData.backgroundColor,
        appBar: _buildAppBar(theme, chat, themeData),
        body: _buildBody(chat, inputController, themeData),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    ThemeData theme,
    ChatModel chat,
    _ChatThemeData themeData,
  ) {
    return AppBar(
      toolbarHeight: kToolbarHeight,
      leadingWidth: double.infinity,
      backgroundColor: themeData.backgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        height: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            WayaBackButton(
              buttonBackgroundColor: themeData.buttonBackgroundColor,
              arrowColor: themeData.arrowColor,
            ),
            const Gap(10),
            Expanded(
              child: InkWell(
                splashColor: theme.colorScheme.primary.withAlpha(30),
                focusColor: theme.colorScheme.primary.withAlpha(30),
                highlightColor: theme.colorScheme.primary.withAlpha(30),
                customBorder: const StadiumBorder(),
                splashFactory: NoSplash.splashFactory,
                onTap: () =>
                    WayaNav.toNamed(WayaAppRoutes.getChatProfile(chat.id)),
                child: ValueListenableBuilder(
                  valueListenable: wayaChatsCache,
                  builder: (context, redraws, _) {
                    final currentChat =
                        wayaChatsCache.getCachedData(chatId) ?? chat;
                    final chatUser = currentChat.other.chatUser;
                    final userStatus = (chatUser?.canSeeOnlineStatus ?? true)
                        ? chatUser?.onlineStatus ?? ChatUserActivity.offline
                        : ChatUserActivity.offline;

                    String? subtitle;
                    if (currentChat.chatType == ChatType.group) {
                      subtitle =
                          "${WayaValueHelper.formatNumber(currentChat.chatMembers.length)} members";
                    } else if (userStatus == ChatUserActivity.online) {
                      subtitle = "Online";
                    } else if (chatUser?.lastSeen != null &&
                        (chatUser?.canSeeLastSeen ?? true)) {
                      subtitle =
                          "Last seen ${WayaDateHelper.getSocialTimestamp(chatUser!.lastSeen).toLowerCase()}";
                    }

                    return Row(
                      spacing: 5.w,
                      children: [
                        ChatProfilePicture(
                          user: currentChat.other.userData ??
                              ConversationState.self,
                          showActive: currentChat.chatType != ChatType.group &&
                              userStatus == ChatUserActivity.online,
                          lastSeen: currentChat.other.chatUser?.lastSeen,
                          chat: currentChat,
                          radius: 16,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentChat.name ??
                                      currentChat.other.userData?.fullname ??
                                      currentChat.other.chatUser?.displayName ??
                                      "WayaGram User",
                                  maxLines: 1,
                                  style: WayaTextStyles.titleMedium.copyWith(
                                    fontSize: 15.sp,
                                    color: themeData.textColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (subtitle != null)
                                  Text(
                                    subtitle,
                                    maxLines: 1,
                                    style: WayaTextStyles.titleMedium.copyWith(
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.ellipsis,
                                      color: themeData.grayTextColor,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IntrinsicHeight(
                child: WayaButton(
                  callback: onStartVideoCall,
                  height: null,
                  color: themeData.buttonBackgroundColor,
                  horizontalPadding: 8,
                  verticalPadding: 8,
                  centerWidget: WayaAssets.icons.cCallVideo.svg(
                    color: themeData.arrowColor,
                    height: 15,
                    width: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IntrinsicHeight(
                child: WayaButton(
                  callback: onStartAudioCall,
                  height: null,
                  color: themeData.buttonBackgroundColor,
                  horizontalPadding: 8,
                  verticalPadding: 8,
                  centerWidget: WayaAssets.icons.cCallVoice.svg(
                    color: themeData.arrowColor,
                    height: 15,
                    width: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    ChatModel chat,
    dynamic inputController,
    _ChatThemeData themeData,
  ) {
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) => focusNode.unfocus(),
        child: Column(
          children: [
            Divider(color: WayaColors.greyColor200, height: 1),
            _buildChatContent(chat, inputController, themeData),
            _buildChatInput(inputController, themeData),
          ],
        ),
      ),
    );
  }

  Widget _buildChatContent(
    ChatModel chat,
    dynamic inputController,
    _ChatThemeData themeData,
  ) {
    if (state.messages.isEmpty && state.hasLoaded) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WayaAssets.images.cSayHello.image(
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
            const Gap(20),
            Text(
              "Send the first message",
              style: WayaTextStyles.titleLarge.copyWith(
                color: themeData.textColor,
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
              ),
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                chat.chatType == ChatType.group
                    ? "Start the conversation in ${chat.name ?? "Group Chat"} with your friends!"
                    : "Start the conversation with ${chat.other.userData?.fullname ?? chat.other.chatUser?.displayName ?? "WayaGram User"}",
                maxLines: 3,
                textAlign: TextAlign.center,
                style: WayaTextStyles.hintStyle.copyWith(
                  color: themeData.grayTextColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: WayaPaginatedListView<MessageModel>(
        handler: handler,
        nextPage: state.page,
        itemCount: state.messages.length,
        isAtEnd: !state.hasNextPage,
        shouldFetch: !state.isLoading,
        direction: Axis.vertical,
        onScroll: (controller) => focusNode.unfocus(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        physics: const AlwaysScrollableScrollPhysics(),
        reverse: true,
        getPage: (page) async => notifier.getMessages(),
        builder: (context, index) => ChatBubbleWidget(
          index: index,
          inputFocus: focusNode,
          previousDate:
              index == 0 ? DateTime(1970) : state.messages[index - 1].createdAt,
          data: state.messages[index],
          chat: chat,
          controller: inputController,
          isLast: index == state.messages.length - 1,
          isDark: themeData.isDarkMode,
          grayColor: themeData.grayTextColor,
          backgroundColor: themeData.backgroundColor,
          textScale: themeData.textScale,
        ),
      ),
    );
  }

  Widget _buildChatInput(
    dynamic inputController,
    _ChatThemeData themeData,
  ) {
    return ChatInputWidget(
      controller: inputController,
      notifier: notifier,
      createChat: onCreateChat,
      focusNode: focusNode,
      isDark: themeData.isDarkMode,
      grayColor: themeData.grayTextColor,
      backgroundColor: themeData.backgroundColor,
    );
  }
}

class _ChatThemeData {
  final bool isDarkMode;
  final Color? backgroundColor;
  final Color grayTextColor;
  final Color? textColor;
  final Color buttonBackgroundColor;
  final Color arrowColor;
  final double textScale;

  const _ChatThemeData({
    required this.isDarkMode,
    required this.backgroundColor,
    required this.grayTextColor,
    required this.textColor,
    required this.buttonBackgroundColor,
    required this.arrowColor,
    required this.textScale,
  });

  factory _ChatThemeData.fromConfig(dynamic config) {
    return _ChatThemeData(
      isDarkMode: config.isDarkMode,
      backgroundColor: config.isDarkMode ? const Color(0xFF121212) : null,
      grayTextColor:
          config.isDarkMode ? WayaColors.greyColor300 : WayaColors.greyColor500,
      textColor: config.isDarkMode ? Colors.white : null,
      buttonBackgroundColor:
          config.isDarkMode ? WayaColors.darkGrey : WayaColors.greyColor200,
      arrowColor: config.isDarkMode ? Colors.white : WayaColors.black,
      textScale: config.textScale,
    );
  }
}
