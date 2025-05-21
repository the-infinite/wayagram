import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/shop/shop_dispute/data/model/dispute_response_model.dart';
import 'package:wayagram/features/shop/shop_dispute/vm/default.dart';

class SingleDisputeWidget extends ConsumerWidget {
  final DisputeModel dispute;
  const SingleDisputeWidget({super.key, required this.dispute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final conversationNotifier = ref.read(conversationProvider.notifier);
    final notifier = ref.read(sellerDisputeChatProvider.notifier);

    void toDispute() async {
      conversationNotifier.dismissOverlay();
      notifier.setChat(
          (await conversationNotifier.getChatDetails(dispute.chatId??""))!);
      notifier.markAllAsRead().then((result) {
        if (!result) return;
        conversationNotifier.getChats(true);
      });
      WayaNav.toNamed(WayaAppRoutes.getDisputeChatsRoute(dispute.id));
    }

    return GestureDetector(
      onTap: toDispute,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(WayaAssets.icons.sDisputeIcon.path),
                    const Gap(4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dispute #${dispute.id.substring(0, 6)}",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14.sp),
                        ),
                        const Gap(8),
                        Text(
                          WayaHelpers.formatDateString(
                              dispute.updatedAt.toIso8601String()),
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.greyColor400,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                  decoration: BoxDecoration(
                      color: dispute.status == 'open'
                          ? wayaTheme.colorScheme.primary75.withOpacity(0.3)
                          : wayaTheme.colorScheme.success50,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    dispute.status.capitalizeFirst!,
                    style: TextStyle().wayaCopyWith(
                        color: dispute.status == 'open'
                            ? wayaTheme.colorScheme.primary600
                            : wayaTheme.colorScheme.success,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp),
                  ),
                )
              ],
            ),
          ),
          const Gap(10)
        ],
      ),
    );
  }
}
