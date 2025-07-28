// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/buyer_dispute/modals/report.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/default.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/shop_dispute/data/model/dispute_response_model.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/shop_dispute/vm/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class DisputeChat extends ConsumerStatefulWidget {
  static const route = '/seller/dispute/chat';
  final String id;
  const DisputeChat({super.key, required this.id});

  @override
  ConsumerState<DisputeChat> createState() => _DisputeChatState();
}

class _DisputeChatState extends ConsumerState<DisputeChat> {
  late final notifier = ref.read(sellerDisputeChatProvider.notifier);
  final focusNode = FocusNode();
  final handler = WayaObservableScrollController();
  bool _initialized = false;
  bool isButtonDisabled = false;
  int noOfDaysLeft = 14;

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (notifier.mounted) {
          notifier.getMessages(true);
        }
        ref.read(disputeVmProvider.notifier).getSDispute(id: widget.id);
      },
    );

    //? This is fine.
    super.initState();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (notifier.mounted) {
          notifier.getMessages(true);
        }
      },
    );

    //? This is fine.
    super.reassemble();
  }

  Future<ChatModel?> _startConversation() async {
    return null;
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    // Get the theme.
    final theme = Theme.of(context);
    final disputeState = ref.watch(disputeVmProvider);

    // This is fine.
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(sellerDisputeChatProvider);

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

      if (disputeState.dispute != null) {
        final order = Order.fromJson(
            disputeState.dispute!.ticketBody.metadata.orderedItem);

        String completedAt = order.deliveryStatusHistory.isNotEmpty
            ? order.deliveryStatusHistory.last.updatedAt
            : order.pickupStatusHistory.last.updatedAt;
        int daysLeft =
            14 - DateTime.now().difference(DateTime.parse(completedAt)).inDays;

        isButtonDisabled = daysLeft <= 0;
        noOfDaysLeft = daysLeft;
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
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // First, the user's profile picture.
                          ChatProfilePicture(
                            user: chat.other.userData ?? ConversationState.self,
                            showActive: userStatus == ChatUserActivity.online,
                            lastSeen: chat.other.chatUser?.lastSeen,
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
                                  if (lastSeenText != null)
                                    Text(
                                      userStatus == ChatUserActivity.online
                                          ? "Online"
                                          : lastSeenText,
                                      maxLines: 1,
                                      style:
                                          WayaTextStyles.titleMedium.copyWith(
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

                  //* Fourth, the audio call button.
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 6),
                    child: IntrinsicHeight(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        WayaButton(
                          callback:
                              (disputeState.dispute?.escalatedBy != null ||
                                      isButtonDisabled)
                                  ? null
                                  : () {
                                      final order = Order.fromJson(disputeState
                                          .dispute!
                                          .ticketBody
                                          .metadata
                                          .orderedItem);
                                      final id = disputeState.dispute?.id;
                                      final bool isBuyer =
                                          disputeState.dispute?.sellerId !=
                                              ConversationState.self.id;
                                      escalateToMediator(
                                          context: context,
                                          order: order,
                                          tobeEscalatedBy:
                                              isBuyer ? "buyer" : "seller",
                                          disputeId: id!);
                                    },
                          height: null,
                          textStyle: theme.textTheme.descriptionStyle.copyWith(
                              fontSize: 13.sp, fontWeight: FontWeight.w500),
                          text: "Escalate to mediator",
                          horizontalPadding: 8,
                          verticalPadding: 5,
                        ),
                        const Gap(1),
                        Row(
                          children: [
                            SvgPicture.asset(
                              WayaAssets.icons.dclock.path,
                              width: 14,
                              height: 14,
                            ),
                            const Gap(1),
                            Text(
                              "$noOfDaysLeft days left",
                              style: theme.textTheme.hintStyle.copyWith(
                                  color: theme.colorScheme.customPrimary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        // const Gap(2),
                      ],
                    )),
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
                        WayaAssets.icons.dispute.svg(
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                theme.colorScheme.customPrimary,
                                BlendMode.srcIn)),

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      physics: const AlwaysScrollableScrollPhysics(),
                      reverse: true,
                      getPage: (page) async {
                        return notifier.getMessages();
                      },
                      builder: (context, index) => ChatBubbleWidget(
                        index: index,
                        inputFocus: focusNode,
                        previousDate: index == 0
                            ? DateTime(1970)
                            : state.messages[index - 1].createdAt,
                        data: state.messages[index],
                        chat: state.chat,
                        controller: inputController,
                        isLast: index == state.messages.length - 1,
                      ),
                    ),
                  ),

                if (disputeState.dispute != null &&
                    disputeState.dispute!.escalatedBy != null) ...[
                  Gap(30.h),
                  //> dispute state
                  buildDisputeStateIndicator(
                      context: context, dispute: disputeState.dispute!),
                  //> Gap
                  Gap(30.h),

                  if (disputeState.dispute!.status != "open")
                    //> text
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text("Chat Ended",
                              style: theme.textTheme.bodySemiBold
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const Gap(2),
                          Text(
                              "Dispute ${disputeState.dispute!.status.capitalizeFirst}",
                              style: theme.textTheme.bodySemiBold.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      disputeState.dispute!.status != "resolved"
                                          ? theme.colorScheme.error700
                                          : theme.colorScheme.customPrimary))
                        ],
                      ),
                    )
                ],

                //? Third, the chat input widget.
                if (disputeState.dispute != null &&
                    disputeState.dispute!.escalatedBy == null)
                  ChatInputWidget(
                    controller: inputController,
                    notifier: notifier,
                    createChat: _startConversation,
                    voiceEnabled: false,
                    focusNode: focusNode,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildDisputeStateIndicator(
      {required BuildContext context, required DisputeModel dispute}) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Dispute Resolution Progress",
                style: theme.textTheme.bodySemiBold
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                decoration: BoxDecoration(
                    color: dispute.status == 'open'
                        ? theme.colorScheme.primary75.withOpacity(0.3)
                        : dispute.status == 'resolved'
                            ? theme.colorScheme.success50
                            : theme.colorScheme.error700.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  dispute.status.capitalizeFirst,
                  style: TextStyle().wayaCopyWith(
                      color: dispute.status == 'open'
                          ? theme.colorScheme.primary600
                          : dispute.status == 'resolved'
                              ? theme.colorScheme.success
                              : theme.colorScheme.error700,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp),
                ),
              )
            ],
          ),
          const Gap(8),
          dispute.status == "open"
              ? Image.asset(
                  WayaAssets.images.dopen.path,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : dispute.status == "resolved"
                  ? Image.asset(WayaAssets.images.dresolved.path,
                      width: double.infinity, fit: BoxFit.cover)
                  : Image.asset(WayaAssets.images.ddismissed.path,
                      width: double.infinity, fit: BoxFit.cover),
          const Gap(8),
          Text(
            "Date Submitted ${WayaHelpers.formatDateString(dispute.updatedAt.toIso8601String())}",
            style: theme.textTheme.bodySemiBold
                .copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  void escalateToMediator(
      {required BuildContext context,
      required Order order,
      required String tobeEscalatedBy,
      required String disputeId}) async {
    await WayaUtils.showNotice(
        context: context,
        title: "Escalate to Mediator",
        buttonText: "Yes, Escalate to Mediator",
        secondButtonText: "Cancel",
        onCancel: () => WayaNav.goBack(),
        onPress: () async {
          WayaNav.goBack();

          await WayaUtils.showModalSheet(context,
              child: ReportDisputeModal(
                  order: order,
                  disputeId: disputeId,
                  tobeEscalatedBy: tobeEscalatedBy));
        },
        message:
            "Please confirm whether you’d like to escalate this dispute to a mediator. This cannot be undone when confirmed",
        icon: Image.asset(WayaAssets.images.dmediator.path));
  }
}
