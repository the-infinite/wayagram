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
import 'package:wayagram/features/chat/widget/chat/bubbles/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/typing.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
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
  late final notifier = ref.watch(chatProvider.notifier);
  final focusNode = FocusNode();
  final handler = WayaObservableScrollController();
  bool _initialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
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
        notifier.getMessages(true);
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
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(chatProvider);

      //? If this is after the state of this has been reset.
      if (state.chat == null) return const SizedBox();

      //? Since there is something to be seen here.
      final chat = state.chat!;
      final inputController = ChatInputController.instance;
      final userStatus = chat.other.chatUser?.onlineStatus;
      final lastSeenText = chat.other.chatUser?.lastSeen != null
          ? "Last seen ${WayaDateHelper.getSocialTimestamp(chat.other.chatUser!.lastSeen).toLowerCase()}"
          : null;

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
          notifier.reset();
        },
        child: WayaScaffold(
          isLoading: false,
          isScrollable: false,
          padding: EdgeInsets.zero,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            toolbarHeight: kToolbarHeight,
            leadingWidth: double.infinity,
            backgroundColor: WayaColors.white,
            surfaceTintColor: Colors.transparent,
            leading: Container(
              height: double.infinity,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //* The back button, first.
                  WayaBackButton(),

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // First, the user's profile picture.
                          ChatProfilePicture(
                            user: chat.other.userData ?? ConversationState.self,
                            showActive: chat.chatType != ChatType.group && userStatus == ChatUserActivity.online,
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
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  //? For the message content...
                                  if (chat.chatType != ChatType.group && lastSeenText != null)
                                    Text(
                                      userStatus == ChatUserActivity.online ? "Online" : lastSeenText,
                                      maxLines: 1,
                                      style: WayaTextStyles.titleMedium.copyWith(
                                        fontWeight: FontWeight.normal,
                                        overflow: TextOverflow.ellipsis,
                                        color: WayaColors.greyColor500,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                        color: WayaColors.greyColor200,
                        horizontalPadding: 8,
                        verticalPadding: 8,
                        centerWidget: WayaAssets.icons.cCallVideo.svg(
                          color: WayaColors.black,
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
                        color: WayaColors.greyColor200,
                        horizontalPadding: 8,
                        verticalPadding: 8,
                        centerWidget: WayaAssets.icons.cCallVoice.svg(
                          color: WayaColors.black,
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
                            "Start a conversation with ${chat.other.chatUser?.displayName} by sending the first message",
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
                        return notifier.getMessages();
                      },
                      builder: (context, index) => ChatBubbleWidget(
                        index: index,
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
                ChatInputWidget(
                  controller: inputController,
                  notifier: notifier,
                  createChat: _startConversation,
                  focusNode: focusNode,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
