import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../bindings/wayagram_binding.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_input.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../forgot_password/enter_email.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';

class SignIn extends GetView<AuthControllerWayagram> {
  const SignIn({Key? key}) : super(key: key);

  static const route = '/signIn';

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
                        'Welcome Back',
                        style: AppTextStyle.headline4.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
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
                      SizedBox(height: Get.height * 0.025),
                      PageInput(
                        hint: '',
                        label: 'Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        isCompulsory: true,
                        obscureText: true,
                        controller: controller.password,
                      ),
                      SizedBox(height: Get.height * 0.050),
                      AppButton(
                        title: 'Login',
                        onPressed: () async {
                          if(formKey.currentState!.validate()){
                            controller.twoFactorOTP.text = '';
                            await controller.resendOTPOnLogin(true);
                            //await controller.signIn();
                          }
                        },
                        borderRadius: 10,
                      ),
                      AppButton(
                        title:
                        'Forgot Password?',
                        onPressed: () {
                          Get.to(() => const EnterEmail());
                        },
                        borderRadius: 10,
                        bckgrndColor: (AppColors.background),
                        fontColor: AppColors.primary,
                      ),
                      SizedBox(height: Get.height * 0.050),
                      AppButton(
                        title:
                        'Don\'t have an account? Sign Up',
                        onPressed: () {
                          Get.to(() => const SignUp(),binding: WayagramBinding());
                        },
                        borderRadius: 10,
                        bckgrndColor: (AppColors.background),
                        fontColor: AppColors.primary,
                      ),
                      SizedBox(height: Get.height * 0.025),
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
