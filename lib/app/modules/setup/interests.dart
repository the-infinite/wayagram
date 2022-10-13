import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../global_widgets/app_button.dart';

class Interests extends StatelessWidget {
  const Interests({Key? key}) : super(key: key);

  static const route = '/interests';

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
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.25,
                height: Get.height * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary,
                ),
                child: Center(
                  child: Text(
                    'Continue',
                    style: AppTextStyle.headline4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: Get.width * 0.03,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: Get.height * 0.05,
          ),
          Text(
            'Select interest',
            style: AppTextStyle.headline4.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
