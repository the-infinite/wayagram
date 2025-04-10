import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_status.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_timer.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class SeeSellerBids extends ConsumerStatefulWidget {
  static const route = '/quotation/seller/bids';
  final String id;
  final String requestId;
  const SeeSellerBids({super.key, required this.id, required this.requestId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeSellerBidsState();
}

class _SeeSellerBidsState extends ConsumerState<SeeSellerBids> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final loadingController = ValueNotifier(false);

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final bid = notifier.getBid(widget.id)!;
    final request = notifier.getBidQuote(bid.requestId)!;

    //? This is fine.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: "Bid",
      body: WayaFutureSubscriber(
        future: UserResource.getUserDetails(request.buyerId),
        suspense: (context) => const SizedBox(),
        builder: (context, data) {
          //? If this is not fine.
          if (data == null) {
            return const SizedBox();
          }

          //? Since this is fine.
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? First, the row containing the profile picture and some request details.
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.w,
                children: [
                  //? The user's profile picture.
                  WayaDp(
                    radius: 20.r,
                    image: data.$1.profilePicture,
                    isSelf: false,
                  ),

                  //? Second, the user's name.
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5.h,
                      children: [
                        //* The name of the .
                        BidNegotiationStatusCard(
                          bid: bid,
                          user: BidActionAuthor.vendor,
                        ),

                        //* The name of the requested item.
                        Text(
                          request.fullname,
                          maxLines: 1,
                          style: wayaTheme.textTheme.bodyBold.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        //* The name of the user that is making the condition of the product
                        WayaRichText(
                          title1: data.$2.displayName ?? data.$1.fullname,
                          title2: request.condition == "new" ? "   Brand New" : "   Fairly Used",
                          style1: wayaTheme.textTheme.bodyBold.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                          ),
                          style2: wayaTheme.textTheme.bodyBold.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: wayaTheme.colorScheme.greyColor400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //? Third, the request timer.
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.primaryBrown50,
                      borderRadius: BorderRadius.circular(6000.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 2.w,
                      children: [
                        //? The icon for the stopwatch.
                        Icon(
                          Icons.timer_outlined,
                          color: wayaTheme.colorScheme.primary600,
                          size: 13.sp,
                        ),

                        //? The bid timer.
                        QuotationBidTimer(
                          request: request,
                          isShortTime: true,
                          isExpanded: true,
                          isStandalone: false,
                          fontSize: 13.sp,
                          textColor: wayaTheme.colorScheme.primary600,
                        )
                      ],
                    ),
                  ),
                ],
              ),

              

              // Some space.
              Gap(10.h),
            ],
          );
        },
      ),
    );
  }

  selectAmount(String amount, Color color, Color color2) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      height: 36.h,
      width: 80.w,
      child: Center(
        child: Text(
          amount,
          style: TextStyle().wayaCopyWith(
            color: color2,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
