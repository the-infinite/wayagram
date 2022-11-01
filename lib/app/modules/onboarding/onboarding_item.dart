import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import 'onboarding.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    Key? key,
    required this.onboardingModel,
    required this.pos,
  }) : super(key: key);

  final OnboardingModel onboardingModel;
  final int pos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraint) {
      return Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/${onboardingModel.image}.png',
              height: Get.width * 0.25,
              width: Get.height*0.25,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  onboardingModel.title,
                  style: AppTextStyle.headline5.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  onboardingModel.subtitle,
                  style: AppTextStyle.bodyText2.copyWith(height: 1.5,color: Colors.black,fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
