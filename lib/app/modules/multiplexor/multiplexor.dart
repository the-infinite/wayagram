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
          padding: const EdgeInsets.all(AppThemes.appPaddingVal),
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
                height: Get.height * 0.1,
              ),
              Image.asset(
                'assets/images/multiplexor.png',
                width: Get.width * 0.85,
                height: Get.width * 0.85,
              ),
              SizedBox(height: Get.height * 0.07),
              Text(
                'Discover, Connect and Transact',
                style: AppTextStyle.headline4.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'with Wayapaychat application',
                style: AppTextStyle.headline4.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: Get.height * 0.07),
              AppButton(
                title: 'Get Started',
                onPressed: () {
                  Get.toNamed(SignUp.route);
                },
                borderRadius: 300,
              ),
              const SizedBox(height: 30),
              AppButton(
                title: 'Login',
                bckgrndColor: Colors.white,
                fontColor: AppColors.primary,
                onPressed: () {
                  Get.toNamed(SignIn.route);
                },
                borderRadius: 300,
                border: Border.all(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
