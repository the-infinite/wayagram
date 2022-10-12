import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_input.dart';
import '../sign_in/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  static const route = '/signUp';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isBusiness = false;
  PageController businessPageController = PageController(initialPage: 0, keepPage: false);
  PageController personalPageController = PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {

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
                  initialLabelIndex: 0,
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

                  },
                ),
                SizedBox(height: Get.height * 0.05),
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
          ),
        ),
      ),
    );
  }
}
