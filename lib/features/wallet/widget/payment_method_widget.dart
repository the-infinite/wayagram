import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import '../../../core/theme/waya_colors.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String initial;
  final String accountNumber;
  final String accountName;
  final String bankName;
  final ThemeData wayaTheme;
  final VoidCallback? onTap;
  final VoidCallback? onClick;
  const PaymentMethodWidget({
    super.key,
    required this.initial,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
    required this.wayaTheme,
    required this.onTap,
    required this.onClick
  });



  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: WayaColors.white,
          borderRadius: BorderRadius.circular(12)
      ),
      height: 65.h,
      child: ListTile(
        onTap: onClick,
        leading: Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
              color: WayaColors.primary50,
              borderRadius: BorderRadius.circular(200)
          ),
          child: Center(
            child: Text(initial,
                style: wayaTheme.textTheme.mediumDescriptionStyle.wayaCopyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: wayaTheme.colorScheme.greyColor700)),
          ),
        ),

        title: Text(accountName,
            style: wayaTheme.textTheme.mediumDescriptionStyle.wayaCopyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: wayaTheme.colorScheme.greyColor700)),
        subtitle: Text('$bankName - $accountNumber',
            style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                color: wayaTheme.colorScheme.greyColor600)),
        trailing: InkWell(
            onTap: onTap,
            child: Image.asset('assets/images/wallet/del.png', height: 24.h,)),
      ),
    );
  }
}