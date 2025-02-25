import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/typing.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/dispute_chat/widgets/dispute_buyer_info.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/vm/default.dart';

class DisputeChat extends ConsumerStatefulWidget {
  static const route = '/seller/dispute/chat';
  const DisputeChat({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DisputeChatState();
}

class _DisputeChatState extends ConsumerState<DisputeChat> {
  final controller = ChatInputController.instance;
  late final notifier = ref.read(sellerDisputeChatProvider.notifier);
  late final conversationNotifier = ref.read(conversationProvider.notifier);
  late final state = ref.watch(sellerDisputeChatProvider);

  Future<ChatModel?> _startConversation() async {
    return conversationNotifier.startChat(ChatType.dispute, []);
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? This is fine.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: 'Dispute Chat',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //? First, the buyer info.
          DisputeBuyerInfo(),

          //? Second, the chat messages.
          if (state.chat == null || (state.messages.isEmpty && state.hasLoaded))
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //* First, the image.
                  WayaAssets.icons.dispute.svg(
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    color: wayaTheme.colorScheme.error,
                  ),

                  // Some space.
                  const Gap(20),

                  //* Some text
                  Text(
                    "Do you have any concerns?",
                    style: wayaTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),

                  // Some space.
                  const Gap(10),

                  //* Some text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Start a conversation with a Fasas today",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: wayaTheme.textTheme.hintStyle,
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: WayaPaginatedListView<MessageModel>(
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
                  controller: controller,
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

          //? This is fine.
          ChatInputWidget(
            controller: controller,
            notifier: notifier,
            voiceEnabled: false,
            padded: false,
            createChat: _startConversation,
          ),
        ],
      ),
    );
  }
}

class SellerChat extends StatelessWidget {
  const SellerChat({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Admin message
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.customPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Hello! I am messaging as regards your dispute, your evidence is not enough, send more details.',
              style: TextStyle()
                  .wayaCopyWith(color: wayaTheme.colorScheme.white, fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ),

        // Time stamp
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '4:59 PM',
            style: TextStyle(color: wayaTheme.colorScheme.greyColor300, fontSize: 12),
          ),
        ),
        const Gap(15)
      ],
    );
  }
}

class BuyerChat extends StatelessWidget {
  const BuyerChat({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User message
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.scaffoldColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'The product was broken, i will send more image now.',
              style: TextStyle()
                  .wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ),
        const Gap(15)
      ],
    );
  }
}
