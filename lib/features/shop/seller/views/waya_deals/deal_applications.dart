import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/widgets/deal_application_widget.dart';

class DealApplications extends ConsumerWidget {
  const DealApplications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupedWidgetHeader(
              onTap: () {},
              subTitle:
                  "Review all the products you've submitted \n for WayaGram  Deals.",
              title: "Applications"),
          const Gap(10),
          ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return DealApplicationWidget();
              })
        ]);
  }
}
