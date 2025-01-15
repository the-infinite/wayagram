import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';
import '../../../core/utils/waya_utils.dart';
import '../../wallet/view/components/wallet_cards.dart';

class UgtModal extends StatefulWidget {
  const UgtModal({super.key});

  @override
  State<UgtModal> createState() => _UgtModalState();
}

class _UgtModalState extends State<UgtModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/successugt.png', ),
            SizedBox(height: 20.h),
            Text(
                "You’re Almost There!!",
                style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            Text(
                "Before creating your contest, please complete \nthis contest setup in Settings. ",

                style: wayaTheme.textTheme.hintStyle, textAlign: TextAlign.center,),

            SizedBox(height: 17.h),
            WayaButton(
              callback: () async{
                WayaNav.toNamed("/contest-setting-content");
              },
              text: "Go to contest Settings",
            ),
            const Gap(10),
            WayaButton(
                text: 'Go Back',
                color: wayaTheme.colorScheme.greyColor300,
                textColor: wayaTheme.colorScheme.customBlack,
                border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {

                })
          ],
        ),
      ),
    );
  }
}
