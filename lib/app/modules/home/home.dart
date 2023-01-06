import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';
import 'package:wayagram/app/modules/home/widgets/bottom_sheet.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../bindings/wayagram_binding.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/log_in_model_entity.dart';
import '../../data/model/profile_model_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/app_drawer.dart';

import '../../global_widgets/page_input.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../contacts/contact.dart';
import '../search/search.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  static const route = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  var homeController = Get.find<HomeControllerWayagram>();
  var chatXController = Get.find<ChatControllerWayagram>();
  late TabController shopController;
  late TabController notificationController;
  late TabController chatController;

  @override
  void initState() {
    super.initState();
    shopController = TabController(length: 2, vsync: this);
    notificationController = TabController(length: 2, vsync: this);
    chatController = TabController(length: 2, vsync: this);

    homeController.shopController = shopController;
    homeController.notificationController = notificationController;
    homeController.chatController = chatController;
    if(Platform.isAndroid){
      homeController.checkPermissionStatus();
    }
    homeController.getAllUserData().then((value) => homeController.update());

    subscribeToFirebaseNotification(homeController.profile.userId.toString(), homeController.profile.id.toString());
    setUpMessaging();
  }

  Future<void> setUpMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppOverlay.showSuccessSnackBar(title: message.notification!.title.toString(),content: message.notification!.body!.toString());
    });
    chatXController.connectToSocket();
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
    if(MyPref.uniqueID.val.isNotEmpty){
      var body = {
        "device_token_id": MyPref.uniqueID.val,
      };
      await homeController.deleteData(body, "/wayagram-service/notification/delete-device-token");
    }
    var response = await homeController.userRepo.postData("https://services.staging.wayagram.ng/wayagram-service/notification/device-token-create?profile_id=$profileID&user_id=$userID",body);
    if(response.isSuccessful) {
      MyPref.uniqueID.val = uniqueId;
      MyPref.fcmID.val = token.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(
          id: 'home',
          builder: (controller) {
            var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
            var showSearchIcon = controller.currentBottomNavPage.value == 1 || controller.currentBottomNavPage.value == 2;

            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context1) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: IconButton(
                            icon: AppAvatar(
                              imgUrl: (fullProfile.avatar as String?).toString(),
                              radius: 45,
                            ),
                            onPressed: () {
                              Scaffold.of(context1).openDrawer();
                            },
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
                title: ImageHelper.normalImage(
                  'assets/images/wayagram_new.png', width: Get.width * 0.25, color:getAppColor(Color(0xff4F4F4F),),
                ),
                actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: IconButton(
                      icon: ImageHelper.normalImage(
                        (showSearchIcon && Platform.isAndroid) ? 'assets/images/search.png' : 'assets/images/follow_new_users.png',
                        color: getAppColor(AppColors.onBackground),
                        width: (showSearchIcon && Platform.isAndroid) ? Get.width*0.05 : Get.width*0.07,
                        height: (showSearchIcon && Platform.isAndroid) ? Get.width*0.05 : Get.width*0.07,
                      ),
                      onPressed: () {
                        if (showSearchIcon && Platform.isAndroid) {
                          Get.to(() => Search(),binding: WayagramBinding());
                        } else {
                          Get.to(() => Contact(),binding: WayagramBinding());
                        }
                      },
                      color: getAppColor(AppColors.background),
                    ),
                  ),
                )
              ],
                backgroundColor: getAppColor(AppColors.background),
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: getAppColor(AppColors.background),
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.dark,
                    systemNavigationBarColor: getAppColor(AppColors.background),
                    systemNavigationBarIconBrightness: Brightness.dark
                ),
            ),
              body: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  if(controller.currentBottomNavPage.value == 2)
                    Divider(
                    color: getAppColor(Colors.grey.shade400),
                    thickness: 0.3,
                  ),
                  if(controller.currentBottomNavPage.value == 2)
                    TabBar(
                      controller: shopController,
                      padding: EdgeInsets.zero,
                      labelColor: getAppColor(AppColors.onBackground),
                      unselectedLabelColor: getAppColor(Color(0xff9A9A9A)),
                      indicatorColor: AppColors.primary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontSize: Get.width*0.035,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: Get.width*0.035,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(text: 'All Products',iconMargin: EdgeInsets.zero,),
                        Tab(text: 'My Products',iconMargin: EdgeInsets.zero,),
                      ],
                      onTap: (index) {

                      },
                    ),
                  if(controller.currentBottomNavPage.value == 3)
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: getAppColor(Colors.grey.shade400),
                    ),
                  if(controller.currentBottomNavPage.value == 3)
                    TabBar(
                      controller: notificationController,
                      padding: EdgeInsets.zero,
                      labelColor: getAppColor(AppColors.onBackground),
                      unselectedLabelColor: getAppColor(Color(0xff9A9A9A)),
                      indicatorColor: AppColors.primary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontSize: Get.width*0.035,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: Get.width*0.035,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(text: 'All',iconMargin: EdgeInsets.zero,),
                        Tab(text: 'Requests',iconMargin: EdgeInsets.zero,),
                      ],
                      onTap: (index) {

                      },
                    ),
                  /*if(controller.currentBottomNavPage.value == 4)
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: getAppColor(Colors.grey.shade400),
                    ),
                  if(controller.currentBottomNavPage.value == 4)
                    TabBar(
                      controller: shopController,
                      padding: EdgeInsets.zero,
                      labelColor: getAppColor(AppColors.background),
                      unselectedLabelColor: getAppColor(Color(0xff9A9A9A)),
                      indicatorColor: AppColors.primary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontSize: Get.width*0.035,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: Get.width*0.035,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(text: 'Chats',iconMargin: EdgeInsets.zero,),
                        Tab(text: 'Calls',iconMargin: EdgeInsets.zero,),
                      ],
                      onTap: (index) {

                      },
                    ),*/
                  Divider(
                    height: 0.5,
                    thickness: 0.45,
                    color: getAppColor(Colors.grey.shade400),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: (controller.currentBottomNavPage.value == 2 || controller.currentBottomNavPage.value == 3 || controller.currentBottomNavPage.value == 4) ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          controller.pages[controller.currentBottomNavPage.value],
                        ],
                      ),
                    ),
                  ),
                  if(controller.currentBottomNavPage.value != 1)
                    SizedBox(height: kBottomNavigationBarHeight),
                ],
              ),
            ),
              drawer: AppDrawer(),
              extendBody: controller.currentBottomNavPage.value == 1 ? false : true,
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: getAppColor(AppColors.background),
                showSelectedLabels: true,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageHelper.normalImage(
                    'assets/images/u_home-alt.png',
                    width: 25,
                    color: controller.currentBottomNavPage.value == 0 ? AppColors.primary : AppColors.grey,
                  ),
                  label: 'Home',
                  backgroundColor: getAppColor(AppColors.background),
                ),
                BottomNavigationBarItem(
                  icon: ImageHelper.normalImage(
                    'assets/images/u_compass.png',
                    width: 25,
                    color: controller.currentBottomNavPage.value == 1 ? AppColors.primary : AppColors.grey,
                  ),
                  label: 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.shopping_cart, color: controller.currentBottomNavPage.value == 2 ? AppColors.primary : AppColors.grey,
                  ),
                  label: 'Shops',
                ),
                BottomNavigationBarItem(
                  icon: ImageHelper.normalImage(
                    'assets/images/mdi_notifications_none.png',
                    width: 25,
                    color: controller.currentBottomNavPage.value == 3 ? AppColors.primary : AppColors.grey,
                  ),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: ImageHelper.normalImage(
                    'assets/images/message-outline.png',
                    width: 25,
                    color: controller.currentBottomNavPage.value == 4 ? AppColors.primary : AppColors.grey,
                  ),
                  label: 'Chat',
                ),
              ],
                currentIndex: controller.currentBottomNavPage.value,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  controller.currentBottomNavPage.value = index;
                  controller.update(['home']);
                  controller.toggleShop(0,animate: false);
                }
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.bottomSheet(
                      WayaBottomSheet(
                        isChat: controller.currentBottomNavPage.value == 4,
                      ),
                      isScrollControlled: true
                  );
                },
                backgroundColor: AppColors.primary,
                child: Icon(Icons.add,color: Colors.white),
          ),
            );
          }),
    );
  }
}
