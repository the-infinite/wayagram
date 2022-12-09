import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../widgets/moments_view.dart';
import '../widgets/posts_view.dart';

const String wayapayIconSvg="assets/images/waya_pay_ic.svg";
const String wayabankIconSvg="assets/images/waya_bank_ic.svg";
const String wayaposIconSvg="assets/images/waya_pos_ic.svg";
const String failed = "assets/images/failed.svg";

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    return GetBuilder<HomeControllerWayagram>(
        id: 'home_tab',
        builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          otherWayaBusiness(
            onWayaQuickTap: () {
              comingSoon();
            },
            onWayaPosTap: () {
              comingSoon();
            },
            onWayaBankTap: () {
              comingSoon();
            },
          ),
          SizedBox(height: Get.height * 0.015),
          FutureBuilder<ApiResponse>(
              future: controller.getMoments,
              builder: (context, snapshot) {
                var saved = MyPref.moments.val;
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final moments = snapshot.data!.data as List<MomentsModelEntity>;
                  return MomentsView(moments: moments);
                } else if(saved.isNotEmpty) {
                  var posts = MomentsModelEntity.getService(jsonDecode(saved));
                  return MomentsView(moments: posts);
                }else{
                  return const MomentsView(isLoading: true);
                }
              }),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 15,
            ),
            child: Text(
              'Posts',
              style: AppTextStyle.headline4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: Get.textScaleFactor * 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder<ApiResponse>(
              future: controller.getPosts,
              builder: (context, snapshot) {
                var savedPosts = MyPref.posts.val;
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final posts = snapshot.data!.data as List<AllPostsEntity>;
                  return PostsView(posts: posts);
                } else if(savedPosts.isNotEmpty){
                  var posts = AllPostsEntity.getService(jsonDecode(savedPosts));
                  return PostsView(posts: posts);
                }else{
                  if(snapshot.connectionState == ConnectionState.done){
                    return const SizedBox.shrink();
                  }
                  return const PostsView(isLoading: true);
                }
              }),
        ],
      );
    });
  }

  Widget otherWayaBusiness({
    required Function() onWayaQuickTap,
    required Function() onWayaPosTap,
    required Function() onWayaBankTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: Get.height * 0.02),
      child: Container(
        width: Get.width,
        //height: 0.21 * Get.height,
        decoration: const BoxDecoration(
            color: AppColors.lightGrayColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.025 * Get.width),
              child: Text("What more can your app do!",
                  style: Theme.of(Get.context!).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.025 * Get.width),
              child: Container(
                width: 0.070 * Get.width,
                height: 0.005 * Get.height,
                decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SizedBox(
              height: 0.01 * Get.height,
            ),
            SizedBox(
              width: Get.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  otherBusinessWidget(Get.context!, title: "WayaBank", onOptionsTap: () {
                    onWayaBankTap();
                  }, description: "Free internet banking \nand bills payment", icon: wayabankIconSvg),
                  otherBusinessWidget(Get.context!, title: "WayaQuick", onOptionsTap: () {
                        onWayaQuickTap();
                      }, description: "Accept Payment anytime, anywhere.", icon: wayapayIconSvg),
                  otherBusinessWidget(Get.context!, title: "WayaPos", onOptionsTap: () {
                    onWayaPosTap();
                  }, description: "Start accepting instant payment with Wayapos Terminal Device", icon: wayaposIconSvg),
                ],
              ),
            ),
            SizedBox(
              height: 0.01 * Get.height,
            ),
          ],
        ),
      ),
    );
  }

  Widget otherBusinessWidget(context, {onOptionsTap, icon, title, description}) {
    return InkWell(
        onTap: onOptionsTap,
        child: FittedBox(
          child: Container(
            margin: const EdgeInsetsDirectional.only(end: 2, start: 5),
            padding:
            const EdgeInsets.only(top: 1.0, bottom: 2, left: 5, right: 5),
            height: 0.150 * Get.height,
            width: 0.30 * Get.width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grayColor.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 0.07 * Get.height,
                  width: 0.07 * Get.width,
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.grayColor.withOpacity(.3),
                  ),
                  child: ImageHelper.svgImage(
                      icon ?? wayapayIconSvg
                  ),
                ),
                Text(title ?? '',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    )),
                SizedBox(
                  height: 0.01 * Get.width,
                ),
                Text(description ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8 * Get.textScaleFactor,
                      color: AppColors.black,
                    )),
              ],
            ),
          ),
        ));
  }

  void comingSoon() {
    showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return SizedBox(
                  height: height * 0.15,
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageHelper.svgImage(
                        failed,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Coming soon')
                    ],
                  ));
            },
          ),
        ));
  }
}