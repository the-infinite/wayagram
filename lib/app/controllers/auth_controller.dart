import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:wayagram/app/data/model/log_in_model_entity.dart';
import 'package:wayagram/app/modules/sign_in/sign_in.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../data/model/profile_model_entity.dart';
import '../data/providers/api_response.dart';
import '../data/providers/my_pref.dart';
import '../global_widgets/overlays.dart';
import '../modules/home/home.dart';
import '../modules/profile/confirm_pin.dart';
import '../modules/profile/create_pin.dart';
import '../modules/setup/interests.dart';
import '../modules/verify_otp/verify_otp.dart';
import '../repository/user_repo.dart';

class AuthController extends GetxController {
  final UserRepository userRepo;

  TextEditingController emailOrPhone = TextEditingController();
  OtpFieldController otpController = OtpFieldController();

  TextEditingController gender = TextEditingController(text: "MALE");
  TextEditingController businessName = TextEditingController();
  TextEditingController businessType = TextEditingController(text: 'Catering and Food');
  TextEditingController city = TextEditingController(text: 'Abia');
  TextEditingController state = TextEditingController(text: 'Abia North');
  TextEditingController otp = TextEditingController();
  TextEditingController referral = TextEditingController();
  TextEditingController personalEmail = TextEditingController();
  TextEditingController businessEmail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController personalPhone = TextEditingController();
  TextEditingController businessPhone = TextEditingController();
  TextEditingController personalAddress = TextEditingController();
  TextEditingController officeAddress = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  TextEditingController pin = TextEditingController();
  TextEditingController confirmPin = TextEditingController();

  var currentBusinessPage = 0;
  var currentPersonalPage = 0;
  PageController pageController = PageController(initialPage: 0, keepPage: true);
  PageController businessPageController = PageController(initialPage: 0, keepPage: true);
  PageController personalPageController = PageController(initialPage: 0, keepPage: true);

  bool isBusiness = false;
  bool isTermsAndConditionsChecked = false;

  var interests = <String>[];
  var cities = NigerianStatesAndLGA.abiaLGAs;

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

  updateCity(String stateName){
    cities = NigerianStatesAndLGA.getStateLGAs(stateName);
    update();
  }

  //Sign Up
  Map<String, dynamic> get _signUpCorporate => {
    'admin': "false",
    'businessType':businessType.text,
    'email': personalEmail.text,
    'firstName': firstname.text,
    "surname": lastname.text,
    'orgEmail': businessEmail.text,
    'orgName': businessName.text,
    'orgPhone': businessPhone.text.length == 10 ? "234${businessPhone.text}" : "234${businessPhone.text.substring(1,businessPhone.text.length)}",
    'orgType':businessType.text,
    'password': password.text,
    'phoneNumber': personalPhone.text.length == 10 ? "234${personalPhone.text}" : "234${personalPhone.text.substring(1,personalPhone.text.length)}",
    'state': state.text,
    'city': city.text,
    "officeAddress": officeAddress.text,
  };

  Map<String, dynamic> get _signUpNormalUser => {
    'admin': "false",
    'email': personalEmail.text,
    'firstName': firstname.text,
    "surname": lastname.text,
    'password': password.text,
    'phoneNumber': personalPhone.text.length == 10 ? "234${personalPhone.text}" : "234${personalPhone.text.substring(1,personalPhone.text.length)}",
    "referenceCode" : referral.text,
  };

  Future<void> signUpCorporate() async {
    var message = "";
    var buttonMessage = "";
    var isLogin = true;
    ApiResponse response = await userRepo.signUpCorporate(_signUpCorporate);
    if(!response.isSuccessful){
      if(response.message.toString().contains("This email already exists")) {
        message = "This email is already in Use, Please enter another email or log in";
        buttonMessage = "Login";
      }
      else if(response.message.toString().contains("This Phone number already exists")) {
        message = "This phone number is already in Use, Please enter another phone number or log in";
        buttonMessage = "Login";
      }
      else{
        message = "An Error Occurred";
        isLogin = false;
        buttonMessage = "Okay";
      }
      AppOverlay.showInfoDialog(
        title: 'Account Creation Failed',
        content: message,
        buttonText: buttonMessage,
        onPressed: () {
          if(response.isSuccessful){
            Get.toNamed(VerifyOTP.route);
          }else{
            if(isLogin){
              Get.toNamed(SignIn.route);
            }else{
              Get.back();
            }
          }
        },
      );
    }else{
      Get.toNamed(VerifyOTP.route);
    }
  }

