import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/utils/waya_navigation.dart';
import '../../vm/bid_vm.dart';
import '../../widgets/quotation_card.dart';
import '../../widgets/request_card.dart';

/*class BuyRequests extends ConsumerWidget {
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
}*/

class BuyRequests extends ConsumerStatefulWidget {
  const BuyRequests({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyRequestsState();
}

class _BuyRequestsState extends ConsumerState<BuyRequests> {

  int currentPage = 0;

  late Timer timer;

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createRequestProvider.notifier).getBuyerRequest();
    });
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeIn,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createRequestProvider);
    //final viewModel = ref.watch(bidVmProvider.notifier);
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
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
          ),
          height: 180.h,
          child: PageView(
            controller: pageController,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(15),child: Image.asset('assets/images/waya_deal_ad.png',fit: BoxFit.fitWidth,),),
              ClipRRect(borderRadius: BorderRadius.circular(15),child: Image.asset('assets/images/waya_deal_ad.png', fit: BoxFit.fitWidth),),
              ClipRRect(borderRadius: BorderRadius.circular(15),child: Image.asset('assets/images/waya_deal_ad.png', fit: BoxFit.fitWidth),),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 30.h),
          child: Center(
            child: SmoothPageIndicator(
                effect:  ExpandingDotsEffect(
                    dotWidth: 16,
                    dotHeight: 6,
                    spacing: 4,
                    dotColor: WayaColors.greyColor200,
                    activeDotColor: WayaColors.primary),
                controller: pageController,
                count: 3),
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            //itemCount: viewModel.quotations.length,
            itemCount: viewModel.buyerRequest.length,
            itemBuilder: (context, index) {

              return viewModel.buyerRequest.isEmpty ? Center(child: Text('No request')): RequestCard(product: viewModel.buyerRequest[index],
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
       /* ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.quotations.length,
            itemCount: viewModel.quotations.length,
            itemBuilder: (context, index) {
              return RequestCard(quotation: viewModel.quotations[index],
                  onTap: () {
                    WayaNav.toNamed('/seeSeller-bids');
                  });
            }),*/
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            //itemCount: viewModel.quotations.length,
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
