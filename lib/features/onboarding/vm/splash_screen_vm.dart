import 'package:flutter/material.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/onboarding/views/onboarding_view.dart';

class SplashScreenVm extends ChangeNotifier {
  void runStartUpLogic() {
    Future.delayed(Duration(seconds: 3), () {
      // navigate to home
      WayaNav.to(const OnboardingView());
    });
  }
}
