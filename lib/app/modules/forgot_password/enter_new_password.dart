import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_input.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';

class EnterNewPassword extends GetView<AuthControllerWayagram> {
  EnterNewPassword({Key? key}) : super(key: key);

  static const route = '/enterNewPassword';

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: ImageHelper.normalImage(
            'assets/images/wayagram.png', width: Get.width * 0.3,
          ),
          backgroundColor: AppColors.background,
        ),
        body: GetBuilder<AuthControllerWayagram>(builder: (controller) {
          return Container(
            color: AppColors.background,
            width: Get.width,
            height: Get.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppThemes.appPaddingVal),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.15),
                      Text(
                        'Change Password',
                        style: AppTextStyle.headline4.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
                        child: Text(
                          'Fill in your new password',
                          style: AppTextStyle.headline4.copyWith(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.06),
                      PageInput(
                        hint: '',
                        label: 'New Password',
                        validator: Validator.passwordValidation,
                        isCompulsory: true,
                        obscureText: true,
                        controller: controller.password,
                      ),
                      SizedBox(height: Get.height * 0.025),
                      PageInput(
                        hint: '',
                        label: 'Confirm Password',
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Please re-enter your password';
                          }
                          if (value != controller.password.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                        obscureText: true,
                        isCompulsory: true,
                        controller: controller.confirmPassword,
                      ),
                      SizedBox(height: Get.height * 0.050),
                      AppButton(
                        title: 'Reset Password',
                        onPressed: () async {
                          if(formKey.currentState!.validate()){
                            await controller.confirmResetPassword();
                          }
                        },
                        borderRadius: 10,
                      ),
                      SizedBox(height: Get.height * 0.050),
                    ],
                  ),
                ),
              ),
            ),
          );
        })
    );
  }
}
