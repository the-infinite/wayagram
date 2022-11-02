import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../global_widgets/app_button.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  static const route = '/updateProfile';

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
        title: Text('Update Profile', style: AppTextStyle.subtitle1.copyWith(
          color: Colors.black,
        )),
        centerTitle: false,
          actions: [
            Center(
              child: SizedBox(
                child: AppButton(
                  title: 'Save',
                  onPressed: () {

                  },
                  borderRadius: 10,
                  fontColor: AppColors.primary,
                  bckgrndColor: AppColors.background,
                  border: Border.all(color: AppColors.background, width: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                ),
              ),
            )
          ]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

        ],
      ),
    );
  }
}
