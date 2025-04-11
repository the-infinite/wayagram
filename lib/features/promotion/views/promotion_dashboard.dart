import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/promotion/vm/promotion_vm.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';

class PromotionDashboard extends ConsumerStatefulWidget {
  static const route = "/promotion-dashboard";
  const PromotionDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromotionDashboard();
}

class _PromotionDashboard extends ConsumerState<PromotionDashboard> {
  late final notifier = ref.read(promoteVmProvider.notifier);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notifier.getPromos();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(promoteVmProvider);
    final wayaTheme = Theme.of(context);
    // TODO: implement build
    return WayaScaffold(
        isLoading: state.loadingPromos,
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
            Row(
              spacing: 6,
              children: [
                Expanded(
                  child: InventoryWidget(
                    metrics: "N240,000",
                    color: wayaTheme.colorScheme.transparent,
                    title: "Promotion Cost",
                    border: Border.all(
                        width: 1, color: wayaTheme.colorScheme.greyColor300),
                  ),
                ),
                Expanded(
                  child: InventoryWidget(
                      metrics: "2,343",
                      color: wayaTheme.colorScheme.transparent,
                      title: "Impression",
                      border: Border.all(
                          width: 1, color: wayaTheme.colorScheme.greyColor300)),
                )
              ],
            ),
            Gap(6.h),
            SizedBox(
              width: double.infinity,
              child: InventoryWidget(
                  metrics: "500",
                  color: wayaTheme.colorScheme.transparent,
                  title: "New Followers",
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor300)),
            ),
            Gap(15.h),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.allPromotions.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final promo = state.allPromotions[index];
                  return _buildWidget(
                      contentType: promo.contentType, context: context);
                })
          ],
        ));
  }

  Widget _buildWidget(
      {required BuildContext context, required String contentType}) {
    return switch (contentType) {
      'event' => const SizedBox(),
      'moment' => const SizedBox(),
      'product' => const SizedBox(),
      'page' => const SizedBox(),
      'donation' => const SizedBox(),
      'poll & vote' => const SizedBox(),
      'post' => const SizedBox(),
      'group' => const SizedBox(),

      'contest' => const SizedBox(),

      // fallback widget
      _ => const SizedBox.shrink(), 
    };
  }
}
