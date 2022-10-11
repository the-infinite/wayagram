import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../global_widgets/app_button.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  static const route = '/signUp';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.08),
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
              inactiveBgColor: const Color(0xffF1F7FA),
              activeBgColor: const [Colors.white, Colors.white],
              activeBorders: [
                Border.all(
                  color: const Color(0xffF1F7FA),
                  width: 3.0,
                ),
                Border.all(
                  color: const Color(0xffF1F7FA),
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
          ],
        ),
      ),
    );
  }
}
