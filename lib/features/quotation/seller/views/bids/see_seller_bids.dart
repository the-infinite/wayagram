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
import 'package:wayagram/features/quotation/widgets/single_see_bid_widget.dart';
import 'package:wayagram/features/quotation/widgets/single_settlement_widget.dart';
import 'package:wayagram/features/shop/data/model/model.dart';

import 'package:wayagram/features/shop/seller/vm/seller_orders_vm.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/single_order_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class SeeSellerBids extends ConsumerWidget {
  static const route = '/seeSeller-bids';
  const SeeSellerBids({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    //final viewModel = ref.watch(sellerBidsVmProvider);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.zero,
        body: Stack(
          children: [
          Image.asset('assets/images/bid/map.png', fit: BoxFit.contain,),
          const Gap(10),
          ListView.builder(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return SingleSeeBidWidget(
                  isSeller: true,
                );
              })

        ],));
  }
}
