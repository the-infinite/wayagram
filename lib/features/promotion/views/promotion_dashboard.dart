import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/promotion/widgets/promoted_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';

class PromotionDashboard extends ConsumerStatefulWidget {
  static const route = "/promotion-dashboard";
  const PromotionDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromotionDashboard();
}

class _PromotionDashboard extends ConsumerState<PromotionDashboard> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    // TODO: implement build
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: "Promotions",
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Promotion Dashboard",
                      style: wayaTheme.textTheme.titleLarge?.copyWith(),
                    ),
                    const Gap(3),
                    Text(
                      "Here is a full analytics of your promotions",
                      style: wayaTheme.textTheme.descriptionStyle.copyWith(
                          color: wayaTheme.colorScheme.greyColor400,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp),
                    )
                  ],
                ),
              ],
            ),
            const Gap(15),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 8),
              children: [
                InventoryWidget(
                  metrics: "N240,000",
                  color: wayaTheme.colorScheme.transparent,
                  title: "Promotion Cost",
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor300),
                ),
                InventoryWidget(
                    metrics: "2,343",
                    color: wayaTheme.colorScheme.transparent,
                    title: "Impression",
                    border: Border.all(
                        width: 1, color: wayaTheme.colorScheme.greyColor300)),
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

            PromotedWidget()


          ],
        ));
  }
}
