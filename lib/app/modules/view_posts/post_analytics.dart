import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/app/modules/view_posts/poll_analytics.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/CommentModel.dart';
import '../../data/model/DonationsModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/promotion_pricing_model.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/app_input.dart';
import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/posts_view.dart';
import '../promotion/promote_post.dart';
import 'donation_analytics.dart';

class PostAnalytics extends StatefulWidget {
  const PostAnalytics({Key? key,required this.post}) : super(key: key);

  final AllPostsEntity post;

  @override
  State<PostAnalytics> createState() => _PostAnalyticsState();
}

class _PostAnalyticsState extends State<PostAnalytics> {
  FocusNode inputNode = FocusNode();
  var impressionsController = TextEditingController(text: '0');
  var engagementsController = TextEditingController(text: '0');
  var parentID = "";
  var usernameToReplyTo = "";

  void openKeyboard(){
    FocusScope.of(context).requestFocus(inputNode);
  }

  void closeKeyboard(){
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    int impressions = 0;
    int likes = 0;
    int reposts = 0;
    int comments = 0;
    if(widget.post.engagement != null){
      if(widget.post.engagement!.viewCount != null){
        impressions = widget.post.engagement!.viewCount!.toInt();
      }
      if(widget.post.engagement!.likeCount != null){
        likes = widget.post.engagement!.likeCount!.toInt();
      }
      if(widget.post.engagement!.repostCount != null){
        reposts = widget.post.engagement!.repostCount!.toInt();
      }
      if(widget.post.engagement!.commentCount != null){
        comments = widget.post.engagement!.commentCount!.toInt();
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "comment_page",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              "Post Activity",
              style: TextStyle(
                color: const Color(0xff4F4F4F),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(FeatherIcons.arrowLeft, color: Colors.black)
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: const Color(0xffEDEAEA),
                  height: 1.0,
                )),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: Get.width*0.008,right: Get.width*0.008),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Post(
                      post: widget.post,
                      fullProfile: fullProfile,
                      homeController: controller,
                      showActions: false,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffEDEAEA), width: 1),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    widgetAnalyticsWidget(
                        "Impressions",
                        "Times people saw this post on wayagram",
                        impressions.toString()
                    ),
                    const SizedBox(height: 10,),
                    widgetAnalyticsWidget(
                        "Total engagements",
                        "Times people interacted with this post",
                        (likes + reposts + comments).toString()
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: AppButton(
                        title: 'Promote this Post',
                        onPressed: () async {
                          //https://services.staging.wayagram.ng/wayagram-service/all-posts/get-promotion-pricing-configs?page=1&limit=50&sso_id=639
                          var res = await  controller.getData("/wayagram-service/all-posts/get-promotion-pricing-configs?page=1&limit=50", true);
                          if(Get.currentRoute == "/PostAnalytics"){
                            var savedPosts = ReadWriteValue('wayagram_promotion_pricing_model', '', MyPref.box);
                            if(res.isSuccessful || savedPosts.val.isNotEmpty){
                              List<PromotionPricingModel> promotionPricingModelList = [];
                              if(res.isSuccessful){
                                promotionPricingModelList = PromotionPricingModel.listFromJson(res.data['data']);
                                savedPosts.val = jsonEncode(res.data['data']);

                                if(promotionPricingModelList.isEmpty){
                                  AppOverlay.showErrorSnackBar(title : "Promotion Error",content: "No promotion plans available now, please check back later");
                                }else{
                                  Get.to(() => PromotePost(post: widget.post));
                                }
                              }else{
                                if(savedPosts.val.isEmpty){
                                  AppOverlay.showErrorSnackBar(title : "Promotion Error",content: "No promotion plans available now, please check back later");
                                }else{
                                  Get.to(() => PromotePost(post: widget.post));
                                }
                              }
                            }else{
                              AppOverlay.showErrorSnackBar(title : "Promotion Error",content: "Error getting promotion configuration");
                            }
                          }
                        },
                        borderRadius: 10,
                        fontColor: AppColors.primary,
                        bckgrndColor: AppColors.background,
                        width: double.infinity,
                        fontSize: Get.textScaleFactor * 18,
                        border: Border.all(color: AppColors.primary, width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Promote your post to reach more people and boost engagements",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: Get.textScaleFactor * 16,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if(widget.post.kind == 'donation')
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: AppButton(
                        title: 'View Donation Analytics',
                        onPressed: () async {
                          //https://services.staging.wayagram.ng/wayagram-service/all-posts/get-donation-statistics?donation_id=4471087b-2328-457f-bafa-151989595898&sso_id=639
                          if(Get.currentRoute == "/PostAnalytics"){
                            var donation = DonationsModel.fromJson(widget.post.donation);
                            var res = await  controller.getData("/wayagram-service/all-posts/get-donation-statistics?donation_id=${donation.id}", true);
                            var savedPosts = ReadWriteValue('wayagram_donation_statistics_${donation.id}', '', MyPref.box);

                            if(res.isSuccessful){
                              savedPosts.val = jsonEncode(res.data);
                              Get.to(() => const DonationAnalytics(),arguments: donation);
                            }else{
                              if(savedPosts.val.isNotEmpty){
                                Get.to(() => const DonationAnalytics(),arguments: donation);
                              }else{
                                AppOverlay.showErrorSnackBar(content: "Error getting donation statistics");
                              }
                            }
                          }
                        },
                        borderRadius: 10,
                        fontColor: AppColors.onPrimary,
                        bckgrndColor: AppColors.primary,
                        width: double.infinity,
                        fontSize: Get.textScaleFactor * 18,
                        border: Border.all(color: AppColors.primary, width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    if(widget.post.isPoll == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AppButton(
                          title: 'View Poll Analytics',
                          onPressed: () async {
                            if(Get.currentRoute == "/PostAnalytics"){
                              var res = await  controller.getData("/wayagram-service/all-posts/get-single-poll?poll_id=${widget.post.poll!.id}", true);
                              var savedPosts = ReadWriteValue('wayagram_poll_statistics_${widget.post.poll!.id}', '', MyPref.box);
                              var savedVotes = ReadWriteValue('wayagram_poll_votes_${widget.post.poll!.id}', '', MyPref.box);

                              if(res.isSuccessful){
                                var response = await  controller.getData("/wayagram-service/all-posts/get-poll-votes?poll_id=${widget.post.poll!.id}", true);
                                if(response.isSuccessful){
                                  savedPosts.val = jsonEncode(res.data);
                                  savedVotes.val = jsonEncode(response.data['data']);
                                  Get.to(() => const PollAnalytics(),arguments: widget.post.poll!);
                                }else{
                                  if(savedVotes.val.isNotEmpty){
                                    Get.to(() => const PollAnalytics(),arguments: widget.post.poll!);
                                  }else{
                                    AppOverlay.showErrorSnackBar(content: "Error getting poll statistics");
                                  }
                                }
                              }else{
                                if(savedPosts.val.isNotEmpty){
                                  Get.to(() => const PollAnalytics(),arguments: widget.post.poll!);
                                }else{
                                  AppOverlay.showErrorSnackBar(content: "Error getting poll statistics");
                                }
                              }
                            }
                          },
                          borderRadius: 10,
                          fontColor: AppColors.onPrimary,
                          bckgrndColor: AppColors.primary,
                          width: double.infinity,
                          fontSize: Get.textScaleFactor * 18,
                          border: Border.all(color: AppColors.primary, width: 1),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Padding widgetAnalyticsWidget(String title, String subtitle, String amount) {
    return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffEDEAEA), width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Get.width*0.025,vertical: Get.height*0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.textScaleFactor * 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.textScaleFactor * 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Text(
                              amount,
                              style: TextStyle(
                                color: const Color(0xff4F4F4F),
                                fontSize: Get.textScaleFactor * 15,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
  }
}