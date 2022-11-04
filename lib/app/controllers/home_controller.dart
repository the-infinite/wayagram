import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/tabs/chats_tab.dart';
import 'package:wayagram/app/modules/home/tabs/discover_tab.dart';
import 'package:wayagram/app/modules/home/tabs/shops_tab.dart';

import '../../core/theme/app_colors.dart';
import '../data/model/log_in_model_entity.dart';
import '../data/model/profile_model_entity.dart';
import '../data/providers/api_response.dart';
import '../data/providers/my_pref.dart';
import '../modules/home/tabs/home_tab.dart';
import '../modules/home/tabs/notifications_tab.dart';
import '../repository/user_repo.dart';

class HomeController extends GetxController {
  final UserRepository userRepo;

  TextEditingController otp = TextEditingController();
  RxInt currentBottomNavPage = 0.obs;

  PageController shopController = PageController(initialPage: 0, keepPage: true);
  bool isPersonalShop = false;

  PageController notificationController = PageController(initialPage: 0, keepPage: true);
  bool isNotification = false;

  PageController chatController = PageController(initialPage: 0, keepPage: true);
  bool isChat = false;

  HomeController(this.userRepo);

  List<Widget> pages = const [
    HomeTab(),
    DiscoverTab(),
    ShopsTab(),
    NotificationsTab(),
    ChatsTab()
  ];
  List<String> imagePaths = [];

  var profile = ProfileModelEntity.fromJson(jsonDecode(MyPref.userProfile.val));
  var logInDetails = LogInModelEntity.fromJson(jsonDecode(MyPref.logInDetail.val));

  toggleShop(int index, {bool animate = true}) {
    if(index == 0) {
      isPersonalShop = false;
      if(animate) {
        shopController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    } else {
      isPersonalShop = true;
      if(animate) {
        shopController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    }
    update(['home']);
  }

  toggleNotification(int index, {bool animate = true}) {
    if(index == 0) {
      isNotification = false;
      if(animate) {
        notificationController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    } else {
      isNotification = true;
      if(animate) {
        notificationController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    }
    update(['home']);
  }

  toggleChat(int index) {
    if(index == 0) {
      isChat = false;
      chatController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    } else {
      isChat = true;
      chatController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
    update(['home']);
  }

  //home
  Future<ApiResponse> get getMoments => userRepo.getMoments();
  Future<ApiResponse> get getPosts => userRepo.getPosts();

  //discover
  Future<ApiResponse> get getGroups => userRepo.getGroups();
  Future<ApiResponse> get getSuggestedGroups => userRepo.getSuggestedGroups();
  Future<ApiResponse> get getSuggestedPages => userRepo.getSuggestedPages();
  Future<ApiResponse> get getEventsToAttend => userRepo.getEventsToAttend();

  Future<ApiResponse> get getPagesFollowed => userRepo.getPagesFollowed();
  Future<ApiResponse> get getPagesCreated => userRepo.getPagesCreated();

  Future<ApiResponse> get getGroupsFollowed => userRepo.getGroupsFollowed();
  Future<ApiResponse> get getGroupsCreated => userRepo.getGroupsCreated();

  //Shops
  Future<ApiResponse> get getAllProducts => userRepo.getAllProducts();
  Future<ApiResponse> get getMyProducts => userRepo.getMyProducts();

  //Notifications
  Future<ApiResponse> get getNotification => userRepo.getAllNotifications();

  Future<ApiResponse> get getBlocked => userRepo.getRestrictedAccount();
  Future<ApiResponse> get getMuted => userRepo.getMutedAccount();
  Future<ApiResponse> get getFollowing => userRepo.getFollowing();
  Future<ApiResponse> get getFollowers => userRepo.getFollowers();

  Future<ApiResponse> updateProfile(dynamic body) async {
    final response = await userRepo.updateProfile(body);
    await userRepo.getUserProfile(profile.userId.toString());
    AppOverlay.showInfoDialog(
        title: response.isSuccessful ? 'Success' : 'Error',
        content: response.message,
      onPressed: () {
        if(response.isSuccessful) {
          Get.back();
          Get.back();
        }else{
          Get.back();
        }
      }
    );
    update(['profile_page','home','settings']);
    return response;
  }

  Future<ApiResponse> postData(dynamic body,String url) async {
    final response = await userRepo.postData(url, body);
    await userRepo.getUserProfile(profile.userId.toString());
    return response;
  }

  Future<ApiResponse> putData(dynamic body,String url) async {
    final response = await userRepo.putData(url, body);
    await userRepo.getUserProfile(profile.userId.toString());
    return response;
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