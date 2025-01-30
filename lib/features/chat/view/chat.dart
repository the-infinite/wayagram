import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/chat/widget/profile_picture.dart';

class SingleChatScreen extends ConsumerStatefulWidget {
  static const route = "/conversation/chat";
  final String chatId;

  // This is fine.
  const SingleChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends ConsumerState<SingleChatScreen> {
  final inputController = ChatInputController();
  late final chat = ref.watch(conversationProvider).conversations.firstWhere((chat) => chat.id == widget.chatId);
  late final state = ref.watch(chatProvider);
  late final notifier = ref.watch(chatProvider.notifier);

  // We start a video call.
  void _startAudioCall() async {}

  // We start a video call.
  void _startVideoCall() async {}

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      isLoading: state.isLoading,
      isScrollable: false,
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        leadingWidth: double.infinity,
        backgroundColor: WayaColors.white,
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

              //* First, the user's profile picture.
              ChatProfilePicture(
                user: chat.other,
                radius: 20,
              ),

              //* Second, the user's name.
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* For the other person's name.
                      Text(
                        "${chat.other.firstName} ${chat.other.lastName}",
                        maxLines: 1,
                        style: WayaTextStyles.titleMedium.copyWith(
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      //? For the message content...
                      Text(
                        "Online",
                        maxLines: 1,
                        style: WayaTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.normal,
                          overflow: TextOverflow.ellipsis,
                          color: WayaColors.greyColor500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
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

          //? For the audio call button.
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //? First, the divider.
          Divider(color: WayaColors.greyColor200, height: 1),

          //? Second, the chat messages.
          Expanded(
            child: RefreshIndicator(
              onRefresh: notifier.getMessages,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // For our messages.
                  ],
                ),
              ),
            ),
          ),

          // An ever so tiny amount of space.
          const Gap(12),

          //? Third, the chat input widget.
          ChatInputWidget(
            controller: inputController,
          )
        ],
      ),
    );
  }
}
