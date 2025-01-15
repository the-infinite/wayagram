import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

import '../../../../core/utils/waya_navigation.dart';
import '../../vm/bid_vm.dart';
import '../../widgets/quotation_card.dart';
import '../../widgets/request_card.dart';

class BuyRequests extends ConsumerWidget {
  const BuyRequests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bidVmProvider.notifier);
    final productState = ref.watch(productsProvider);
    return Column(
      children: [
        FilterWidget<Product>(allItems: [], hintText: 'Search Requests'),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'Explore Categories & Best Offers',
            title: 'Wayagram Deals'),
        const Gap(10),
        CategoriesFilterWidget<Product>(allItems: []),
        const Gap(25),
        ClipRRect(borderRadius: BorderRadius.circular(15),child: Image.asset('assets/images/waya_deal_ad.png'),),
        const Gap(25),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.quotations.length,
            itemBuilder: (context, index) {
              return RequestCard(quotation: viewModel.quotations[index],
              onTap: () {
                WayaNav.toNamed('/seeSeller-bids');
              },);
            }),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'Explore Categories & Best Offers',
            title: 'Recommended Bids'),
        const Gap(25),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.quotations.length,
            itemBuilder: (context, index) {
              return RequestCard(quotation: viewModel.quotations[index],
                      onTap: () {
                    WayaNav.toNamed('/seeSeller-bids');
                  });
            }),
      ],
    );
  }
}