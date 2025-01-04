import 'package:flutter/material.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class SplashScreenVm extends ChangeNotifier {
  void runStartUpLogic() {
    Future.delayed(Duration(seconds: 3), () {
      // navigate to home
      WayaNav.toNamed("/onboarding");
    });
  }
}

