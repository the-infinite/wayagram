import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:wayagram/app/modules/sign_in/sign_in.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../bindings/wayagram_binding.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../profile/update_profile.dart';
import '../setup/interests.dart';

class ConfirmPIN extends StatelessWidget {
  ConfirmPIN({Key? key}) : super(key: key);

  static const route = '/confirmPIN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getAppColor(AppColors.background),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppThemes.appPaddingVal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                ImageHelper.svgImage(
                  'assets/images/wayagram2.svg',
                  color: getAppColor(AppColors.background),
                ),
                SizedBox(
                  height: Get.height * 0.1,
                ),
                ImageHelper.normalImage(
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
                    Get.to(() => Interests(),binding: WayagramBinding());

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
