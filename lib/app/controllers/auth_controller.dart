import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:wayagram/app/data/model/log_in_model_entity.dart';
import 'package:wayagram/app/modules/sign_in/sign_in.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../bindings/wayagram_binding.dart';
import '../data/model/ValidateUserModel.dart';
import '../data/model/full_user_profile_entity.dart';
import '../data/model/profile_model_entity.dart';
import '../data/providers/api_response.dart';
import '../data/providers/my_pref.dart';
import '../global_widgets/overlays.dart';
import '../modules/change_password/enter_otp.dart';
import '../modules/forgot_password/enter_otp.dart';
import '../modules/home/home.dart';
import '../modules/profile/confirm_pin.dart';
import '../modules/profile/create_pin.dart';
import '../modules/setup/interests.dart';
import '../modules/verify_otp/verify_otp.dart';
import '../repository/user_repo.dart';

class AuthControllerWayagram extends GetxController {
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
  TextEditingController oldPassword = TextEditingController();
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

  AuthControllerWayagram(this.userRepo);

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
    "wayaBankPayPosGram": "WAYAGRAM",
  };

  Map<String, dynamic> get _signUpNormalUser => {
    'admin': "false",
    'email': personalEmail.text,
    'firstName': firstname.text,
    "surname": lastname.text,
    'password': password.text,
    'phoneNumber': personalPhone.text.length == 10 ? "234${personalPhone.text}" : "234${personalPhone.text.substring(1,personalPhone.text.length)}",
    "referenceCode" : referral.text,
    "wayaBankPayPosGram": "WAYAGRAM",
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
      Get.snackbar("Account Creation Failed", message,backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      await userRepo.resendAuthOTP(personalEmail.text);
      Get.to(() => const VerifyOTP(),binding: WayagramBinding());
    }
  }

  Future<void> signUpNormalUser() async {
    var message = "";
    var buttonMessage = "";
    var isLogin = true;
    ApiResponse response = await userRepo.signUpNormalUser(_signUpNormalUser);
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
      Get.snackbar("Account Creation Failed", message,backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      await userRepo.resendAuthOTP(personalEmail.text);
      Get.to(() => const VerifyOTP(),binding: WayagramBinding());
    }
  }

  //Sign In
  Map<String, dynamic> get _signIn => {
    'emailOrPhoneNumber': GetUtils.isEmail(emailOrPhone.text) ?  emailOrPhone.text : emailOrPhone.text.startsWith("+234") ? emailOrPhone.text.substring(1,emailOrPhone.text.length) : emailOrPhone.text.startsWith("234") ? emailOrPhone.text : emailOrPhone.text.length == 10 ? "234${emailOrPhone.text}" : "234${emailOrPhone.text.substring(1,emailOrPhone.text.length)}",
    'password': password.text,
  };

  Map<String, dynamic> get _signInFirst => {
    'emailOrPhoneNumber': GetUtils.isEmail(businessEmail.text) ?  businessEmail.text : personalEmail.text,
    'password': password.text,
  };

  Future<void> signIn() async {
    var message = "";
    var buttonMessage = "";
    ApiResponse response = await userRepo.signIn(_signIn);
    if(!response.isSuccessful){
      if(response.message.toString().contains("Bad credentials")) {
        message = "Bad credentials. Check your details and try again";
        buttonMessage = "Okay";
      }
      else{
        message = "An Error Occurred";
        buttonMessage = "Okay";
      }
      Get.snackbar("Sign In Failed", message,backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      var data = response.data as LogInModelEntity;
      MyPref.authToken.val = data.token.toString();
      MyPref.logInDetail.val = jsonEncode(response.data);
      MyPref.referenceCode.val = data.user!.referenceCode.toString();
      MyPref.userId.val = data.user!.id.toString();
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
      Get.snackbar("An Error Occurred", "Please try again",backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      var data = response.data as LogInModelEntity;
      MyPref.authToken.val = data.token.toString();
      MyPref.logInDetail.val = jsonEncode(response.data);
      MyPref.userId.val = data.user!.id.toString();
      await getUserProfileFirst(data.user!.id.toString());
    }
  }

  Future<void> getUserProfile(String userID,{bool showError = false}) async {
    ApiResponse response = await userRepo.getFullUserProfile(userID);
    if(!response.isSuccessful){
      MyPref.authToken.val = "";
      if(showError){
        Get.snackbar("Sign In Failed", "An Error Occurred",backgroundColor: Colors.red, colorText: Colors.white);
      }
    }else{
      var data = response.data as FullUserProfileEntity;
      MyPref.fullProfile.val = jsonEncode(response.data);
      MyPref.profileId.val = data.id.toString();
      await subscribeToFirebaseNotification(data.userId.toString(),data.id.toString());
      await Get.offAll(() => const Home(),binding: WayagramBinding());
    }
  }

  Future<ApiResponse> validateUser(String token) async {
    MyPref.authToken.val = token;
    ApiResponse response = await userRepo.postData("/auth-service/api/v1/auth/validate-user",null,hasHeader: true,sso: false);
    if(response.isSuccessful){
      ValidateUserModel data = ValidateUserModel.fromJson(response.data);
      MyPref.userId.val = data.id.toString();
      MyPref.referenceCode.val = data.referenceCode.toString();
      await getUserProfile(data.id.toString(),showError: false);
    }
    return response;
  }

  Future<void> getUserProfileFirst(String userID) async {
    ApiResponse response = await userRepo.getFullUserProfile(userID);
    if(!response.isSuccessful){
      MyPref.authToken.val = "";
      Get.snackbar("An Error Occurred", "Please try again",backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      var data = response.data as FullUserProfileEntity;
      MyPref.fullProfile.val = jsonEncode(response.data);
      MyPref.profileId.val = data.id.toString();
      await userRepo.getFollowedByWayaOfficial();
      await subscribeToFirebaseNotification(data.userId.toString(),data.id.toString());
      Get.to(() => const Interests(),binding: WayagramBinding());
    }
  }

  //Confirm OTP
  Map<String, dynamic> get _getOTP => {
    'phoneOrEmail': personalEmail.text,
    "otp" : otp.text,
    "wayaBankPayPosGram": "WAYAGRAM",
  };
  Future<void> confirmOTP() async {
    ApiResponse response = await userRepo.verifyOTP(_getOTP);
    var message = "";
    var buttonMessage = "";
    if(!response.isSuccessful){
      message = response.message.toString().toLowerCase() == "record with provided input not found" ? "Incorrect OTP Entered" : "An Error Occurred";
      Get.snackbar("OTP Verification Failed", message,backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      await signInFirst();
    }
  }
  Future<void> resendOTP() async {
    print("Email is ${personalEmail.text}");
    ApiResponse response = await userRepo.resendAuthOTP(personalEmail.text);
    var message = "";
    var buttonMessage = "";
    if(!response.isSuccessful){
      Get.snackbar("Request Failed", response.message!=null ? response.message.toString() : "An Error Occurred",backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      Get.snackbar("OTP Resent", "OTP has been resent to your email address",backgroundColor: Colors.green, colorText: Colors.white);
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
    "wayaBankPayPosGram": "WAYAGRAM",
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
      Get.to(() => const ConfirmPIN(),binding: WayagramBinding());
    }
  }

  //Reset Password
  Future<void> getResetOtp({bool showOverlay = false}) async {
    var message = "";
    var buttonMessage = "";
    ApiResponse? response;
    if(GetUtils.isEmail(emailOrPhone.text)){
      var data = emailOrPhone.text;
      response = await userRepo.getData("/auth-service/api/v1/password/forgot-password/byEmail?email=$data",hasHeader: false,sso: false);
    }else{
      var data = emailOrPhone.text.startsWith("+234") ? emailOrPhone.text.substring(1,emailOrPhone.text.length) : emailOrPhone.text.startsWith("234") ? emailOrPhone.text : emailOrPhone.text.length == 10 ? "234${emailOrPhone.text}" : "234${emailOrPhone.text.substring(1,emailOrPhone.text.length)}";
      response = await userRepo.getData("/auth-service/api/v1/password/forgot-password/byPhone?phoneNumber=$data",hasHeader: false,sso: false);
    }
    if(!response.isSuccessful){
      if(response.message.toString().contains("Bad credentials")) {
        message = "Check your details and try again";
        buttonMessage = "Okay";
      }
      else{
        message = "An Error Occurred";
        buttonMessage = "Okay";
      }
      Get.snackbar("Error", message,backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      if(showOverlay){
        Get.snackbar("Success", "OTP Resent Successfully",backgroundColor: Colors.green, colorText: Colors.white);
      }else{
        Get.to(() => const EnterOTP());
      }
    }
  }
  Future<void> confirmResetPassword() async {
    var data = "";
    if(GetUtils.isEmail(emailOrPhone.text)){
      data = emailOrPhone.text;
    }else{
      data = emailOrPhone.text.startsWith("+234") ? emailOrPhone.text.substring(1,emailOrPhone.text.length) : emailOrPhone.text.startsWith("234") ? emailOrPhone.text : emailOrPhone.text.length == 10 ? "234${emailOrPhone.text}" : "234${emailOrPhone.text.substring(1,emailOrPhone.text.length)}";
    }
    var body = {
      "newPassword": password.text,
      "otp": otp.text,
      "phoneOrEmail": data
    };

    ApiResponse response = await userRepo.postData("/auth-service/api/v1/password/forgot-password", body);

    var message = "";
    var buttonMessage = "";
    if(!response.isSuccessful){
      if(response.message.toString().contains("is not valid")){
        message = "Incorrect OTP Entered";
        buttonMessage = "Okay";
      } else if(response.message.toString().contains("Record with Provided input not Found For User")){
        message = "User not found";
        buttonMessage = "Okay";
      }else if(response.message.toString().contains("New password cannot be same with old password")){
        message = "New password cannot be same with old password";
        buttonMessage = "Okay";
      }else{
        message = "An Error Occurred";
        buttonMessage = "Okay";
      }
      Get.snackbar("Password Reset Failed", message,backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      Get.snackbar("Success", "Password Reset Successfully",backgroundColor: Colors.green, colorText: Colors.white);
      password.clear();
      otp.clear();
      emailOrPhone.clear();
      Navigator.popUntil(Get.context!, (route) => Get.currentRoute == "/SignIn");
    }
  }

  Future<void> getChangeOtp({bool showOverlay = false}) async {
    var message = "";
    var buttonMessage = "";
    ApiResponse? response;
    if(GetUtils.isEmail(emailOrPhone.text)){
      var data = emailOrPhone.text;
      response = await userRepo.getData("/auth-service/api/v1/password/change-password/byEmail?email=$data",hasHeader: false,sso: false);
    }else{
      var data = emailOrPhone.text.startsWith("+234") ? emailOrPhone.text.substring(1,emailOrPhone.text.length) : emailOrPhone.text.startsWith("234") ? emailOrPhone.text : emailOrPhone.text.length == 10 ? "234${emailOrPhone.text}" : "234${emailOrPhone.text.substring(1,emailOrPhone.text.length)}";
      response = await userRepo.getData("/auth-service/api/v1/password/change-password/byPhone?phoneNumber=$data",hasHeader: false,sso: false);
    }
    if(!response.isSuccessful){
      if(response.message.toString().contains("Bad credentials")) {
        message = "Check your details and try again";
        buttonMessage = "Okay";
      }
      else{
        message = "An Error Occurred";
        buttonMessage = "Okay";
      }
      Get.snackbar("Error", message,backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      if(showOverlay){
        Get.snackbar("Success", "OTP Resent Successfully",backgroundColor: Colors.green, colorText: Colors.white);
      }else{
        Get.to(() => const EnterChangeOTP());
      }
    }
  }
  Future<void> confirmChangePassword() async {
    var data = "";
    if(GetUtils.isEmail(emailOrPhone.text)){
      data = emailOrPhone.text;
    }else{
      data = emailOrPhone.text.startsWith("+234") ? emailOrPhone.text.substring(1,emailOrPhone.text.length) : emailOrPhone.text.startsWith("234") ? emailOrPhone.text : emailOrPhone.text.length == 10 ? "234${emailOrPhone.text}" : "234${emailOrPhone.text.substring(1,emailOrPhone.text.length)}";
    }
    var body = {
      "newPassword": password.text,
      "otp": otp.text,
      "phoneOrEmail": data,
      "oldPassword": oldPassword.text
    };

    ApiResponse response = await userRepo.postData("/auth-service/api/v1/password/change-password", body);

    var message = "";
    var buttonMessage = "";
    print(response.message);
    if(!response.isSuccessful){
      if(response.message.toString().contains("is not valid")){
        message = "Incorrect OTP Entered";
        buttonMessage = "Okay";
      } else if(response.message.toString().contains("Record with Provided input not Found For User")){
        message = "User not found";
        buttonMessage = "Okay";
      }else if(response.message.toString().contains("New password cannot be same with old password")){
        message = "New password cannot be same with old password";
        buttonMessage = "Okay";
      }else if(response.message.toString().contains("Incorrect Old Password")){
        message = "Incorrect Old Password";
        buttonMessage = "Okay";
      }else{
        message = "An Error Occurred";
        buttonMessage = "Okay";
      }
      Get.snackbar("Password Change Failed", message,backgroundColor: Colors.red, colorText: Colors.white);
    }else{
      Get.snackbar("Success", "Password Changed Successfully",backgroundColor: Colors.green, colorText: Colors.white);
      password.clear();
      otp.clear();
      emailOrPhone.clear();
      Navigator.popUntil(Get.context!, (route) => Get.currentRoute == "/SecuritySettings");
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

  String image1 = "";
  String image2 = "";
  List<String> imagePaths = [];
  Future<ApiResponse> updateProfile(dynamic body) async {
    final response = await userRepo.updateProfile(body);
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    await userRepo.getFullUserProfile(profile.userId.toString());
    Get.offAll(() => const Home(),binding: WayagramBinding());

    return response;
  }

  Future<void> subscribeToFirebaseNotification(String userID, String profileID) async {
    String uniqueId = "";
    String? token = await FirebaseMessaging.instance.getToken();
    uniqueId = userID + profileID + token.toString() + DateTime.now().toString();
    var body = {
      "token": token,
      "platform": Platform.isAndroid ? "android" : "ios",
      "device_unique": uniqueId
    };
    var response = await userRepo.postData("https://services.staging.wayagram.ng/wayagram-service/notification/device-token-create?profile_id=$profileID&user_id=$userID",body);
    if(response.isSuccessful) {
      MyPref.uniqueID.val = uniqueId;
      MyPref.fcmID.val = token.toString();
    }
  }
}