import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/quotation/seller/views/bid_dashboard/widgets/inventory_widget.dart';
import 'package:wayagram/features/quotation/vm/seller_bids_vm.dart';
import 'package:wayagram/features/quotation/widgets/single_bid_widget.dart';
import 'package:wayagram/features/quotation/widgets/single_settlement_widget.dart';

import 'package:wayagram/features/shop/seller/vm/seller_orders_vm.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/order/widgets/single_order_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class SellerSettlement extends ConsumerWidget {
  static const route = '/seller-settlement';
  const SellerSettlement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    //final viewModel = ref.watch(sellerBidsVmProvider);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Settlements',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Settlements", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'View and manage your settlements',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(20),
            FilterWidget( search: TextEditingController(), hintText: 'Search Settlements',),

            const Gap(10),
            ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SingleSettlementWidget(
                    isSeller: true,
                  );
                })
          ],
        ));
  }
}
