import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class SeeSellerBids extends ConsumerStatefulWidget {
  static const route = '/quotation/seller/bids';
  final String id;
  const SeeSellerBids({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeSellerBidsState();
}

class _SeeSellerBidsState extends ConsumerState<SeeSellerBids> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      padding: EdgeInsets.zero,
      body: ListView.builder(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const SizedBox();
        },
      ),
    );
  }

  selectAmount(amt, color, color2) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      height: 36.h,
      width: 80.w,
      child: Center(
        child: Text(
          amt,
          style: TextStyle().wayaCopyWith(color: color2, fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
      ),
    );
  }
}
