import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import '../sign_in/sign_in.dart';
import '../verify_otp/verify_otp.dart';

class SignUp extends GetView<AuthController> {
  const SignUp({Key? key}) : super(key: key);

  static const route = '/signUp';

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            'assets/images/wayagram.png',
            width: Get.width * 0.3,
          ),
        ),
        body: GetBuilder<AuthController>(builder: (controller) {
          return SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppThemes.appPaddingVal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height * 0.02),
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
                    if(controller.currentPersonalPage == 0 && controller.currentBusinessPage == 0)
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
                    if(controller.currentPersonalPage == 0 && controller.currentBusinessPage == 0)
                      SizedBox(height: Get.height * 0.05),
                    SizedBox(
                      height: Get.height ,
                      child: PageView(
                        controller: controller.pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          //Business
                          SizedBox(
                            height: Get.height ,
                            child: PageView(
                              controller: controller.businessPageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
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
                                        controller.currentBusinessPage = 1;
                                        controller.update();
                                        controller.businessPageController.animateToPage(1, duration: const Duration(
                                                milliseconds: 500), curve: Curves.easeIn);
                                      },
                                      borderRadius: 10,
                                    ),
                                    AppButton(
                                      title:
                                          'Already have an account?  Login Now',
                                      onPressed: () {
                                        Get.toNamed(SignIn.route);
                                      },
                                      borderRadius: 10,
                                      bckgrndColor: AppColors.background,
                                      fontColor: AppColors.primary,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const PageInput(
                                      hint: '',
                                      label: 'First Name',
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
                                      label: 'Personal Email Address',
                                      validator: Validator.fullnameValidation,
                                      isCompulsory: true,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    const PageInput(
                                      hint: 'Personal Phone Number',
                                      label: 'Phone Number',
                                      validator: Validator.emailValidation,
                                      isCompulsory: true,
                                      isPhoneNumber: true,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    const PageInput(
                                      hint: '',
                                      label: 'Office Address',
                                      validator: Validator.fullnameValidation,
                                      isCompulsory: true,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageDropButton(
                                      label: "State",
                                      hint: '',
                                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      onChanged: (val) {

                                      },
                                      value: NigerianStatesAndLGA.allStates.first,
                                      items: NigerianStatesAndLGA.allStates.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          child: Text(value),
                                          value: value,
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageDropButton(
                                      label: "City",
                                      hint: '',
                                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      onChanged: (val) {

                                      },
                                      value: NigerianStatesAndLGA.abiaLGAs.first,
                                      items: NigerianStatesAndLGA.abiaLGAs.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          child: Text(value),
                                          value: value,
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    AppButton(
                                      title: 'Next',
                                      onPressed: () {
                                        /*if (_formKey.currentState!.validate()) {
                                        pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                      }*/
                                        controller.currentBusinessPage = 2;
                                        controller.businessPageController.animateToPage(2, duration: const Duration(
                                            milliseconds: 500), curve: Curves.easeIn);
                                        controller.update();
                                      },
                                      borderRadius: 10,
                                    ),
                                    AppButton(
                                      title:
                                      'Already have an account?  Login Now',
                                      onPressed: () {
                                        Get.toNamed(SignIn.route);
                                      },
                                      borderRadius: 10,
                                      bckgrndColor: AppColors.background,
                                      fontColor: AppColors.primary,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const PageInput(
                                      hint: '',
                                      label: 'Referral Code',
                                      validator: Validator.fullnameValidation,
                                      isCompulsory: false,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    const PageInput(
                                      hint: '',
                                      label: 'Password',
                                      validator: Validator.passwordValidation,
                                      isCompulsory: true,
                                      obscureText: true,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    const PageInput(
                                      hint: '',
                                      label: 'Confirm Password',
                                      validator: Validator.passwordValidation,
                                      isCompulsory: true,
                                      obscureText: true,
                                    ),
                                    SizedBox(height: Get.height * 0.050),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                            value: controller
                                                .isTermsAndConditionsChecked,
                                            onChanged: (value) {
                                              controller
                                                  .toggleTermsAndConditions(
                                                  value!);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: RichText(
                                            text: const TextSpan(
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                    'I consent to the collection and processing of my personal data in line with data regulations as described in the'),
                                                TextSpan(
                                                    text:
                                                    'Wayabank’s Privacy Policy',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color:
                                                        AppColors.primary)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    AppButton(
                                      title: 'Create Account',
                                      onPressed: () {
                                        Get.toNamed(VerifyOTP.route);
                                        /*if (_formKey.currentState!.validate()) {
                                        pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                      }*/
                                        //pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                      },
                                      borderRadius: 10,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              'By clicking the “Create your account” button, you agree to '),
                                          TextSpan(
                                              text:
                                              'Wayabank’s terms of acceptable use.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.primary)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //Personal
                          SizedBox(
                            height: Get.height * 0.6,
                            child: PageView(
                              controller: controller.personalPageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
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
                                        controller.currentPersonalPage = 1;
                                        controller.update();
                                        controller.personalPageController
                                            .animateToPage(1,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeIn);
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
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    PageInput(
                                      hint: '',
                                      label: 'Referral Code [Optional]',
                                      isCompulsory: false,
                                      controller: controller.referral,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Create Password',
                                      validator: Validator.passwordValidation,
                                      isCompulsory: true,
                                      obscureText: true,
                                      controller: controller.password,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Confirm Password',
                                      validator: Validator.passwordValidation,
                                      isCompulsory: true,
                                      obscureText: true,
                                      controller: controller.confirmPassword,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                            value: controller
                                                .isTermsAndConditionsChecked,
                                            onChanged: (value) {
                                              controller
                                                  .toggleTermsAndConditions(
                                                      value!);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: RichText(
                                            text: const TextSpan(
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        'I consent to the collection and processing of my personal data in line with data regulations as described in the'),
                                                TextSpan(
                                                    text:
                                                        'Wayabank’s Privacy Policy',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColors.primary)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    AppButton(
                                      title: 'Create Account',
                                      onPressed: () {
                                        Get.toNamed(VerifyOTP.route);
                                        /*if (_formKey.currentState!.validate()) {
                                        pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                      }*/
                                        //pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                      },
                                      borderRadius: 10,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  'By clicking the “Create your account” button, you agree to '),
                                          TextSpan(
                                              text:
                                                  'Wayabank’s terms of acceptable use.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.primary)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        })
    );
  }
}
