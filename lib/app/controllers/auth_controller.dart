import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../repository/user_repo.dart';

class AuthController extends GetxController {
  final UserRepository userRepo;

  TextEditingController otp = TextEditingController();
  TextEditingController referral = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  PageController pageController = PageController(initialPage: 0, keepPage: true);
  PageController businessPageController = PageController(initialPage: 0, keepPage: true);
  PageController personalPageController = PageController(initialPage: 0, keepPage: true);

  bool isBusiness = false;
  bool isTermsAndConditionsChecked = false;

  AuthController(this.userRepo);

  toggleBusiness(int index) {
    if(index == 0) {
      isBusiness = false;
      pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    } else {
      isBusiness = true;
      pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
    update();
  }

  toggleTermsAndConditions(bool value) {
    isTermsAndConditionsChecked = value;
    update();
  }
}