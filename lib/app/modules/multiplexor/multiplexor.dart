import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/app/data/providers/my_pref.dart';
import 'package:wayagram/app/modules/sign_in/sign_in.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../firebase_options.dart';
import '../../bindings/wayagram_binding.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';

class Multiplexor extends StatefulWidget {
  const Multiplexor({Key? key,this.anotherApp = false,this.token = "",this.currentApp = "wayagram"}) : super(key: key);

  static const route = '/multiplexor';
  final bool anotherApp;
  final String currentApp;
  final String token;

  @override
  State<Multiplexor> createState() => _MultiplexorState();
}

class _MultiplexorState extends State<Multiplexor> {

  @override
  void initState() {
    super.initState();
    if(widget.anotherApp){
      initFirebase();
    }
  }

  Future<void> initFirebase() async {
    await GetStorage.init('MyPref');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  Widget build(BuildContext context) {
    MyPref.anotherApp.val = widget.anotherApp;
    MyPref.currentApp.val = widget.currentApp;

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
              ImageHelper.svgImage(
                'assets/images/wayagram2.svg',
              ),
              SizedBox(
                height: Get.height * 0.08,
              ),
              ImageHelper.normalImage(
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
                  Get.to(() => const SignUp(),binding: WayagramBinding());
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
                  Get.to(() => const SignIn(),binding: WayagramBinding());
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}
