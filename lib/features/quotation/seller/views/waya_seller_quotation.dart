import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/quotation/buyer/views/my_request.dart';
import 'package:wayagram/features/shop/buyer/views/all_orders.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class WayaSellerQuotation extends ConsumerStatefulWidget {
  const WayaSellerQuotation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaSellerQuotationState();
}

class _WayaSellerQuotationState extends ConsumerState<WayaSellerQuotation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);

    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Get Quotation',
        appBarTrailing: WayaCartIcon(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
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
                  text: 'Bid Dash',
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
              ],
            ),
            const Gap(20),
            WayaButton(
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/create.svg',
                    colorFilter: ColorFilter.mode(
                        wayaTheme.colorScheme.primary200, BlendMode.srcIn),
                  ),

                  const Gap(8),
                  Text(
                    "Create Buying Request",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              callback: () {
                //WayaNav.toNamed('/create-request', arguments: "id");
              },
              color: wayaTheme.colorScheme.primar50,
            ),

            const Gap(25),
            // AllProducts()
            //_selectedIndex == 0 ? BuyRequests() : _selectedIndex == 1 ? MyRequests() : AllOrders()
          ],
        ));
  }
}