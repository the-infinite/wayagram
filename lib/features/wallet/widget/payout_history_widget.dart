import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/wallet/data/model/get_request_model.dart';

class PayoutHistoryWidget extends StatelessWidget {
  const PayoutHistoryWidget({
    super.key,
    required this.wayaTheme,
    required this.wallet,
    required this.ref,
    required this.dateTime,
  });

  final ThemeData wayaTheme;
  final RequestDocs wallet;
  final WidgetRef ref;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.greyColor100),
      ),
      child:
      ListTile(
        onTap: () {
          WayaNav.toNamed('/payoutDetails',
          arguments: {
            'id': wallet.id,
            'date': wallet.createdAt,
          }
          );
        },
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
            Text('Payout Request',
                style: wayaTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFamily: WayaConstants.fontFamily,
                    fontSize: 14.sp,
                    color: wayaTheme.colorScheme.greyColor700
                )),
            const Spacer(),
            Text(
              "-₦${wallet.amount}",
              style: wayaTheme.textTheme.bodyMedium!
                  .copyWith(color: wallet.status == 'PENDING' || wallet.status =='PROCESSING'?
              WayaColors.pendingColor4:wallet.status == 'COMPLETED' || wallet.status == 'APPROVED'?
              wayaTheme.colorScheme.success : wayaTheme.colorScheme.error,
                fontWeight: FontWeight.w400,
                fontFamily: WayaConstants.fontFamily,
                fontSize: 12.sp,),
            )
          ],
        ),
        subtitle: Row(
          children: [
           // wallet.status == 'FUNDING' || wallet.status == 'REFUND'?
            Container(
              decoration: BoxDecoration(
                color:  wallet.status == 'PENDING' || wallet.status =='PROCESSING'?
                wayaTheme.colorScheme.pending50:wallet.status == 'COMPLETED' || wallet.status == 'APPROVED'?
        wayaTheme.colorScheme.success50 : wayaTheme.colorScheme.error50,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              height: 17.h,
              width: 59.w,
              child: Text(wallet.status == 'PENDING' ? 'Pending' :
              wallet.status == 'PROCESSING'? 'Processing':
                 wallet.status == 'COMPLETED'?'Completed' : wallet.status == 'APPROVED'?'APPROVED':'Failed',
                style: wayaTheme.textTheme.labelSmall!
                    .copyWith(color:
                wallet.status == 'PENDING' || wallet.status =='PROCESSING'?
                WayaColors.pendingColor2:wallet.status == 'COMPLETED' || wallet.status == 'APPROVED'?
                  wayaTheme.colorScheme.success : wayaTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 12.sp,
                ),
              ),
            ),
            /*Container(
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.error50,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              height: 17.h,
              width: 48.w,
              child: Text('Pending',
                style: wayaTheme.textTheme.labelSmall!
                    .copyWith(color: wayaTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 12.sp,
                ),
              ),
            ),*/
            const Spacer(),
            Text(
              '${ref.read(createPollVotingProvider.notifier).formatDt2(wallet.updatedAt)},${DateFormat.jm().format(dateTime)}',
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