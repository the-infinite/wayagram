import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/wallet/view/payout_history_screen.dart';
import 'package:wayagram/features/wallet/view/payout_method_screen.dart';

class PayoutDetails extends ConsumerStatefulWidget {
  static const route = '/payoutDetails';
  const PayoutDetails({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PayoutDetailsState();
}

class _PayoutDetailsState extends ConsumerState<PayoutDetails> {


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createGroupProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      removeAppBar: false,
      isLoading: viewModel.isLoading,
      backgroundColor: WayaColors.greyColor50,
      isScrollable: false,
      title: 'Payout Details',
      body: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Container(
           // margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: WayaColors.white,
                borderRadius: BorderRadius.circular(12)
            ),
            height: 85.h,
            width: double.infinity,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(10),
                Text('Payout Amount',
                    style: wayaTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontFamily: WayaConstants.fontFamily,
                        fontSize: 14.sp,
                        color: wayaTheme.colorScheme.greyColor500
                    )),
                Gap(10),
                Text('+₦15,600.00',
                    style: wayaTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFamily: WayaConstants.fontFamily,
                        fontSize: 24.sp,
                        color: WayaColors.pendingColor3
                    )),
              ],
            ),
          ),
          const Gap(10),
          _detailCard('Transaction Number','#123456789016276382937', wayaTheme.colorScheme.greyColor700),
          _detailCard('Transaction Category','Payout', wayaTheme.colorScheme.error),
          _detailCard('Transaction Type','Credit', wayaTheme.colorScheme.success),
          _detailCard('Date Requested ','Jan 30th, 2024 17:22:15', wayaTheme.colorScheme.greyColor700),
          _detailCard('Reference Number','#123456789016276', wayaTheme.colorScheme.greyColor700),
          _detailCard('Payout Status','Pending', WayaColors.pendingColor2),
          const Gap(10),
      Container(
        decoration: BoxDecoration(
            color: WayaColors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        height: 84.h,
        child: ListTile(
          leading: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
                color: WayaColors.error50,
                borderRadius: BorderRadius.circular(200)
            ),
            child: Center(
              child: Image.asset('assets/images/wallet/warn.png', height: 18,)
            ),
          ),

          title: Text('Report Transaction',
              style: wayaTheme.textTheme.mediumDescriptionStyle.wayaCopyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: wayaTheme.colorScheme.greyColor700)),
          subtitle: Text('If you have any issue with this transaction\nYou can reach out to our Support Center',
              style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: wayaTheme.colorScheme.greyColor600)),
          trailing:  SvgPicture.asset('assets/images/forward.svg'),
        ),
      ),
        ],
      ) ,
    );
  }
  _detailCard(txt, txt2, color){
    final wayaTheme = Theme.of(context);
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: WayaColors.white,
          borderRadius: BorderRadius.circular(12)
      ),
      height: 48.h,
      width: double.infinity,
      child:Row(
        children: [
          Text(txt,
              style: wayaTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 14.sp,
                  color: wayaTheme.colorScheme.greyColor700
              )),
          Spacer(),
          Text(txt2,
              style: wayaTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 12.sp,
                  color: color
              )),
        ],
      ),
    );
  }
}
