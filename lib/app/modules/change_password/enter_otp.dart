import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:wayagram/app/global_widgets/overlays.dart';
import 'package:wayagram/app/modules/forgot_password/enter_new_password.dart';
import 'package:wayagram/app/modules/sign_in/sign_in.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../profile/create_pin.dart';
import '../profile/update_profile.dart';
import 'enter_new_password.dart';

class EnterChangeOTP extends GetView<AuthControllerWayagram> {
  EnterChangeOTP({Key? key}) : super(key: key);

  static const route = '/verifyOTP';

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
                  height: Get.height * 0.07,
                ),
                ImageHelper.normalImage(
                  'assets/images/otp.png',
                  width: Get.width * 0.3,
                  height: Get.width * 0.3,
                ),
                SizedBox(height: Get.height * 0.07),
                Text(
                  'Change your Password',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: Get.height * 0.035),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
                  child: Text(
                    'Please Input the OTP sent to your mobile number or email address to change your password',
                    style: AppTextStyle.headline4.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Get.height * 0.07),

                OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: Get.width * 0.1,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {

                  },
                  controller: controller.otpController,
                  obscureText: true,
                  onChanged: (value) {
                    controller.otp.text = value;
                  },
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                    borderColor: AppColors.grey,
                  ),
                ),

                SizedBox(height: Get.height * 0.07),
                AppButton(
                  title: 'Verify',
                  onPressed: () async {
                    if(controller.otp.text.length == 6) {
                      Get.to(() => EnterNewChangedPassword());
                    }else{
                      Get.snackbar("Error", "Please Enter a valid otp",backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  borderRadius: 10,
                ),
                SizedBox(height: 30),
                AppButton(
                  title: 'Did not get OTP?',
                  bckgrndColor: getAppColor(AppColors.background),
                  fontColor: AppColors.primary,
                  onPressed: () async {
                    await controller.getChangeOtp(showOverlay: true);
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
