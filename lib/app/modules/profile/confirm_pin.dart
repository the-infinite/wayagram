import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:wayagram/app/modules/sign_in/sign_in.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../profile/update_profile.dart';

class ConfirmPIN extends StatelessWidget {
  const ConfirmPIN({Key? key}) : super(key: key);

  static const route = '/confirmPIN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppThemes.appPaddingVal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                SvgPicture.asset(
                  'assets/images/wayagram2.svg',
                  color: AppColors.background,
                ),
                SizedBox(
                  height: Get.height * 0.1,
                ),
                Image.asset(
                  'assets/images/otp.png',
                  width: Get.width * 0.4,
                  height: Get.width * 0.4,
                ),
                SizedBox(height: Get.height * 0.07),
                Text(
                  'Your PIN is Set',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.035),
                Text(
                  'You can sign in and out of your account with your secure PIN',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.07),



                SizedBox(height: Get.height * 0.07),
                AppButton(
                  title: 'Next',
                  onPressed: () {
                    // Get.toNamed(UpdateProfile.route);
                    //Get.toNamed(SignUp.route);
                  },
                  borderRadius: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
