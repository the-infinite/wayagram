import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/quick_action_widget.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/widgets/single_order_widget.dart';

class ManageShop extends ConsumerWidget {
  static const route = '/manage-shop';
  const ManageShop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final viewModel = ref.watch(manageShopVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        automicallyImplyLeading: false,
        title: 'Maleek Ventures',
        isLoading: false,
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Maleek's Ventures", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'Manage your shop activity',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WayaButton(
                  callback: () {},
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.customPrimary),
                  centerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        color: wayaTheme.colorScheme.customPrimary,
                        size: 18,
                      ),
                      const Gap(5),
                      Text(
                        "Filter",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  height: 35,
                  color: wayaTheme.colorScheme.transparent,
                ),
                const Gap(10),
                WayaButton(
                  callback: () {},
                  text: 'Shop Settings',
                  textStyle: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  height: 35,
                )
              ],
            ),
            const Gap(15),
            GridView.builder(
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ref
                        .read(manageShopVmProvider.notifier)
                        .salesMetrics
                        .length,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return InventoryWidget(
                      metrics: ref
                          .read(manageShopVmProvider.notifier)
                          .salesMetrics[index]["metrics"],
                      color: ref
                          .read(manageShopVmProvider.notifier)
                          .salesMetrics[index]['color'],
                      title: ref
                          .read(manageShopVmProvider.notifier)
                          .salesMetrics[index]['title']);
                }),
            const Gap(15),
            Text("Quick Action",
                style: TextStyle().wayaCopyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: wayaTheme.colorScheme.customBlack)),
            const Gap(15),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ref
                        .read(manageShopVmProvider.notifier)
                        .salesMetrics
                        .length,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8),
                children: [
                  QuickActionWidget(
                    title: "Orders",
                    icon: SvgPicture.asset('assets/icons/van-icon.svg'),
                    color: Color(0xffE7F6EC),
                    onTap: () {
                      WayaNav.toNamed('/seller-orders');
                    },
                    metric: 4,
                    isStacked: true,
                  ),
                  QuickActionWidget(
                    title: "Wayagram Deals",
                    icon: SvgPicture.asset('assets/icons/deal-icon.svg'),
                    color: Color(0xffFFF0EB),
                    onTap: () {
                      WayaNav.toNamed('/waya-deal-ad');
                    },
                  ),
                  QuickActionWidget(
                    title: "Disputes",
                    icon: SvgPicture.asset(
                      'assets/icons/button-icon.svg',
                      width: 28,
                      height: 28,
                      colorFilter:
                          ColorFilter.mode(Color(0xffD42620), BlendMode.srcIn),
                    ),
                    color: Color(0xffFBEAE9),
                    onTap: () {
                      WayaNav.toNamed('/seller-dispute');
                    },
                  ),
                ],
              ),
            ),
            const Gap(15),
            Text("Recent Orders",
                style: TextStyle().wayaCopyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: wayaTheme.colorScheme.customBlack)),
            const Gap(15),
            ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SingleOrderWidget(
                    isSeller: true,
                  );
                })
          ],
        ));
  }
}
