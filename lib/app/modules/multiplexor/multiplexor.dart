import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/app/modules/sign_in/sign_in.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../global_widgets/app_button.dart';

class Multiplexor extends StatelessWidget {
  const Multiplexor({Key? key}) : super(key: key);

  static const route = '/multiplexor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.only(left: AppThemes.appPaddingVal,right: AppThemes.appPaddingVal,top: AppThemes.appPaddingVal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.05,
              ),
              SvgPicture.asset(
                'assets/images/wayagram2.svg',
              ),
              SizedBox(
                height: Get.height * 0.08,
              ),
              Image.asset(
                'assets/images/multiplexor.png',
                width: Get.height * 0.38,
                height: Get.height * 0.38,
                fit: BoxFit.cover,
              ),
              SizedBox(height: Get.height * 0.06),
              Text(
                'Discover, Connect and Transact',
                style: AppTextStyle.headline4.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: Get.textScaleFactor * 15,
                ),
              ),
              Text(
                'with Wayapaychat application',
                style: AppTextStyle.headline4.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: Get.textScaleFactor * 15,
                ),
              ),
              SizedBox(height: Get.height * 0.1),
              AppButton(
                title: 'Get Started',
                onPressed: () {
                  Get.toNamed(SignUp.route);
                },
                borderRadius: 300,
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.016,
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              AppButton(
                title: 'Login',
                bckgrndColor: Colors.white,
                fontColor: AppColors.primary,
                onPressed: () {
                  Get.toNamed(SignIn.route);
                },
                borderRadius: 300,
                border: Border.all(color: AppColors.primary),
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.016,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
