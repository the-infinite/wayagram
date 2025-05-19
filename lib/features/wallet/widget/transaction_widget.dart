import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';

class TransactionWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String purpose;
  final String transactionType;
  final String amount;
  final String date;
  const TransactionWidget({super.key,
   required this.onTap, required this.purpose,
    required this.transactionType, required this.amount,
    required this.date});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.greyColor100),
      ),
      child: ListTile(

        onTap: onTap,
        tileColor: wayaTheme.colorScheme.cardBackgroudColor,
        leading: Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.primary50,
            shape: BoxShape.circle,
          ),
          child: WayaAssets.icons.wallet.wallet.svg(fit: BoxFit.none),
        ),
        title: Row(
          children: [
            Text(purpose,
                style: wayaTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFamily: WayaConstants.fontFamily,
                    fontSize: 14.sp,
                    color: wayaTheme.colorScheme.greyColor700
                )),
            const Spacer(),
            transactionType == 'FUNDING' || transactionType == 'REFUND'?
            Text(
              "+₦${amount.toString()}",
              style: wayaTheme.textTheme.bodyMedium!
                  .copyWith(color: wayaTheme.colorScheme.success,
                fontWeight: FontWeight.w400,
                fontFamily: WayaConstants.fontFamily,
                fontSize: 12.sp,),
            ):
            Text(
              "-₦${amount.toString()}",
              style: wayaTheme.textTheme.bodyMedium!
                  .copyWith(color: WayaColors.error,
                fontWeight: FontWeight.w400,
                fontFamily: WayaConstants.fontFamily,
                fontSize: 12.sp,),
            )
          ],
        ),
        subtitle: Row(
          children: [
            transactionType == 'FUNDING' || transactionType == 'REFUND'?
            Container(
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.success50,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              height: 17.h,
              width: 48.w,
              child: Text('Credit',
                style: wayaTheme.textTheme.labelSmall!
                    .copyWith(color: wayaTheme.colorScheme.success,
                  fontWeight: FontWeight.w500,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 12.sp,
                ),
              ),
            ):
            Container(
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.error50,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              height: 17.h,
              width: 48.w,
              child: Text('Debit',
                style: wayaTheme.textTheme.labelSmall!
                    .copyWith(color: wayaTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 12.sp,
                ),
              ),
            ),
            const Spacer(),
            Text(date,
              style: TextStyle(color: wayaTheme.colorScheme.greyColor500,
                fontWeight: FontWeight.w400,
                fontFamily: WayaConstants.fontFamily,
                fontSize: 12.sp,),
            )
          ],
        ),
      ),
    );
  }
}
