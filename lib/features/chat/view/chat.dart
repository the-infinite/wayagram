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
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/default.dart';
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

class _SingleChatScreenState extends ConsumerState<SingleChatScreen> {
  late final notifier = ref.read(chatProvider(widget.chatId).notifier);
  late final conversationNotifier = ref.read(conversationProvider.notifier);
  final focusNode = FocusNode();
  final handler = WayaObservableScrollController();
  bool _initialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        notifier.markAllAsRead().then((result) {
          if (!result) return;
          conversationNotifier.getChats(true);
          conversationNotifier.getArchivedChats(true);
        });
        ChatInputController.instance.setRef(ref);
        notifier.getMessages(true);
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
    // Get the theme.
    final theme = Theme.of(context);

    // This is fine.
    return ValueListenableBuilder(
      valueListenable: ChatSettingsNotifier.instance,
      builder: (context, redraws, _) => Consumer(
        builder: (context, ref, _) {
          final provider = chatProvider(widget.chatId);
          final state = ref.watch(provider);
          final config = ChatSettingsNotifier.instance;
          final backgroundColor = config.isDarkMode ? Color(0xFF121212) : null;
          final grayTextColor = config.isDarkMode ? WayaColors.greyColor300 : WayaColors.greyColor500;

          //? If this is after the state of this has been reset.
          if (state.chat == null) return const SizedBox();

          //? Since there is something to be seen here.
          final chat = state.chat!;
          final inputController = ChatInputController.instance;

          // Set this up.
          if (!_initialized) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                _initialized = true;
                inputController.setChat(chat);
              },
            );
          }

