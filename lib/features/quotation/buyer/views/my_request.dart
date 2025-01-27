import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';

import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

import '../../../../core/utils/waya_navigation.dart';
import '../../vm/bid_vm.dart';

import '../../widgets/request_card.dart';


class MyRequests extends ConsumerStatefulWidget {
  const MyRequests({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRequestsState();
}

class _MyRequestsState extends ConsumerState<MyRequests> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createRequestProvider.notifier).getBuyerRequest();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createRequestProvider);
    return Column(
      children: [
        FilterWidget(search: TextEditingController(), hintText: 'Search Requests'),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'Explore Categories & Best Offers',
            title: 'Wayagram Deals'),
        const Gap(10),
        CategoriesFilterWidget(setCategory: (value) => {}, ),
        const Gap(25),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.buyerRequest.length,
            itemBuilder: (context, index) {
              return RequestCard(product: viewModel.buyerRequest[index],
                onTap: () {
                  WayaNav.toNamed('/seeSeller-bids');
                },);
            }),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'Explore Categories & Best Offers',
            title: 'Recommended Products'),
        const Gap(25),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.buyerRequest.length,
            itemBuilder: (context, index) {
              return RequestCard(product: viewModel.buyerRequest[index],
                onTap: () {
                  WayaNav.toNamed('/seeSeller-bids');
                },);
            }),
      ],
    );
  }
}


