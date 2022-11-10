import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/widgets/bottom_sheet.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/log_in_model_entity.dart';
import '../../data/model/profile_model_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/app_drawer.dart';
import '../../global_widgets/page_input.dart';
import '../contacts/contact.dart';
import '../search/search.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';

class Home extends GetView<HomeController> {
  const Home({Key? key}) : super(key: key);

  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(
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
                        padding: const EdgeInsets.only(left: 10.0),
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
                title: Image.asset(
                'assets/images/wayagram_new.png', width: Get.width * 0.25,
              ),
                actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: IconButton(
                      icon: Image.asset(
                        showSearchIcon ? 'assets/images/search.png' : 'assets/images/follow_new_users.png',
                        color: Colors.black,
                        width: showSearchIcon ? Get.width*0.05 : Get.width*0.07,
                        height: showSearchIcon ? Get.width*0.05 : Get.width*0.07,
                      ),
                      onPressed: () {
                        if (showSearchIcon) {
                          Get.toNamed(Search.route);
                        } else {
                          Get.toNamed(Contact.route);
                        }
                      },
                    ),
                  ),
                )
              ],
                backgroundColor: AppColors.background,
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: AppColors.background,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.dark,
                    systemNavigationBarColor: AppColors.background,
                    systemNavigationBarIconBrightness: Brightness.dark
                ),
            ),
              body: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  if(controller.currentBottomNavPage.value == 2)
                    const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                  if(controller.currentBottomNavPage.value == 2)
                    ToggleSwitch(
                    minWidth: Get.width * 0.5,
                    initialLabelIndex: controller.isPersonalShop ? 1 : 0,
                    totalSwitches: 2,
                    inactiveBgColor: AppColors.background,
                    activeBgColor: const [AppColors.background, AppColors.background],
                    activeBorders: [
                      //Bottom Border
                      Border.all(
                        color: AppColors.background,
                        width: 3.0,
                      ),
                      Border.all(
                        color: AppColors.background,
                        width: 3.0,
                      ),
                    ],
                    radiusStyle: true,
                    cornerRadius: 10.0,
                    labels: const ['All Products', 'My Products'],
                    customTextStyles: [
                      AppTextStyle.bodyText1.copyWith(
                        color: !controller.isPersonalShop ? AppColors.primary : const Color(0xff064A72),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      AppTextStyle.bodyText1.copyWith(
                        color: controller.isPersonalShop ? AppColors.primary : const Color(0xff064A72),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ],
                    onToggle: (index) {
                      controller.toggleShop(index!);
                      if (index == 0) {
                        //businessPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      } else {
                        //personalPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      }
                    },
                  ),
                  if(controller.currentBottomNavPage.value == 3)
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.3,
                    ),
                  if(controller.currentBottomNavPage.value == 3)
                    ToggleSwitch(
                      minWidth: Get.width * 0.5,
                      initialLabelIndex: controller.isNotification ? 1 : 0,
                      totalSwitches: 2,
                      inactiveBgColor: AppColors.background,
                      activeBgColor: const [AppColors.background, AppColors.background],
                      activeBorders: [
                        //Bottom Border
                        Border.all(
                          color: AppColors.background,
                          width: 3.0,
                        ),
                        Border.all(
                          color: AppColors.background,
                          width: 3.0,
                        ),
                      ],
                      radiusStyle: true,
                      cornerRadius: 10.0,
                      labels: const ['All', 'Requests'],
                      customTextStyles: [
                        AppTextStyle.bodyText1.copyWith(
                          color: !controller.isNotification ? AppColors.primary : const Color(0xff064A72),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        AppTextStyle.bodyText1.copyWith(
                          color: controller.isNotification ? AppColors.primary : const Color(0xff064A72),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ],
                      onToggle: (index) {
                        controller.toggleNotification(index!);
                        if (index == 0) {
                          //businessPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        } else {
                          //personalPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        }
                      },
                    ),
                  if(controller.currentBottomNavPage.value == 4)
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.3,
                    ),
                  if(controller.currentBottomNavPage.value == 4)
                    ToggleSwitch(
                      minWidth: Get.width * 0.5,
                      initialLabelIndex: controller.isChat ? 1 : 0,
                      totalSwitches: 2,
                      inactiveBgColor: AppColors.background,
                      activeBgColor: const [AppColors.background, AppColors.background],
                      activeBorders: [
                        //Bottom Border
                        Border.all(
                          color: AppColors.background,
                          width: 3.0,
                        ),
                        Border.all(
                          color: AppColors.background,
                          width: 3.0,
                        ),
                      ],
                      radiusStyle: true,
                      cornerRadius: 10.0,
                      labels: const ['Chats', 'Calls'],
                      customTextStyles: [
                        AppTextStyle.bodyText1.copyWith(
                          color: !controller.isChat ? AppColors.primary : const Color(0xff064A72),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        AppTextStyle.bodyText1.copyWith(
                          color: controller.isChat ? AppColors.primary : const Color(0xff064A72),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ],
                      onToggle: (index) {
                        controller.toggleChat(index!);
                        if (index == 0) {
                          //businessPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        } else {
                          //personalPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        }
                      },
                    ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: (controller.currentBottomNavPage.value == 2 || controller.currentBottomNavPage.value == 3 || controller.currentBottomNavPage.value == 4) ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          controller.pages[controller.currentBottomNavPage.value],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
              drawer: const AppDrawer(),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: AppColors.background,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/u_home-alt.png',
                    width: 25,
                    color: controller.currentBottomNavPage.value == 0 ? AppColors.primary : AppColors.grey,
                  ),
                  label: 'Home',
                  backgroundColor: AppColors.background,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
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
                  icon: Image.asset(
                    'assets/images/mdi_notifications_none.png',
                    width: 25,
                    color: controller.currentBottomNavPage.value == 3 ? AppColors.primary : AppColors.grey,
                  ),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
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
                  Get.bottomSheet(const WayaBottomSheet(),isScrollControlled: true);
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add,color: Colors.white),
          ),
            );
          }),
    );
  }
}
