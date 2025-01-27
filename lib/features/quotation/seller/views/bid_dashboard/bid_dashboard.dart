import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/quotation/seller/views/bid_dashboard/widgets/inventory_widget.dart';
import 'package:wayagram/features/quotation/vm/bid_dashboard_vm.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/quick_action_widget.dart';

class BidDashboard extends ConsumerWidget {
  const BidDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final viewModel = ref.watch(bidDashboardVmProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Bid Dashboard", style: wayaTheme.textTheme.titleLarge),
        const Gap(3),
        Text(
          'Manage your bids and track settlements',
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(15),
        GridView.builder(
            itemCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ref.read(bidDashboardVmProvider.notifier).salesMetrics.length,
                mainAxisSpacing: 0,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8),
            itemBuilder: (context, index) {
              return InventoryWidget(
                  metrics: ref.read(bidDashboardVmProvider.notifier).salesMetrics[index]["metrics"],
                  color: ref.read(bidDashboardVmProvider.notifier).salesMetrics[index]['color'],
                  title: ref.read(bidDashboardVmProvider.notifier).salesMetrics[index]['title']);
            }),
        const Gap(15),
        Text(
          "Quick Action",
          style: TextStyle().wayaCopyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: wayaTheme.colorScheme.customBlack,
          ),
        ),
        const Gap(15),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.scaffoldColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuickActionWidget(
                  title: "Bids",
                  icon: SvgPicture.asset('assets/icons/bid.svg'),
                  color: Color(0xffE7F6EC),
                  onTap: () {
                    WayaNav.toNamed('/seller-bids');
                  },
                  metric: 4,
                  isStacked: true,
                ),
                const Gap(5),
                QuickActionWidget(
                  title: "Orders",
                  icon: SvgPicture.asset('assets/icons/orders.svg'),
                  color: Color(0xffFFF0EB),
                  onTap: () {
                    WayaNav.toNamed('/waya-deal-ad');
                  },
                ),
                const Gap(5),
                QuickActionWidget(
                  title: "Disputes",
                  icon: SvgPicture.asset(
                    'assets/icons/dispute.svg',
                    width: 28,
                    height: 28,
                  ),
                  color: Color(0xffE3EFFC),
                  onTap: () {
                    WayaNav.toNamed('/seller-dispute');
                  },
                ),
                const Gap(5),
                QuickActionWidget(
                  title: "Settlements",
                  icon: SvgPicture.asset(
                    'assets/icons/settlement.svg',
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(Color(0xffD42620), BlendMode.srcIn),
                  ),
                  color: Color(0xffFBEAE9),
                  onTap: () {
                    WayaNav.toNamed('/seller-settlement');
                  },
                ),
              ],
            ),
          ),
        ),
        const Gap(15),
        Text("Recent Bids",
            style: TextStyle()
                .wayaCopyWith(fontSize: 15, fontWeight: FontWeight.w600, color: wayaTheme.colorScheme.customBlack)),
        const Gap(15),
        ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container();
              // return SingleOrderWidget(
              //   isSeller: true,
              // );
            })
      ],
    );
  }
}
