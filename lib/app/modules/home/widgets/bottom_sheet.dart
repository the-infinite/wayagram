import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
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
import '../../../data/model/wallet_model.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../create_posts/donations.dart';
import '../../create_posts/events.dart';
import '../../create_posts/polls.dart';
import '../widgets/moments_view.dart';
import '../widgets/posts_view.dart';
import 'notification_view.dart';

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
          //height: Get.height * 0.65,
          decoration: const BoxDecoration(
            color: AppColors.background1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Create text
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.020, left: Get.width*0.15, right: 20,bottom: Get.height * 0.015),
                child: Text(
                  'Create',
                  style: AppTextStyle.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.045,
                  ),
                ),
              ),
              BottomSheetButton(
                  icon: Icons.post_add_rounded,
                  title: "POST",
                  subtitle: "Share a post or write what is on your mind",
                  onTap: () {
                    controller.isProductPost = false;
                    controller.pageToPost = null;
                    controller.groupToPost = null;
                    controller.postToQuote = null;
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => const CreatePosts());
                  }
              ),

              BottomSheetButton(
                  icon: Icons.poll,
                  title: "POLLS",
                  subtitle: "Create paid or free polls for users",
                  onTap: () {
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => const CreatePoll());
                  }
              ),

              BottomSheetButton(
                  icon: Icons.book_rounded,
                  title: "PAGES",
                  subtitle: "Create a page for your business or brand",
                  onTap: () {
                    controller.imagePaths.clear();
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
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => const CreateGroup());
                  }
              ),
              BottomSheetButton(
                  icon: Icons.calendar_today_rounded,
                  title: "EVENTS",
                  subtitle: "Bring people together with public or private events",
                  onTap: () {
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => const CreateEvent());
                  }
              ),
              BottomSheetButton(
                  icon: Icons.people_alt_rounded,
                  title: "DONATION",
                  subtitle: "Create a donation page for a cause",
                  onTap: () {
                    controller.imagePaths.clear();
                    Get.back();
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
                    controller.isProductPost = true;
                    controller.pageToPost = null;
                    controller.groupToPost = null;
                    controller.postToQuote = null;
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => const CreatePosts());
                  }
              ),
              BottomSheetButton(
                  icon: Icons.video_camera_back_rounded,
                  title: "GO LIVE",
                  subtitle: "Go live on Wayagram",
                  onTap: () {
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => const CreateLiveVideo());
                  }
              ),
            ],
          ),
        );
      }),
    );
  }
}

class RepostBottomSheet extends StatelessWidget {
  const RepostBottomSheet({Key? key, required this.post}) : super(key: key);
  final AllPostsEntity post;
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
          //height: Get.height * 0.65,
          decoration: const BoxDecoration(
            color: AppColors.background1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Get.height * 0.01,
              ),
              BottomSheetButton(
                  icon: FeatherIcons.repeat,
                  title: "REPOST",
                  subtitle: "Share this post on your timeline",
                  onTap: () {
                    controller.imagePaths.clear();
                    Get.back();
                    var body = {
                      "original_post_id": post.id,
                      "reposter_profile_id": controller.profile.id,
                      //"repost_comment_desc": textController.text,
                    };
                    controller.postData(body, "/wayagram-service/all-posts/repost-post").then((value) async {
                      if(value.isSuccessful){
                        await controller.getPosts;
                        controller.update(['profile_page','home_tab','home']);
                        AppOverlay.showSuccessSnackBar(content: "Post reposted successfully");
                      }else{
                        AppOverlay.showErrorSnackBar(content: "Error reposting post");
                      }
                    });
                  }
              ),
              BottomSheetButton(
                  icon: FeatherIcons.edit,
                  title: "QUOTE POST",
                  subtitle: "Share your opinion on this post",
                  onTap: () {
                    controller.isProductPost = false;
                    controller.pageToPost = null;
                    controller.groupToPost = null;
                    controller.postToQuote = post;
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => const CreatePosts());
                  }
              ),
            ],
          ),
        );
      }),
    );
  }
}

class WalletBottomSheet extends StatelessWidget {
  const WalletBottomSheet({Key? key,this.title = "Wallet List",this.onTap}) : super(key: key);

  final Function(WalletModel wallet)? onTap;
  final String title;
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
      child: GetBuilder<HomeController>(id:"wallet_bottom_sheet",builder: (controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.020, bottom: Get.height * 0.015),
                child: Text(
                  title,
                  style: AppTextStyle.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.045,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.50,
                ),
                child: FutureBuilder<ApiResponse>(
                    future: controller.getData("temporal-service/api/v1/wallet/accounts/${controller.profile.userId}", true),
                    builder: (context, snapshot) {
                      var savedPosts = ReadWriteValue('wayagram_wallets', '', MyPref.box);
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts = WalletModel.listFromJson(snapshot.data!.data);
                        savedPosts.val = jsonEncode(posts);
                        if(posts.isEmpty){
                          return SizedBox(
                              height: Get.height*0.3,
                              child: const Center(child: Text('No Wallets Available'),));
                        }
                        return ListView.builder(
                          itemCount: posts.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var post = posts[index];
                            return BottomSheetButton(
                                icon: Icons.money_rounded,
                                title: post.accountNo.toString(),
                                subtitle: "${post.acctCrncyCode} ${post.clrBalAmt}",
                                onTap: () {
                                  if(onTap != null){
                                    Get.back();
                                    onTap!(post);
                                  }
                                }
                            );
                          },
                        );
                      }
                      else if(savedPosts.val.isNotEmpty){
                        var posts = WalletModel.listFromJson(jsonDecode(savedPosts.val));
                        if(posts.isEmpty){
                          return SizedBox(
                              height: Get.height*0.3,
                              child: const Center(child: Text('No Wallets Available'),));
                        }
                        return ListView.builder(
                          itemCount: posts.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var post = posts[index];
                            return BottomSheetButton(
                                icon: Icons.money_rounded,
                                title: post.accountNo.toString(),
                                subtitle: "${post.acctCrncyCode} ${post.clrBalAmt}",
                                onTap: () {
                                  if(onTap != null){
                                    Get.back();
                                    onTap!(post);
                                  }
                                }
                            );
                          },
                        );
                      }else{
                        if(snapshot.connectionState == ConnectionState.done){
                          return SizedBox(
                              height: Get.height*0.3,
                              child: const Center(child: Text('No Wallets Available'),));
                        }
                        return const NotificationView(isLoading: true);
                      }
                    }),
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
                size: Get.width*0.040,
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
                    fontSize: Get.width * 0.04,
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