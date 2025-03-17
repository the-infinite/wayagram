import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';

import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/shop_dispute/views/dispute_chat/dispute_chat.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/shop_dispute/views/dispute_chat/widgets/dispute_profile_picture.dart';
import 'package:wayagram/features/shop/shop_dispute/vm/default.dart';

class InitDispute extends ConsumerStatefulWidget {
  static const route = '/init/dispute/chat';
  const InitDispute({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DisputeChatState();
}

class _DisputeChatState extends ConsumerState<InitDispute> {
  late final notifier = ref.read(sellerDisputeChatProvider.notifier);
  late final  disputeNotifier = ref.read(disputeVmProvider.notifier);
  late final conversation = ref.read(conversationProvider.notifier);

  Order? orderDetail;
  bool isLoading = false;

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
        setState(() {
          isLoading = true;
        });
        final  result = await disputeNotifier.openTicket(
            reason: reason,
            sellerId: orderDetail!.vendorId,
            orderedItem: orderDetail!,
            reference: orderDetail!.id,
            );

        await conversation
            .getChatDetails(result!['chatId']!).then((chat) {
          setState(() {
            isLoading = false;
          });

          //? Stop if we could not make this chat.
          if (chat == null) return;

          //? If we could make this chat...
          notifier.setChat(chat);
          WayaNav.replaceNamed(WayaAppRoutes.getDisputeChatsRoute(result['disputeId']!));
        });
      }
    }

    //? This is fine.
    return WayaScaffold(
      isLoading: isLoading,
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
                        showActive: false,
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
        ],
      ),
    );
  }
}
