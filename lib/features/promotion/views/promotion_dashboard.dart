import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

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
            )
          ],
        ));
  }
}
