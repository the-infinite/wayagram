import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../data/providers/api.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../../repository/user_repo.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';

class EnterEmail extends GetView<AuthController> {
  const EnterEmail(this.email, this.phone, {Key? key}) : super(key: key);

  final String? email;
  final String? phone;
  static const route = '/enterEmail';

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>AuthController(UserRepository(Api())));
    List<String> items = [];
    if(email != null) {
      items.add(email!);
      controller.emailOrPhone.text = items[0];
    }
    if(phone != null) {
      items.add(phone!);
      controller.emailOrPhone.text = items[0];
    }
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
          title: ImageHelper.normalImage(
            'assets/images/wayagram.png', width: Get.width * 0.3,
          ),
        ),
        body: GetBuilder<AuthController>(builder: (controller) {
          return SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppThemes.appPaddingVal),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.15),
                      Text(
                        'Change Password',
                        style: AppTextStyle.headline4.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
                        child: Text(
                          'Please choose where you want to receive the OTP code to change your password',
                          style: AppTextStyle.headline4.copyWith(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.04),
                      PageDropButton(
                        label: "OTP will be sent to",
                        hint: '',
                        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                        onChanged: (val) {
                          controller.emailOrPhone.text = val;
                        },
                        value: items[0],
                        items: items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: Get.height * 0.04),
                      AppButton(
                        title: 'Get OTP',
                        onPressed: () async {
                          if(formKey.currentState!.validate()){
                            await controller.getChangeOtp();
                          }
                        },
                        borderRadius: 10,
                      ),
                      SizedBox(height: Get.height * 0.050),
                    ],
                  ),
                ),
              ),
            ),
          );
        })
    );
  }
}
