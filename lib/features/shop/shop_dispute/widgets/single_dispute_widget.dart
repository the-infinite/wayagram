import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/shop_dispute/views/seller_dispute_detail.dart';

class SingleDisputeWidget extends StatelessWidget {
  const SingleDisputeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        WayaNav.toNamed(SellerDisputeDetail.route);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/s-dispute-icon.svg'),
                    const Gap(4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dispute #43435353",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14),
                        ),
                        const Gap(8),
                        Text(
                          "Aug 11, 2024",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.greyColor400,
                              fontSize: 13,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.success50,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    "completed",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.success,
                        fontWeight: FontWeight.w500,
                        fontSize: 11),
                  ),
                )
              ],
            ),
          ),
          const Gap(10)
        ],
      ),
    );
  }
}
