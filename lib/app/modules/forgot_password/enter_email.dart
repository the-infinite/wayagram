import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_input.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';

class EnterEmail extends GetView<AuthController> {
  const EnterEmail({Key? key}) : super(key: key);

  static const route = '/enterEmail';

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Image.asset(
            'assets/images/wayagram.png', width: Get.width * 0.3,
          ),
        ),
        body: GetBuilder<AuthController>(builder: (controller) {
          return SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppThemes.appPaddingVal),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.15),
                      Text(
                        'Forgot Password',
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
                          'Please enter your email or phone number to reset your password associated with your wayagram account',
                          style: AppTextStyle.headline4.copyWith(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.04),
                      PageInput(
                        hint: '',
                        label: 'Email/Phone Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone number';
                          }
                          if (!GetUtils.isEmail(value) && !GetUtils.isPhoneNumber(value)) {
                            return 'Please enter a valid email or phone number';
                          }
                          return null;
                        },
                        isCompulsory: true,
                        controller: controller.emailOrPhone,
                      ),
                      SizedBox(height: Get.height * 0.050),
                      AppButton(
                        title: 'Get OTP',
                        onPressed: () async {
                          if(formKey.currentState!.validate()){
                            await controller.getResetOtp();
                          }
                        },
                        borderRadius: 10,
                      ),
                      SizedBox(height: Get.height * 0.050),
                      AppButton(
                        title:
                        'Don\'t have an account? Sign Up',
                        onPressed: () {
                          Get.toNamed(SignUp.route);
                        },
                        borderRadius: 10,
                        bckgrndColor: AppColors.background,
                        fontColor: AppColors.primary,
                      ),
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
