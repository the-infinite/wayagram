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

class VerifyOTP extends GetView<AuthController> {
  const VerifyOTP({Key? key}) : super(key: key);

  static const route = '/verifyOTP';

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
                  width: Get.width * 0.3,
                  height: Get.width * 0.3,
                ),
                SizedBox(height: Get.height * 0.07),
                Text(
                  'Verify your Account',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.035),
                Text(
                  'A one time verification code has been',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  'sent to your phone number',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: Get.height * 0.07),

                OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: Get.width * 0.1,
                  style: const TextStyle(
                      fontSize: 17
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {

                  },
                ),

                SizedBox(height: Get.height * 0.07),
                AppButton(
                  title: 'Verify',
                  onPressed: () {
                    //Get.toNamed(SignUp.route);
                  },
                  borderRadius: 10,
                ),
                const SizedBox(height: 30),
                AppButton(
                  title: 'Did not get OTP?',
                  bckgrndColor: AppColors.background,
                  fontColor: AppColors.primary,
                  onPressed: () {
                    //Get.toNamed(SignIn.route);
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