          //? This is fine.
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
              backgroundColor: backgroundColor,
              appBar: AppBar(
                toolbarHeight: kToolbarHeight,
                leadingWidth: double.infinity,
                backgroundColor: backgroundColor,
                surfaceTintColor: Colors.transparent,
                leading: Container(
                  height: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //* The back button, first.
                      WayaBackButton(
                        buttonBackgroundColor: config.isDarkMode ? WayaColors.darkGrey : WayaColors.greyColor200,
                        arrowColor: config.isDarkMode ? Colors.white : WayaColors.black,
                      ),

                      // Some space.
                      const Gap(10),

                      //* Second the profile picture and name.
                      Expanded(
                        child: InkWell(
                          splashColor: theme.colorScheme.primary.withAlpha(30),
                          focusColor: theme.colorScheme.primary.withAlpha(30),
                          highlightColor: theme.colorScheme.primary.withAlpha(30),
                          customBorder: StadiumBorder(),
                          splashFactory: NoSplash.splashFactory,
                          onTap: () => WayaNav.toNamed(WayaAppRoutes.getChatProfile(chat.id)),
                          child: ValueListenableBuilder(
                            valueListenable: wayaChatsCache,
                            builder: (context, redraws, _) {
                              // Ensure we area always using the most up to date version of this chat.
                              final chat = wayaChatsCache.getCachedData(widget.chatId) ?? state.chat!;
                              final chatUser = chat.other.chatUser;
                              final userStatus = (chatUser?.canSeeOnlineStatus ?? true)
                                  ? chatUser?.onlineStatus
                                  : ChatUserActivity.offline;
                              final lastSeenText = chatUser?.lastSeen != null && (chatUser?.canSeeLastSeen ?? true)
                                  ? "Last seen ${WayaDateHelper.getSocialTimestamp(chat.other.chatUser!.lastSeen).toLowerCase()}"
                                  : null;

                              //? This is the correct chat.
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 5.w,
                                children: [
                                  // First, the user's profile picture.
                                  ChatProfilePicture(
                                    user: chat.other.userData ?? ConversationState.self,
                                    showActive:
                                        chat.chatType != ChatType.group && userStatus == ChatUserActivity.online,
                                    lastSeen: chat.other.chatUser?.lastSeen,
                                    chat: chat,
                                    radius: 16,
                                  ),

                                  // Second, the user's name.
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //* For the other person's name.
                                          Text(
                                            chat.name ??
                                                chat.other.userData?.fullname ??
                                                chat.other.chatUser?.displayName ??
                                                "WayaGram User",
                                            maxLines: 1,
                                            style: WayaTextStyles.titleMedium.copyWith(
                                              fontSize: 15.sp,
                                              color: config.isDarkMode ? Colors.white : null,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          //? For the message content...
                                          if (chat.chatType == ChatType.group)
                                            Text(
                                              "${WayaValueHelper.formatNumber(chat.chatMembers.length)} members",
                                              maxLines: 1,
                                              style: WayaTextStyles.titleMedium.copyWith(
                                                fontWeight: FontWeight.normal,
                                                overflow: TextOverflow.ellipsis,
                                                color: grayTextColor,
                                                fontSize: 13.sp,
                                              ),
                                            )
                                          else if (userStatus == ChatUserActivity.online)
                                            Text(
                                              "Online",
                                              maxLines: 1,
                                              style: WayaTextStyles.titleMedium.copyWith(
                                                fontWeight: FontWeight.normal,
                                                overflow: TextOverflow.ellipsis,
                                                color: grayTextColor,
                                                fontSize: 13.sp,
                                              ),
                                            )
                                          else if (lastSeenText != null)
                                            Text(
                                              lastSeenText,
                                              maxLines: 1,
                                              style: WayaTextStyles.titleMedium.copyWith(
                                                fontWeight: FontWeight.normal,
                                                overflow: TextOverflow.ellipsis,
                                                color: grayTextColor,
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

                      //* Third, the video call button.
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: IntrinsicHeight(
                          child: WayaButton(
                            callback: _startVideoCall,
                            height: null,
                            color: config.isDarkMode ? WayaColors.darkGrey : WayaColors.greyColor200,
                            horizontalPadding: 8,
                            verticalPadding: 8,
                            centerWidget: WayaAssets.icons.cCallVideo.svg(
                              color: config.isDarkMode ? Colors.white : WayaColors.black,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                      ),

                      //* Fourth, the audio call button.
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: IntrinsicHeight(
                          child: WayaButton(
                            callback: _startAudioCall,
                            height: null,
                            color: config.isDarkMode ? WayaColors.darkGrey : WayaColors.greyColor200,
                            horizontalPadding: 8,
                            verticalPadding: 8,
                            centerWidget: WayaAssets.icons.cCallVoice.svg(
                              color: config.isDarkMode ? Colors.white : WayaColors.black,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanUpdate: (details) => focusNode.unfocus(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //? First, the divider.
                      Divider(color: WayaColors.greyColor200, height: 1),

                      //? Second, the chat messages.
                      if (state.messages.isEmpty && state.hasLoaded)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //* First, the image.
                              WayaAssets.images.cSayHello.image(
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),

                              // Some space.
                              const Gap(20),

                              //* Some text
                              Text(
                                "Send the first message",
                                style: WayaTextStyles.titleLarge.copyWith(
                                  color: config.isDarkMode ? Colors.white : null,
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
                                  chat.chatType == ChatType.group
                                      ? "Start the conversation in ${chat.name ?? "Group Chat"} with your friends!"
                                      : "Start the conversation with ${chat.other.userData?.fullname ?? chat.other.chatUser?.displayName ?? "WayaGram User"}",
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: WayaTextStyles.hintStyle.copyWith(
                                    color: grayTextColor,
                                  ),
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
                            onScroll: (controller) => focusNode.unfocus(),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            physics: const AlwaysScrollableScrollPhysics(),
                            reverse: true,
                            getPage: (page) async => notifier.getMessages(),
                            builder: (context, index) => ChatBubbleWidget(
                              index: index,
                              inputFocus: focusNode,
                              previousDate: index == 0 ? DateTime(1970) : state.messages[index - 1].createdAt,
                              data: state.messages[index],
                              chat: chat,
                              controller: inputController,
                              isLast: index == state.messages.length - 1,
                              isDark: config.isDarkMode,
                              grayColor: grayTextColor,
                              backgroundColor: backgroundColor,
                              textScale: config.textScale,
                            ),
                          ),
                        ),

                      //? Third, the chat input widget... probably?
                      ChatInputWidget(
                        controller: inputController,
                        notifier: notifier,
                        createChat: _startConversation,
                        focusNode: focusNode,
                        isDark: config.isDarkMode,
                        grayColor: grayTextColor,
                        backgroundColor: backgroundColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
