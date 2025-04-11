
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

import '../../../assetsgen/assets.gen.dart';

class PayoutEmptyState extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String image;
  final String subTitle;
  final bool hasButton;
  const PayoutEmptyState({super.key,
    required this.onTap,
    required this.title,
    required this.image,
    required this.subTitle,
    required this.hasButton
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(40),
        Image.asset('assets/images/wallet/$image.png',height: 201.h,),
        const Gap(20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.titleLarge,
        ),
        const Gap(10),
        Text(
          subTitle,
          style: wayaTheme.textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: WayaColors.greyColor600,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(25),
        if (hasButton)
          WayaButton(
            callback: onTap,
            color: wayaTheme.colorScheme.primary50,
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(6),
                Icon(
                  Icons.add,
                  size: 25,
                  color: wayaTheme.colorScheme.customPrimary,
                ),
                const Gap(8),
                Text(
                  "Add Payout Method",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
                ),



              ],
            ),
          )
      ],
    );
     /* Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(

          buttontext: 'Add Payout Method',
            hasButton: true,
            onTap: () {
              //WayaNav.toNamed(CreatePost.route);
            },
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              'assets/images/wallet/payout.png',
              height: 201.h,
            ),
            message: "No Payout Method Added"),
      ),
    );*/
  }
}