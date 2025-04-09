import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_status.dart';

class QuotationOrderWidget extends ConsumerWidget {
  final bool isSeller;
  final BidOrderModel order;

  // Construct.
  const QuotationOrderWidget({
    super.key,
    required this.order,
    this.isSeller = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    //? This is our component.
    return GestureDetector(
      onTap: () {
        if (isSeller) {
          WayaNav.toNamed(WayaAppRoutes.getBidDetailsScreen(order.id, order.requestId));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
        decoration: BoxDecoration(
          color: wayaTheme.colorScheme.scaffoldColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5.w,
          children: [
            //? Fix this BS.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //? This is fine.
                  WayaAssets.icons.orderVan.svg(),

                  // Some space.
                  const Gap(4),

                  //? This should fill all space too.
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? The ID of this buy request.
                        Text(
                          "#${order.requestId}",
                          maxLines: 1,
                          style: wayaTheme.textTheme.bodyMedium?.copyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 14.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //? This is fine too.
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //? The status of the bid.
                OrderStatusCard(
                  order: order,
                ),

                // Some space.
                const Gap(8),

                //? When this was made.
                Text(
                  WayaDateHelper.getEffectiveTimestamp(order.createdAt),
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    color: wayaTheme.colorScheme.greyColor400,
                    fontSize: 13.sp,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
