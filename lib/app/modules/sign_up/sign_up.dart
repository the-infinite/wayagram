import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../bindings/wayagram_binding.dart';
import '../../controllers/auth_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../sign_in/sign_in.dart';
import '../verify_otp/verify_otp.dart';

class SignUp extends GetView<AuthControllerWayagram> {
  SignUp({Key? key}) : super(key: key);

  static const route = '/signUp';

  @override
  Widget build(BuildContext context) {
    var businessList = [
      'Catering and Food',
      'Cakes and Pastries',
      'Event Planning',
      'Music and DJ',
      'Photography and Videography',
      'Makeup and Hair',
      'Decorations',
      'Health and Skin Care',
      'Fashion and Accessories',
      'Clothing, Accessories and Shoes',
      'Computers and Accessories',
      'Electronics and Accessories',
      'Transportation',
      'Church',
      'Mosque',
      'School',
      'Hospital',
      'Hotel',
      'Bar and Lounge',
      'Beauty Salon',
      'Barber Shop',
      'Gym',
      'Fitness Center',
      'Sports Club',
      'E-commerce',
      'Consulting',
      'Manufacturer',
      'Wholesaler',
      'Retailer',
      'Distributor',
      'Importer',
      'Exporter',
      'Others'
    ];
    GlobalKey<FormState> formKeyBusiness1 = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyBusiness2 = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyBusiness3 = GlobalKey<FormState>();

    GlobalKey<FormState> formKeyPersonal1 = GlobalKey<FormState>();
    GlobalKey<FormState> formKeyPersonal2 = GlobalKey<FormState>();

    return GetBuilder<AuthControllerWayagram>(builder: (controller) {
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
            'assets/images/wayagram.png',
            width: Get.width * 0.3,
          ),
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: AppThemes.appPaddingVal,right: AppThemes.appPaddingVal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.01),
                  Text(
                    'Register',
                    style: AppTextStyle.headline4.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Get.height * 0.03),
                  if(controller.currentPersonalPage == 0 && controller.currentBusinessPage == 0)
                    ToggleSwitch(
                      minWidth: Get.width * 0.4,
                      initialLabelIndex: controller.isBusiness ? 1 : 0,
                      totalSwitches: 2,
                      inactiveBgColor: Color(0xffbdbdbd).withOpacity(.3),
                      activeBgColor: [Colors.white, Colors.white],
                      activeBorders: [
                        Border.all(
                          color: Color(0xffbdbdbd).withOpacity(.3),
                          width: 3.0,
                        ),
                        Border.all(
                          color: Color(0xffbdbdbd).withOpacity(.3),
                          width: 3.0,
                        ),
                      ],
                      radiusStyle: true,
                      cornerRadius: 10.0,
                      labels: ['Business account', 'Personal account'],
                      customTextStyles: [
                        AppTextStyle.bodyText1.copyWith(
                          color: Color(0xff064A72),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        AppTextStyle.bodyText1.copyWith(
                          color: Color(0xff064A72),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ],
                      onToggle: (index) {
                        controller.toggleBusiness(index!);
                        if (index == 0) {
                          controller.personalEmail.text = "";
                          //businessPageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        } else {
                          controller.businessEmail.text = "";
                          //personalPageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        }
                      },
                    ),
                  if(controller.currentPersonalPage == 0 && controller.currentBusinessPage == 0)
                    SizedBox(height: Get.height * 0.02),
                  SizedBox(
                    height: (controller.currentBusinessPage == 0 || controller.currentBusinessPage == 2) ? Get.height*0.8 : (Get.height+ Get.height*0.2),
                    child: PageView(
                      controller: controller.pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        //Business
                        SizedBox(
                          height: Get.height,
                          child: PageView(
                            controller: controller.businessPageController,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Form(
                                key: formKeyBusiness1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    PageInput(
                                      hint: '',
                                      label: 'Business Name',
                                      validator: Validator.businessNameValidation,
                                      isCompulsory: true,
                                      controller: controller.businessName,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Business Email',
                                      validator: Validator.emailValidation,
                                      isCompulsory: true,
                                      controller: controller.businessEmail,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Business Phone Number',
                                      validator: Validator.phoneNumValidation,
                                      isCompulsory: true,
                                      isPhoneNumber: true,
                                      controller: controller.businessPhone,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageDropButton(
                                      label: "Business Type",
                                      hint: '',
                                      padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                      onChanged: (val) {
                                        //controller.businessType.value = val!;
                                      },
                                      value: "Catering and Food",
                                      items: businessList.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    AppButton(
                                      title: 'Next',
                                      onPressed: () {
                                        if(formKeyBusiness1.currentState!.validate()){
                                          controller.currentBusinessPage = 1;
                                          controller.update();
                                          controller.businessPageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                                        }
                                      },
                                      borderRadius: 10,
                                    ),
                                    AppButton(
                                      title: 'Already have an account?  Login Now',
                                      onPressed: () {
                                        Get.to(() => SignIn(),binding: WayagramBinding());
                                      },
                                      borderRadius: 10,
                                      bckgrndColor: getAppColor(AppColors.background),
                                      fontColor: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                              Form(
                                key: formKeyBusiness2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    PageInput(
                                      hint: '',
                                      label: 'First Name',
                                      validator: Validator.fullnameValidation,
                                      isCompulsory: true,
                                      controller: controller.firstname,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Last Name',
                                      validator: Validator.fullnameValidation,
                                      isCompulsory: true,
                                      controller: controller.lastname,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Personal Email Address',
                                      validator: Validator.emailValidation,
                                      isCompulsory: true,
                                      controller: controller.personalEmail,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: 'Personal Phone Number',
                                      label: 'Phone Number',
                                      validator: Validator.phoneNumValidation,
                                      isCompulsory: true,
                                      isPhoneNumber: true,
                                      controller: controller.personalPhone,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Office Address',
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return 'Please enter your office address';
                                        }
                                        return null;
                                      },
                                      isCompulsory: true,
                                      controller: controller.officeAddress,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageDropButton(
                                      label: "State",
                                      hint: '',
                                      padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                      onChanged: (val) {
                                        controller.updateCity(val.toString());
                                      },
                                      value: NigerianStatesAndLGA.allStates.first,
                                      items: NigerianStatesAndLGA.allStates.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.removeAllWhitespace),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageDropButton(
                                      label: "City",
                                      hint: '',
                                      padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                      onChanged: (val) {
                                        //controller.state.value = ;
                                      },
                                      value: controller.cities.first,
                                      items: controller.cities.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.removeAllWhitespace),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    AppButton(
                                      title: 'Next',
                                      onPressed: () {
                                        /*if (_formKey.currentState!.validate()) {
                                          pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                        }*/
                                        if(formKeyBusiness2.currentState!.validate()){
                                          controller.currentBusinessPage = 2;
                                          controller.businessPageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                                          controller.update();
                                        }
                                      },
                                      borderRadius: 10,
                                    ),
                                    AppButton(
                                      title:
                                      'Already have an account?  Login Now',
                                      onPressed: () {
                                        Get.to(() => SignIn(),binding: WayagramBinding());
                                      },
                                      borderRadius: 10,
                                      bckgrndColor: getAppColor(AppColors.background),
                                      fontColor: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                              Form(
                                key: formKeyBusiness3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    PageInput(
                                      hint: '',
                                      label: 'Referral Code',
                                      isCompulsory: false,
                                      controller: controller.referral,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Password',
                                      validator: Validator.passwordValidation,
                                      isCompulsory: true,
                                      obscureText: true,
                                      controller: controller.password,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Confirm Password',
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please confirm your password';
                                        } else if (val.toString() != controller.password.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      isCompulsory: true,
                                      obscureText: true,
                                    ),
                                    /*SizedBox(height: Get.height * 0.050),*/
                                    // Row(
                                    //   crossAxisAlignment:
                                    //   CrossAxisAlignment.center,
                                    //   mainAxisAlignment:
                                    //   MainAxisAlignment.center,
                                    //   children: [
                                    //     SizedBox(
                                    //       height: 20,
                                    //       width: 20,
                                    //       child: Checkbox(
                                    //         value: controller.isTermsAndConditionsChecked,
                                    //         onChanged: (value) {
                                    //           controller
                                    //               .toggleTermsAndConditions(
                                    //               value!);
                                    //         },
                                    //       ),
                                    //     ),
                                    //     SizedBox(width: 10),
                                    //     Expanded(
                                    //       child: InkWell(
                                    //         onTap: (){
                                    //           controller.launchURL('https://wayagram.ng/privacy-policy');
                                    //         },
                                    //         child: RichText(
                                    //           text: TextSpan(
                                    //             style: TextStyle(
                                    //               fontSize: 10.0,
                                    //               color: Colors.black,
                                    //               fontWeight: FontWeight.w400,
                                    //             ),
                                    //             children: <TextSpan>[
                                    //               TextSpan(
                                    //                   text:
                                    //                   'I consent to the collection and processing of my personal data in line with data regulations as described in the'),
                                    //               TextSpan(
                                    //                   text:
                                    //                   ' Wayagram’s Privacy Policy',
                                    //                   style: TextStyle(
                                    //                       fontWeight:
                                    //                       FontWeight.w400,
                                    //                       color:
                                    //                       AppColors.primary)),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: Get.height * 0.025),
                                    AppButton(
                                      title: 'Create Account',
                                      onPressed: () async {
                                        if(formKeyBusiness3.currentState!.validate()){
                                          await controller.signUpCorporate();
                                        }
                                      },
                                      borderRadius: 10,
                                      enabled: controller.isTermsAndConditionsChecked,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    /*InkWell(
                                      onTap: (){
                                        controller.launchURL('https://wayagram.ng/terms');
                                      },
                                      child: RichText(
                                        text: TextSpan(
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
                                                'Wayagram’s terms of acceptable use.',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.primary)),
                                          ],
                                        ),
                                      ),
                                    )*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Personal
                        SizedBox(
                          height: Get.height * 0.6,
                          child: PageView(
                            controller: controller.personalPageController,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Form(
                                key:formKeyPersonal1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    PageInput(
                                      hint: '',
                                      label: 'First Name',
                                      validator: Validator.fullnameValidation,
                                      isCompulsory: true,
                                      controller: controller.firstname,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Last Name',
                                      validator: Validator.fullnameValidation,
                                      isCompulsory: true,
                                      controller: controller.lastname,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Email Address',
                                      validator: Validator.emailValidation,
                                      isCompulsory: true,
                                      controller: controller.personalEmail,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    PageInput(
                                      hint: '',
                                      label: 'Phone Number',
                                      validator: Validator.phoneNumValidation,
                                      isCompulsory: true,
                                      isPhoneNumber: true,
                                      controller: controller.personalPhone,
                                    ),
                                    SizedBox(height: Get.height * 0.050),
                                    AppButton(
                                      title: 'Next',
                                      onPressed: () {
                                        /*if (_formKey.currentState!.validate()) {
                                          pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                        }*/
                                        if(formKeyPersonal1.currentState!.validate()){
                                          controller.currentPersonalPage = 1;
                                          controller.update();
                                          controller.personalPageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                                        }
                                      },
                                      borderRadius: 10,
                                      //enabled: controller.isTermsAndConditionsChecked,
                                    ),
                                    AppButton(
                                      title: 'Have an Account? Login',
                                      onPressed: () {
                                        Get.to(() => SignIn(),binding: WayagramBinding());
                                      },
                                      borderRadius: 10,
                                      bckgrndColor: getAppColor(AppColors.background),
                                      fontColor: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                              Form(
                                key:formKeyPersonal2,
                                child: Column(
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
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please confirm your password';
                                        } else if (val.toString() != controller.password.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      isCompulsory: true,
                                      obscureText: true,
                                      controller: controller.confirmPassword,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    /*Row(
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
                                                controller.toggleTermsAndConditions(value!);
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: InkWell(
                                              onTap: (){
                                                controller.launchURL('https://wayagram.ng/privacy-policy');
                                              },
                                              child: RichText(
                                                text: TextSpan(
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
                                                            ' Wayagram’s Privacy Policy',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                AppColors.primary)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),*/
                                    SizedBox(height: Get.height * 0.025),
                                    AppButton(
                                      title: 'Create Account',
                                      onPressed: () async {
                                        if(formKeyPersonal2.currentState!.validate()){
                                          await controller.signUpNormalUser();
                                        }
                                      },
                                      borderRadius: 10,
                                      enabled: controller.isTermsAndConditionsChecked,
                                    ),
                                    SizedBox(height: Get.height * 0.025),
                                    /*InkWell(
                                        onTap: (){
                                          controller.launchURL('https://wayagram.ng/terms');
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(text: 'By clicking the “Create your account” button, you agree to '),
                                              TextSpan(text: 'Wayagram’s terms of acceptable use.', style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.primary)),
                                            ],
                                          ),
                                        ),
                                      )*/
                                  ],
                                ),
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
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: AppThemes.appPaddingVal,right: AppThemes.appPaddingVal),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                            controller.toggleTermsAndConditions(value!);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            controller.launchURL('https://wayagram.ng/privacy-policy');
                          },
                          child: RichText(
                            text: TextSpan(
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
                                    ' Wayagram’s Privacy Policy',
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.w400,
                                        color:
                                        AppColors.primary)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.025),
                  InkWell(
                    onTap: (){
                      controller.launchURL('https://wayagram.ng/terms');
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'By creating an account, you agree to '),
                          TextSpan(text: 'Wayagram’s terms of acceptable use.', style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
