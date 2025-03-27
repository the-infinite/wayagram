import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/buyer/views/buy_request.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/create_request.dart';
import 'package:wayagram/features/quotation/buyer/views/my_request.dart';
import 'package:wayagram/features/quotation/seller/views/bid_dashboard/bid_dashboard.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class WayaSellerQuotation extends ConsumerStatefulWidget {
  const WayaSellerQuotation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaSellerQuotationState();
}

class _WayaSellerQuotationState extends ConsumerState<WayaSellerQuotation> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? This one.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: 'Get Quotation',
      appBarTrailing: WayaCartIcon(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Opening space.
          const Gap(10),

          //? These ones.
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'All Quotations',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 1,
                text: 'My Quotations',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 2,
                text: 'Bid Dashboard',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),

          // Some space.
          const Gap(20),

          //? The button to create a new buying request.
          WayaButton(
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //? Icon.
                WayaAssets.icons.create.svg(
                  colorFilter: ColorFilter.mode(wayaTheme.colorScheme.primary200, BlendMode.srcIn),
                ),

                // Space.
                const Gap(8),

                //? Text.
                Text(
                  "Create Buying Request",
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    color: wayaTheme.colorScheme.customPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            callback: () {
              //? Show the coming soon modal.
              if (WayaConstants.isProduction) {
                WayaNavigationHelper.showComingSoonModal(true);
                return;
              }

              //? Now, continue as needed in staging.
              WayaNav.toNamed(CreateRequest.route);
            },
            color: wayaTheme.colorScheme.primary50,
          ),
          const Gap(25),
          _selectedIndex == 0
              ? BuyRequests()
              : _selectedIndex == 1
                  ? MyRequests()
                  : BidDashboard()
        ],
      ),
    );
  }
}
