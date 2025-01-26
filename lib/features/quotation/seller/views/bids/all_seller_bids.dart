import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/seller/views/bid_dashboard/widgets/inventory_widget.dart';
import 'package:wayagram/features/quotation/vm/seller_bids_vm.dart';
import 'package:wayagram/features/quotation/widgets/single_bid_widget.dart';
import 'package:wayagram/features/shop/data/model/model.dart';

import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class AllSellerBids extends ConsumerWidget {
  static const route = '/seller-bids';
  const AllSellerBids({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(sellerBidsVmProvider);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Bids',
        appBarTrailing: bidIcon(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bids", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'View and Manage your bids',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(20),
            FilterWidget(search: TextEditingController(), hintText: 'Search Bids',),
            const Gap(15),
            GridView.builder(
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: viewModel.orderMetrics.length,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.22,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return InventoryWidget(
                      metrics: viewModel.orderMetrics[index]["metrics"],
                      color: viewModel.orderMetrics[index]['color'],
                      title: viewModel.orderMetrics[index]['title']);
                }),
            const Gap(10),
            Text("Recent Bids",
                style: TextStyle().wayaCopyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: wayaTheme.colorScheme.customBlack)),
            const Gap(10),
            ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SingleBidWidget(
                    isSeller: true,
                  );
                })
          ],
        ));
  }

  Widget bidIcon(ctx){
    final wayaTheme = Theme.of(ctx);
    return GestureDetector(
      onTap: () {
         WayaNav.toNamed("/map");
      },
      child: Row(
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.customPrimary,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/bid.svg', color: wayaTheme.colorScheme.white, height: 20,),
                  const Gap(5),
                  Text(
                    "See Bids",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  )
                ],
              ),
            ),
          ),
          const Gap(15)
        ],
      ),
    );
  }
}
