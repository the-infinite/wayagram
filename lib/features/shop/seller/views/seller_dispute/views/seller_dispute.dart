import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/widgets/single_dispute_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';

class SellerDispute extends ConsumerWidget {
  static const route = '/seller-dispute';
  const SellerDispute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'All Disputes',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            FilterWidget(search: TextEditingController(), hintText: 'Search Dispute'),
            const Gap(20),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return SingleDisputeWidget();
                })
          ],
        ));
  }
}
