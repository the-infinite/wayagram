import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/shop_dispute/widgets/single_dispute_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';

class SellerDispute extends ConsumerStatefulWidget {
  static const route = '/seller-dispute';
  const SellerDispute({super.key});

  @override
  ConsumerState<SellerDispute> createState() => _SellerDisputeState();
}

class _SellerDisputeState extends ConsumerState<SellerDispute> {
  final searchController = TextEditingController();
  final handler = WayaObservableScrollController();

  // This is fine.
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: 'All Disputes',
      body: WayaObservableScrollView(
        shouldFetch: false,
        isAtEnd: true,
        handler: handler,
        onReachEnd: () async {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Some space.
            Gap(20.h),

            //? How search through our list of disputes...
            FilterWidget(
              search: searchController,
              hintText: 'Search Dispute',
              onTextChanged: (value) {
                // TODO: Filter this.
              },
            ),

            // Some space.
            Gap(20.h),

            //? Where we show our disputes.
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return SingleDisputeWidget();
              },
            )
          ],
        ),
      ),
    );
  }
}
