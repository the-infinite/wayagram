import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
    //final viewModel = ref.watch(sellerBidsVmProvider);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      padding: EdgeInsets.zero,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            'assets/images/bid/map.png',
            fit: BoxFit.contain,
          ),
          const Gap(10),
          ListView.builder(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            itemCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const SizedBox();
              //   return Padding(
              //     padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //       child: Theme(
              //         data: ThemeData(
              //           colorScheme: const ColorScheme.dark().copyWith(
              //             primary: Colors.transparent, // Custom color for the tile's header
              //           ),
              //         ),
              //         child: ExpansionTile(
              //           iconColor: Colors.white,
              //           collapsedIconColor: Colors.white,
              //           childrenPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              //           expandedCrossAxisAlignment: CrossAxisAlignment.start,
              //           title: SingleSeeBidWidget(
              //             isSeller: true,
              //             color: Colors.white,
              //           ),
              //           showTrailingIcon: false,
              //           children: [
              //             Column(
              //               children: [
              //                 Row(
              //                   children: [
              //                     selectAmount(
              //                         '₦20,500', wayaTheme.colorScheme.primar50, wayaTheme.colorScheme.customPrimary),
              //                     const Gap(10),
              //                     selectAmount(
              //                         '₦21,000', wayaTheme.colorScheme.primar50, wayaTheme.colorScheme.customPrimary),
              //                     const Gap(10),
              //                     selectAmount(
              //                         '₦21,500', wayaTheme.colorScheme.primar50, wayaTheme.colorScheme.customPrimary),
              //                   ],
              //                 ),
              //                 const Gap(10),
              //                 Row(
              //                   children: [
              //                     SizedBox(
              //                       width: context.width * 0.35,
              //                       child: WayaButton(
              //                         callback: () {},
              //                         text: 'Cancel Bid',
              //                         color: WayaColors.error500,
              //                       ),
              //                     ),
              //                     const Gap(15),
              //                     SizedBox(
              //                       width: context.width * 0.35,
              //                       child: WayaButton(
              //                         callback: () {},
              //                         text: 'Send Offer',
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   );
            },
          ),
        ],
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