  Future<void> signUpNormalUser() async {
    var message = "";
    var buttonMessage = "";
    var isLogin = true;
    print(_signUpNormalUser["phoneNumber"]);
    ApiResponse response = await userRepo.signUpNormalUser(_signUpNormalUser);
    print(response.message);
    if(!response.isSuccessful){
      if(response.message.toString().contains("This email already exists")) {
        message = "This email is already in Use, Please enter another email or log in";
        buttonMessage = "Login";
      }
      else if(response.message.toString().contains("This Phone number already exists")) {
        message = "This phone number is already in Use, Please enter another phone number or log in";
        buttonMessage = "Login";
      }
      else{
        message = "An Error Occurred";
        isLogin = false;
        buttonMessage = "Okay";
      }
      AppOverlay.showInfoDialog(
        title: 'Account Creation Failed',
        content: message,
        buttonText: buttonMessage,
        onPressed: () {
          if(response.isSuccessful){
            Get.toNamed(VerifyOTP.route);
          }else{
            if(isLogin){
              Get.toNamed(SignIn.route);
            }else{
              Get.back();
            }
          }
        },
      );
    }else{
      Get.toNamed(VerifyOTP.route);
    }
  }

  //Sign In
  Map<String, dynamic> get _signIn => {
    'emailOrPhoneNumber': GetUtils.isEmail(emailOrPhone.text) ?  emailOrPhone.text : emailOrPhone.text.length == 10 ? "234${emailOrPhone.text}" : "234${emailOrPhone.text.substring(1,emailOrPhone.text.length)}",
    'password': password.text,
  };

  Map<String, dynamic> get _signInFirst => {
    'emailOrPhoneNumber': GetUtils.isEmail(businessEmail.text) ?  businessEmail.text : personalEmail.text,
    'password': password.text,
  };

  Future<void> signIn() async {
    var message = "";
    var buttonMessage = "";
    var isLogin = true;
    ApiResponse response = await userRepo.signIn(_signIn);
    if(!response.isSuccessful){
      if(response.message.toString().contains("Bad credentials")) {
        message = "Bad credentials. Check your details and try again";
        buttonMessage = "Okay";
        isLogin = false;
      }
      else{
        message = "An Error Occurred";
        isLogin = false;
        buttonMessage = "Okay";
      }
      AppOverlay.showInfoDialog(
        title: 'Sign In Failed',
        content: message,
        buttonText: buttonMessage,
        onPressed: () {
          Get.back();
        },
      );
    }else{
      var data = response.data as LogInModelEntity;
      MyPref.authToken.val = data.token.toString();
      MyPref.logInDetail.val = jsonEncode(response.data);
      await getUserProfile(data.user!.id.toString());
    }
  }
  //First Sign IN
  Future<void> signInFirst() async {
    var message = "";
    var buttonMessage = "";
    var isLogin = true;
    ApiResponse response = await userRepo.signIn(_signInFirst);
    if(!response.isSuccessful){
      if(response.message.toString().contains("Bad credentials")) {
        message = "Bad credentials. Check your details and try again";
        buttonMessage = "Okay";
        isLogin = false;
      }
      else{
        message = "An Error Occurred";
        isLogin = false;
        buttonMessage = "Okay";
      }
      AppOverlay.showInfoDialog(
        title: 'An Error Occurred',
        content: message,
        buttonText: buttonMessage,
        onPressed: () {
          Get.back();
        },
      );
    }else{
      var data = response.data as LogInModelEntity;
      MyPref.authToken.val = data.token.toString();
      MyPref.logInDetail.val = jsonEncode(response.data);
      await getUserProfileFirst(data.user!.id.toString());
    }
  }

  Future<void> getUserProfile(String userID) async {
    ApiResponse response = await userRepo.getUserProfile(userID);
    if(!response.isSuccessful){
      AppOverlay.showInfoDialog(
        title: 'Sign In Failed',
        content: "An Error Occurred",
        buttonText: "Okay",
        onPressed: () {
          Get.back();
        },
      );
    }else{
      var data = response.data as ProfileModelEntity;
      MyPref.userProfile.val = jsonEncode(response.data);
      //getAllUserData();
      Get.toNamed(Home.route);
      //Get.toNamed(Home.route);
    }
  }

