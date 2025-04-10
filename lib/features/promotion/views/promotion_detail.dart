import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/promotion/widgets/analytics_widget.dart';
import 'package:wayagram/features/promotion/widgets/promoted_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';

class PromotionDetail extends ConsumerStatefulWidget {
  static const route = "/promotion-detail";
  const PromotionDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromotionDetail();
}

class _PromotionDetail extends ConsumerState<PromotionDetail> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    // TODO: implement build
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: "Promotion Detail",
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PromotedWidget(isDetail: true),
            const Gap(15),
          Row(
              
             spacing: 6,
              children: [
                Expanded(child: InventoryWidget(
                  metrics: "N240,000",
                  color: wayaTheme.colorScheme.transparent,
                  title: "Promotion Cost",
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor300),
                ),),
                Expanded(child: InventoryWidget(
                    metrics: "2,343",
                    color: wayaTheme.colorScheme.transparent,
                    title: "Impression",
                    border: Border.all(
                        width: 1, color: wayaTheme.colorScheme.greyColor300)),)
              ],
            ),
            const Gap(10),
            InventoryWidget(
                metrics: "500",
                color: wayaTheme.colorScheme.transparent,
                title: "New Followers",
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor300)),
            const Gap(15),
            Text("Analytics",
                style: wayaTheme.textTheme.bodySemiBold.wayaCopyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: wayaTheme.colorScheme.customBlack)),
            const Gap(20),
            AnalyticsWidget()
          ],
        ));
  }
}
