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
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/CommentModel.dart';
import '../../data/model/DonationsModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/products_model_entity.dart';
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
import '../home/widgets/product_view.dart';
import '../promotion/promote_post.dart';
import '../promotion/promote_product.dart';
import 'donation_analytics.dart';

class ProductAnalytics extends StatefulWidget {
  ProductAnalytics({Key? key,required this.post}) : super(key: key);

  final ProductsModelData post;

  @override
  State<ProductAnalytics> createState() => _ProductAnalyticsState();
}

class _ProductAnalyticsState extends State<ProductAnalytics> {
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
    if(widget.post.post != null){
      if(widget.post.post!.viewsCount != null){
        impressions = int.parse(widget.post.post!.viewsCount!);
      }
    }

    if(widget.post.likes != null){
      likes = widget.post.likes!;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "comment_page",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Post Activity",
              style: TextStyle(
                color: getAppColor(Color(0xff4F4F4F)),
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
                child: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black))
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Container(
                  color: Color(0xffEDEAEA),
                  height: 1.0,
                )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
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
                    ProductRealView(
                      post: widget.post,
                      showActions: false,
                      showBuyButton: false,
                    ),
                    SizedBox(height: 10,),
                    widgetAnalyticsWidget(
                        "Impressions",
                        "Times people saw this product on wayagram",
                        impressions.toString()
                    ),
                    SizedBox(height: 10,),
                    widgetAnalyticsWidget(
                        "Total engagements",
                        "Times people interacted with this product",
                        (likes + reposts + comments).toString()
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: AppButton(
                        title: 'Promote this Product',
                        onPressed: () async {
                          //https://services.staging.wayagram.ng/wayagram-service/all-posts/get-promotion-pricing-configs?page=1&limit=50&sso_id=639
                          var res = await  controller.getData("/wayagram-service/all-posts/get-promotion-pricing-configs?page=1&limit=50", true);
                          if(Get.currentRoute == "/ProductAnalytics"){
                            var savedPosts = ReadWriteValue('wayagram_promotion_pricing_model', '', MyPref.box);
                            if(res.isSuccessful || savedPosts.val.isNotEmpty){
                              List<PromotionPricingModel> promotionPricingModelList = [];
                              if(res.isSuccessful){
                                promotionPricingModelList = PromotionPricingModel.listFromJson(res.data['data']);
                                savedPosts.val = jsonEncode(res.data['data']);

                                if(promotionPricingModelList.isEmpty){
                                  AppOverlay.showErrorSnackBar(title : "Promotion Error",content: "No promotion plans available now, please check back later");
                                }else{
                                  Get.to(() => PromoteProduct(post: widget.post));
                                }
                              }else{
                                if(savedPosts.val.isEmpty){
                                  AppOverlay.showErrorSnackBar(title : "Promotion Error",content: "No promotion plans available now, please check back later");
                                }else{
                                  Get.to(() => PromoteProduct(post: widget.post));
                                }
                              }
                            }else{
                              AppOverlay.showErrorSnackBar(title : "Promotion Error",content: "Error getting promotion configuration");
                            }
                          }
                        },
                        borderRadius: 10,
                        fontColor: AppColors.primary,
                        bckgrndColor: getAppColor(AppColors.background),
                        width: double.infinity,
                        fontSize: Get.textScaleFactor * 18,
                        border: Border.all(color: AppColors.primary, width: 1),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Promote your product to reach more people and boost engagements",
                        style: TextStyle(
                          color: getAppColor(Colors.black).withOpacity(0.5),
                          fontSize: Get.textScaleFactor * 16,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40),
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
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: getAppColor(AppColors.background),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffEDEAEA), width: 1),
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
                      color: getAppColor(Colors.black),
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
                      color: getAppColor(Colors.black),
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
                  color: getAppColor(Color(0xff4F4F4F)),
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