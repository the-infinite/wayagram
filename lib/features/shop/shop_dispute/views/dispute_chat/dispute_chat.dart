import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/date.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/typing.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/shop_dispute/views/dispute_chat/widgets/dispute_buyer_info.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/shop_dispute/views/dispute_chat/widgets/dispute_profile_picture.dart';
import 'package:wayagram/features/shop/shop_dispute/vm/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

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

  final handler = WayaObservableScrollController();
  Order? orderDetail;
  bool isCustomReason = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = ModalRoute.of(context)!.settings.arguments as Order?;
      if (arg != null) {
        setState(() {
          orderDetail = arg;
        });
      }
    });
    super.initState();
  }

  Future<ChatModel?> _startConversation() async {
    return conversationNotifier.startChat(ChatType.dispute, []);
  }

  final List<String> suggestedReason = [
    "Item not Delivered",
    "Item is damaged or defective",
    "Item received is different from the description",
    "Other (Custom reason)"
  ];

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    void openTicket({required String reason}) async {
      if (orderDetail != null) {
        notifier.openTicket(
            reason: reason,
            sellerId: orderDetail!.vendorId,
            orderedItem: orderDetail?.items,
            reference: orderDetail!.id,
            deliveryToken: orderDetail!.deliveryToken!);
      }
    }

    //? This is fine.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      //  padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        leadingWidth: double.infinity,
        backgroundColor: wayaTheme.colorScheme.white,
        surfaceTintColor: wayaTheme.colorScheme.transparent,
        leading: Container(
          height: double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: wayaTheme.colorScheme.greyColor300, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* The back button, first.
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: WayaBackButton(),
              ),

              // Some space.
              const Gap(10),

              //* Second the profile picture and name.
              Expanded(
                child: InkWell(
                  splashColor: wayaTheme.colorScheme.primary.withAlpha(30),
                  focusColor: wayaTheme.colorScheme.primary.withAlpha(30),
                  highlightColor: wayaTheme.colorScheme.primary.withAlpha(30),
                  customBorder: StadiumBorder(),
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    // WayaNav.toNamed(WayaAppRoutes.getProfileRoute(chat.other.userId));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // First, the user's profile picture.
                      DisputeProfilePicture(
                        picture: "",
                        //  showActive: "userStatus" == ChatUserActivity.online,
                        // lastSeen: chat.other.chatUser?.lastSeen,
                        radius: 25,
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
                                orderDetail != null
                                    ? orderDetail!.shopName.capitalizeFirst!
                                    : "Seller",
                                maxLines: 1,
                                style: WayaTextStyles.titleMedium.copyWith(
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              //? For the message content...
                              if ("lastSeenText" != null)
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
              ),

              //*
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 12),
                child: IntrinsicHeight(
                  child: WayaButton(
                      callback: () {},
                      height: null,
                      color: WayaColors.primary50,
                      horizontalPadding: 8,
                      verticalPadding: 8,
                      centerWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(WayaAssets.icons.dclock.path),
                          const Gap(3),
                          Text(
                            "14 Days left",
                            style: wayaTheme.textTheme.hintStyle.copyWith(
                                color: wayaTheme.colorScheme.customPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // //? First, the buyer info.
          // DisputeBuyerInfo(),

          //? Second, the chat messages.
          if ((state.chat == null ||
              (state.messages.isEmpty && state.hasLoaded)))
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Select a reason for the dispute",
                    style: wayaTheme.textTheme.descriptionStyle.copyWith(
                        color: wayaTheme.colorScheme.customBlack,
                        fontWeight: FontWeight.w600),
                  ),
                  // Some space.
                  const Gap(20),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.end,
                    children: suggestedReason.map((suggestion) {
                      return IntrinsicWidth(
                        child: WayaButton(
                          callback: () async {
                            openTicket(reason: suggestion);
                            // final lastIndex = suggestedReason
                            //     .indexWhere((c) => c == suggestion);
                            // setState(() {
                            //   isCustomReason = true;
                            // });
                            // if (lastIndex == suggestion.length) {
                            //   // show input field
                            //   return;
                            // } else {
                            //   controller.setText(suggestion);
                            // }
                          },
                          horizontalPadding: 6,
                          textColor: wayaTheme.colorScheme.greyColor600,
                          textStyle: wayaTheme.textTheme.descriptionStyle
                              .copyWith(fontWeight: FontWeight.normal),
                          color: wayaTheme.colorScheme.transparent,
                          border: Border.all(
                              width: 1,
                              color: wayaTheme.colorScheme.greyColor300),
                          text: suggestion,
                        ),
                      );
                    }).toList(),
                  ),

                  // Some space.
                  const Gap(10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                physics: const AlwaysScrollableScrollPhysics(),
                reverse: true,
                getPage: (page) async {
                  return notifier.getMessages();
                },
                builder: (context, index) => ChatBubbleWidget(
                  index: index,
                  previousDate: index == 0
                      ? DateTime(1970)
                      : state.messages[index - 1].createdAt,
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
          if (state.chat != null ||
              (state.messages.isNotEmpty && state.hasLoaded))
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
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          ),
        ),

        // Time stamp
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '4:59 PM',
            style: TextStyle(
                color: wayaTheme.colorScheme.greyColor300, fontSize: 12),
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
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          ),
        ),
        const Gap(15)
      ],
    );
  }
}
