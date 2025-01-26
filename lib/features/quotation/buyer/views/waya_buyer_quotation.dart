import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/features/quotation/buyer/views/my_request.dart';
import 'package:wayagram/features/shop/order/views/all_orders.dart';
import 'package:wayagram/features/shop/buyer/views/all_products.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

import '../../../../core/utils/waya_navigation.dart';
import 'buy_request.dart';
import 'manage_shop/manage_shop_quotation.dart';
class WayaBuyerQuotation extends ConsumerStatefulWidget {
  const WayaBuyerQuotation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaBuyerQuotationState();
}

class _WayaBuyerQuotationState extends ConsumerState<WayaBuyerQuotation>
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
                  text: 'Buy Requests',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'My Requests',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 2,
                  text: 'Manage Shop',
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
              ],
            ),
            const Gap(20),
            _selectedIndex == 0 || _selectedIndex == 1 ?
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
                WayaNav.toNamed('/create-request');
                //WayaNav.toNamed(CreateRequest.route);
              },
              color: wayaTheme.colorScheme.primar50,
            ) : Container(),
            _selectedIndex == 0 || _selectedIndex == 1 ?
            const Gap(25) : const Gap(10),
            _selectedIndex == 0 ? BuyRequests() : _selectedIndex == 1 ? MyRequests() : ManageShopQuotation()
            //AllOrders()
          ],
        ));
  }
}