  Future<void> getUserProfileFirst(String userID) async {
    ApiResponse response = await userRepo.getUserProfile(userID);
    if(!response.isSuccessful){
      AppOverlay.showInfoDialog(
        title: 'PIN Creation Failed',
        content: "An Error Occurred",
        buttonText: "Okay",
        onPressed: () {
          Get.back();
        },
      );
    }else{
      var data = response.data as ProfileModelEntity;
      MyPref.userProfile.val = jsonEncode(response.data);
      //Get.toNamed(CreatePIN.route);
      //Get.toNamed(Home.route);
      await userRepo.getFollowedByWayaOfficial();
      Get.toNamed(Interests.route);
    }
  }

  //Confirm OTP
  Map<String, dynamic> get _getOTP => {
    'phoneOrEmail': personalEmail.text,
    "otp" : otp.text,
  };
  Future<void> confirmOTP() async {
    ApiResponse response = await userRepo.verifyOTP(_getOTP);
    var message = "";
    var buttonMessage = "";
    if(!response.isSuccessful){
      AppOverlay.showInfoDialog(
        title: 'OTP Verification Failed',
        content: response.message.toString().toLowerCase() == "record with provided input not found" ? "Incorrect OTP Entered" : "An Error Occurred",
        buttonText: "Okay",
        onPressed: () {
          Get.back();
        },
      );
    }else{
      await signInFirst();
      //Get.toNamed(CreatePIN.route);
      //Get.toNamed(SignIn.route);
    }
  }

  //Create PIN
  Map<String, dynamic> get _createPIN => {
    'email': personalEmail.text,
    "passcode" : pin.text,
    "name": "${firstname.text} ${lastname.text}",
    'phoneNumber': personalPhone.text.length == 10 ? "234${personalPhone.text}" : "234${personalPhone.text.substring(1,personalPhone.text.length)}",
    "roleId": 0,
    "inviteeId": 0,
    "invitorId": 0,
  };
  Map<String, dynamic> get _createPINBusiness => {
    'email': businessEmail.text,
    "passcode" : pin.text,
    "name": "${firstname.text} ${lastname.text}",
    'phoneNumber': businessPhone.text.length == 10 ? "234${businessPhone.text}" : "234${businessPhone.text.substring(1,businessPhone.text.length)}",
    "roleId": 0,
    "inviteeId": 0,
    "invitorId": 0,
  };
  Future<void> createPIN() async {
    var d = _createPIN;
    if(personalEmail.text.isEmpty){
      d = _createPINBusiness;
    }
    ApiResponse response = await userRepo.createPIN(d);
    if(!response.isSuccessful){
      AppOverlay.showInfoDialog(
        title: 'PIN Creation Failed',
        content:  "An Error Occurred",
        buttonText: "Okay",
        onPressed: () {
          Get.back();
        },
      );
    }else{
      Get.toNamed(ConfirmPIN.route);
      //Get.toNamed(SignIn.route);
    }
  }

  //Get User Data
  Future<void> getAllUserData() async {
    await userRepo.getFriends();
    await userRepo.getRestrictedAccount();
    await userRepo.getMutedAccount();
    await userRepo.getFollowers();
    await userRepo.getFollowing();
    await userRepo.getFriendSuggestions();
    await userRepo.getMoments();
    await userRepo.getPosts();
    //await userRepo.getGroups();
    await userRepo.getSuggestedGroups();
    await userRepo.getSuggestedPages();
    await userRepo.getEventsToAttend();
    await userRepo.getAllProducts();
    await userRepo.getMyProducts();
    await userRepo.getAllNotifications();
    await userRepo.getAccountNumber();
    await userRepo.getPageCategories();
    await userRepo.getGroupCategories();
  }
  void launchURL(String url) async {
    try {
      await launch(
        url,
        customTabsOption: const CustomTabsOption(
          toolbarColor: AppColors.primary,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
        ),
        safariVCOption: const SafariViewControllerOption(
          preferredBarTintColor: AppColors.primary,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}