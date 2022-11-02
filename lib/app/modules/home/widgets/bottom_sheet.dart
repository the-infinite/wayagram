import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wayagram/app/modules/create_posts/go_live.dart';
import 'package:wayagram/app/modules/create_posts/groups.dart';
import 'package:wayagram/app/modules/create_posts/normal_posts.dart';
import 'package:wayagram/app/modules/create_posts/pages.dart';
import 'package:wayagram/app/modules/create_posts/products.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../create_posts/donations.dart';
import '../../create_posts/events.dart';
import '../../create_posts/polls.dart';
import '../widgets/moments_view.dart';
import '../widgets/posts_view.dart';

class WayaBottomSheet extends StatelessWidget {
  const WayaBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background1,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(builder: (controller) {
        return Container(
          height: Get.height * 0.7,
          decoration: const BoxDecoration(
            color: AppColors.background1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Create text
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 40, right: 20,bottom: 10),
                child: Text(
                  'Create',
                  style: AppTextStyle.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.05,
                  ),
                ),
              ),
              BottomSheetButton(
                  icon: Icons.post_add_rounded,
                  title: "POST",
                  subtitle: "Share a post or write what is on your mind",
                  onTap: () {
                    Get.back();
                    Get.to(() => const CreatePosts());
                  }
              ),

              BottomSheetButton(
                  icon: Icons.poll,
                  title: "POLLS",
                  subtitle: "Create paid or free polls for users",
                  onTap: () {
                    Get.back();
                    Get.to(() => const CreatePoll());
                  }
              ),

              BottomSheetButton(
                  icon: Icons.book_rounded,
                  title: "PAGES",
                  subtitle: "Create a page for your business or brand",
                  onTap: () {
                    Get.back();
                    Get.to(() => const CreatePage());
                  }
              ),

              SizedBox(
                height: Get.height * 0.015,
              ),

              BottomSheetButton(
                  icon: Icons.people_alt_rounded,
                  title: "GROUP",
                  subtitle: "Create a private or public group of interest",
                  onTap: () {
                    Get.to(() => const CreateGroup());
                  }
              ),
              BottomSheetButton(
                  icon: Icons.calendar_today_rounded,
                  title: "EVENTS",
                  subtitle: "Bring people together with public or private events",
                  onTap: () {
                    Get.to(() => const CreateEvent());
                  }
              ),
              BottomSheetButton(
                  icon: Icons.people_alt_rounded,
                  title: "DONATION",
                  subtitle: "Create a donation page for a cause",
                  onTap: () {
                    Get.to(() => const CreateDonation());
                  }
              ),

              SizedBox(
                height: Get.height * 0.015,
              ),
              BottomSheetButton(
                  icon: Icons.shopping_cart,
                  title: "PRODUCT",
                  subtitle: "Create and online display products for users to purchase",
                  onTap: () {
                    Get.to(() => const CreateProduct());
                  }
              ),
              BottomSheetButton(
                  icon: Icons.video_camera_back_rounded,
                  title: "GO LIVE",
                  subtitle: "Go live on Wayagram",
                  onTap: () {
                    Get.to(() => const CreateLiveVideo());
                  }
              ),
              SizedBox(
                height: Get.height * 0.015,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.only(left: Get.width*0.025, right: Get.width*0.025, top: Get.height*0.01, bottom: Get.height*0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Get.width*0.030),
              decoration: BoxDecoration(
                color: AppColors.fadedBlue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: AppColors.purple,
                size: Get.width*0.050,
              ),
            ),
            SizedBox(width: Get.width*0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: Get.width*0.80,
                  child: Text(
                    subtitle,
                    style: AppTextStyle.subtitle1.copyWith(
                      color: Colors.grey,
                      fontSize: Get.width*0.035,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}