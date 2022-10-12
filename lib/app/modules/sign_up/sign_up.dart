import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_input.dart';
import '../sign_in/sign_in.dart';

class SignUp extends GetView<AuthController> {
  const SignUp({Key? key}) : super(key: key);

  static const route = '/signUp';

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return  Scaffold(
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
      body: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppThemes.appPaddingVal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.065),
                Text(
                  'Register',
                  style: AppTextStyle.headline4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.05),
                ToggleSwitch(
                  minWidth: Get.width * 0.4,
                  initialLabelIndex: controller.isBusiness ? 1 : 0,
                  totalSwitches: 2,
                  inactiveBgColor: const Color(0xffbdbdbd).withOpacity(.3),
                  activeBgColor: const [Colors.white, Colors.white],
                  activeBorders: [
                    Border.all(
                      color: const Color(0xffbdbdbd).withOpacity(.3),
                      width: 3.0,
                    ),
                    Border.all(
                      color: const Color(0xffbdbdbd).withOpacity(.3),
                      width: 3.0,
                    ),
                  ],
                  radiusStyle: true,
                  cornerRadius: 10.0,
                  labels: const ['Business account', 'Personal account'],
                  customTextStyles: [
                    AppTextStyle.bodyText1.copyWith(
                      color: const Color(0xff064A72),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    AppTextStyle.bodyText1.copyWith(
                      color: const Color(0xff064A72),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ],
                  onToggle: (index) {
                    controller.toggleBusiness(index!);
                    if (index == 0) {
                      //businessPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    } else {
                      //personalPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    }
                  },
                ),
                SizedBox(height: Get.height * 0.05),
                SizedBox(
                  height: Get.height*0.6,
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      //Business
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const PageInput(
                            hint: '',
                            label: 'Business Name',
                            validator: Validator.fullnameValidation,
                            isCompulsory: true,
                          ),
                          SizedBox(height: Get.height * 0.025),
                          const PageInput(
                            hint: '',
                            label: 'Business Email',
                            validator: Validator.fullnameValidation,
                            isCompulsory: true,
                          ),
                          SizedBox(height: Get.height * 0.025),
                          const PageInput(
                            hint: 'Business Phone Number',
                            label: 'Phone Number',
                            validator: Validator.emailValidation,
                            isCompulsory: true,
                            isPhoneNumber: true,
                          ),
                          SizedBox(height: Get.height * 0.050),
                          AppButton(
                            title: 'Next',
                            onPressed: () {
                              /*if (_formKey.currentState!.validate()) {
                                pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                              }*/
                            },
                            borderRadius: 10,
                          ),
                          AppButton(
                            title: 'Already have an account?  Login Now',
                            onPressed: () {
                              Get.toNamed(SignIn.route);
                            },
                            borderRadius: 10,
                            bckgrndColor: AppColors.background,
                            fontColor: AppColors.primary,
                          ),
                        ],
                      ),
                      //Business
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const PageInput(
                            hint: '',
                            label: 'Name',
                            validator: Validator.fullnameValidation,
                            isCompulsory: true,
                          ),
                          SizedBox(height: Get.height * 0.025),
                          const PageInput(
                            hint: '',
                            label: 'Last Name',
                            validator: Validator.fullnameValidation,
                            isCompulsory: true,
                          ),
                          SizedBox(height: Get.height * 0.025),
                          const PageInput(
                            hint: '',
                            label: 'Email Address',
                            validator: Validator.emailValidation,
                            isCompulsory: true,
                          ),
                          SizedBox(height: Get.height * 0.025),
                          const PageInput(
                            hint: '',
                            label: 'Phone Number',
                            validator: Validator.emailValidation,
                            isCompulsory: true,
                            isPhoneNumber: true,
                          ),
                          SizedBox(height: Get.height * 0.050),
                          AppButton(
                            title: 'Next',
                            onPressed: () {
                              /*if (_formKey.currentState!.validate()) {
                                pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                              }*/
                              //pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                            },
                            borderRadius: 10,
                          ),
                          AppButton(
                            title: 'Have an Account? Login',
                            onPressed: () {
                              Get.toNamed(SignIn.route);
                            },
                            borderRadius: 10,
                            bckgrndColor: AppColors.background,
                            fontColor: AppColors.primary,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
