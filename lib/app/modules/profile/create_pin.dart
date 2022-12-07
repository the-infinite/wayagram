import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:wayagram/app/modules/sign_in/sign_in.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../profile/update_profile.dart';
import 'confirm_pin.dart';

class CreatePIN extends GetView<AuthControllerWayagram> {
  const CreatePIN({Key? key}) : super(key: key);

  static const route = '/createPIN';

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
                ImageHelper.svgImage(
                  'assets/images/wayagram2.svg',
                  color: AppColors.background,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                ImageHelper.normalImage(
                  'assets/images/otp.png',
                  width: Get.width * 0.3,
                  height: Get.width * 0.3,
                ),
                SizedBox(height: Get.height * 0.07),
                Text(
                  'Create a secure Pin',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.035),
                Text(
                  'Keep your account safe with a 4 digit pin',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: Get.height * 0.07),

                SizedBox(
                  width: Get.width * 0.8,
                  child: Text(
                    'Input Pin',
                    style: AppTextStyle.headline4.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: Get.width * 0.1,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {

                  },
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                    borderColor: AppColors.grey,
                  ),
                  onChanged: (pin) {
                    controller.pin.text = pin;
                  },
                ),

                SizedBox(height: Get.height * 0.03),

                SizedBox(
                  width: Get.width * 0.8,
                  child: Text(
                    'Confirm New Pin',
                    style: AppTextStyle.headline4.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: Get.width * 0.1,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {

                  },
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                    borderColor: AppColors.grey,
                  ),
                  onChanged: (pin) {
                    controller.confirmPin.text = pin;
                  },
                ),

                SizedBox(height: Get.height * 0.07),
                AppButton(
                  title: 'Continue',
                  onPressed: () async {
                    if(controller.pin.text.isEmpty){
                      AppOverlay.showInfoDialog(title: 'Error', content: 'Please enter a valid PIN');
                    }else if(controller.pin.text != controller.confirmPin.text){
                      AppOverlay.showInfoDialog(title: 'Error', content: 'PINs do not match');
                    }else{

                      await controller.createPIN();
                    }

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
