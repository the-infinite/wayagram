import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/components/waya_buttons.dart';


class RegisteredDone extends StatefulWidget {
  const RegisteredDone({super.key});

  @override
  State<RegisteredDone> createState() => _RegisteredDonState();
}

class _RegisteredDonState extends State<RegisteredDone> {
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
                "Thank you for registering for University Got Talent! ",
                style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            Text(
              "Your application is currently under review. We’ll notify you once a decision has been made.",

              style: wayaTheme.textTheme.hintStyle, textAlign: TextAlign.center,),

            SizedBox(height: 17.h),
            WayaButton(
              callback: () async{
                Navigator.pop(context);
                //  WayaNav.toNamed("/contest-setting-content");
              },
              text: "View Application Status",
            ),
            const Gap(10),
            WayaButton(
                text: 'Copy Contest Invite Link',
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
