import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wayagram/shared/features/quotation/view/all_buy_request.dart';
import 'package:wayagram/shared/features/quotation/view/buy_request.dart';

class BuyRequests extends ConsumerStatefulWidget {
  const BuyRequests({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyRequestsState();
}

class _BuyRequestsState extends ConsumerState<BuyRequests> {
  int currentPage = 0;
  late Timer timer;
  final quotationSearch = TextEditingController();

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeIn,
        );
      }
    });
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
        //? How we filter inside of our purchase requests.
        FilterWidget(search: quotationSearch, hintText: 'Search Requests'),

        // Some space.
        const Gap(25),

        //? The wayagram deals
        GroupedWidgetHeader(
          onTap: () {
            WayaNav.toNamed(SellerBuyRequestsScreen.route);
          },
          subTitle: 'Explore Categories & Best Offers',
          title: 'Wayagram Deals',
        ),

        // Some space.
        const Gap(25),

        //? This is for the ads.
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          height: 180.h,
          child: PageView(
            controller: pageController,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: WayaAssets.images.wayaDealAd.image(
                  fit: BoxFit.fitWidth,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: WayaAssets.images.wayaDealAd.image(
                  fit: BoxFit.fitWidth,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: WayaAssets.images.wayaDealAd.image(
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),

        //? This one is there too.
        Padding(
          padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 30.h),
          child: Center(
            child: SmoothPageIndicator(
              effect: ExpandingDotsEffect(
                dotWidth: 16,
                dotHeight: 6,
                spacing: 4,
                dotColor: WayaColors.greyColor200,
                activeDotColor: WayaColors.primary,
              ),
              controller: pageController,
              count: 3,
            ),
          ),
        ),

        //? The buyer requests that we have.
        SharedOthersBuyRequestsWidget(
          isExpanded: false,
          controller: quotationSearch,
        ),

        // Some space.
        const Gap(25),

        //? Explore the recommended bids.
        GroupedWidgetHeader(
          onTap: () => WayaNav.toNamed(SellerBuyRequestsScreen.route),
          subTitle: 'Explore Categories & Best Offers',
          title: 'Recommended Bids',
        ),

        // Some space.
        const Gap(25),

        //? Explore the available buyer requests.
        SharedOthersBuyRequestsWidget(
          isExpanded: false,
          controller: quotationSearch,
        ),
      ],
    );
  }
}
