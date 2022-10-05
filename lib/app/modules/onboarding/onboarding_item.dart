import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
          if(pos == 0)
            Expanded(
              flex: 3,
              child: SvgPicture.asset(
                'assets/images/${onboardingModel.image}.svg',
                height: Get.width * 0.2,
                width: Get.height*0.4,
              ),
            ),
          if(pos == 1)
            Expanded(
              flex: 3,
              child: SvgPicture.asset(
                'assets/images/${onboardingModel.image}.svg',
                height: Get.width * 0.2,
                width: Get.height*0.35,
              ),
            ),
          if(pos == 2)
            Expanded(
              flex: 3,
              child: SvgPicture.asset(
                'assets/images/${onboardingModel.image}.svg',
                height: Get.width * 0.2,
                width: Get.height*0.36,
              ),
            ),
          const SizedBox(
            height: 11,
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  onboardingModel.title,
                  style: AppTextStyle.headline5.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 11,
                ),
                Text(
                  onboardingModel.subtitle,
                  style: AppTextStyle.bodyText2.copyWith(height: 1.5),
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
