import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';

import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/shared/features/quotation/view/all_buy_request.dart';
import 'package:wayagram/shared/features/quotation/view/buy_request.dart';

class MyRequests extends ConsumerStatefulWidget {
  const MyRequests({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRequestsState();
}

class _MyRequestsState extends ConsumerState<MyRequests> {
  final quotationSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    quotationSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //? First, our widget for filtering the buy requests as a search.
        FilterWidget(search: quotationSearch, hintText: 'Search Requests'),

        // Some space.
        const Gap(25),

        //? Second, a widget to
        GroupedWidgetHeader(
          onTap: () {
            WayaNav.toNamed(BuyerBuyRequestsScreen.route);
          },
          subTitle: 'Explore Categories & Best Offers',
          title: 'Wayagram Deals',
        ),

        // Some space.
        const Gap(10),

        //? This is fine.
        CategoriesFilterWidget(
          setCategory: (value) => {},
        ),

        // Some more space.
        const Gap(25),

        //? This is fine too.
        SharedUserBuyRequestsWidget(
          isExpanded: false,
          controller: quotationSearch,
        ),

        // Some space.
        const Gap(25),

        //? Then we can look at te buyer requests that a here.
        GroupedWidgetHeader(
          onTap: () {
            WayaNav.toNamed(BuyerBuyRequestsScreen.route);
          },
          subTitle: 'Explore Categories & Best Offers',
          title: 'Recommended Products',
        ),

        // Some space.
        const Gap(25),

        //? Now, for the user's quotation requests.
        SharedUserBuyRequestsWidget(
          isExpanded: false,
          controller: quotationSearch,
        ),
      ],
    );
  }
}
