
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/products_model_entity.dart';
import '../../../data/providers/api.dart';
import '../../../global_widgets/app_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../../global_widgets/overlays.dart';
import '../../../global_widgets/video_player/reusable_video_list_controller.dart';
import '../../products/buy_product.dart';
import '../../report/report_product.dart';
import '../../view_posts/product_analytics.dart';

class ProductView extends StatelessWidget{
  const ProductView({
    Key? key,
    this.isLoading = false,
    this.posts,
    this.showBuyButton = true,
    this.showActions = true,
  }) : super(key: key);

  final bool isLoading;
  final bool showBuyButton;
  final bool showActions;
  final List<ProductsModelData>? posts;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerWayagram>(id: 'product_post',builder: (controller) {
      return ListView.builder(
        itemCount: isLoading ? 5 : posts!.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if(isLoading){
            return SizedBox(
              height: Get.height * 0.18,
              width: Get.width * 0.35,
              child: Shimmer.fromColors(
                baseColor: getAppColor(Colors.grey).withOpacity(0.8),
                highlightColor: getAppColor(Colors.grey).withOpacity(0.2),
                child: Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                  height: Get.height * 0.18,
                  width: Get.width * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: getAppColor(Colors.grey).withOpacity(.5),
                  ),
                ),
              ),
            );
          }
          var post = posts![index];
          return ProductRealView(
            post: post,
            showBuyButton: showBuyButton,
            showActions: showActions,
          );
        },
      );
    });
  }
}

class ProductRealView extends StatefulWidget{
  const ProductRealView({
    Key? key,
    this.isLoading = false,
    required this.post,
    this.showBuyButton = true,
    this.showActions = true,
  }) : super(key: key);

  final bool isLoading;
  final bool showBuyButton;
  final bool showActions;
  final ProductsModelData post;

  @override
  State<ProductRealView> createState() => _ProductRealViewState();
}

class _ProductRealViewState extends State<ProductRealView> {
  ReusableVideoListController videoListController = ReusableVideoListController();
  @override
  Widget build(BuildContext context) {
    if(widget.post.profile == null){
      return const SizedBox.shrink();
    }

    return GetBuilder<HomeControllerWayagram>(id: 'product_real_post',builder: (controller) {
      var time = DateTime.parse(widget.post.createdAt!);
      List<String> imageUrls = [];
      for (var element in widget.post.productImages!) {
        imageUrls.add(element.imageUrl.toString());
      }
      var isCurrentUserPost = controller.profile.id == widget.post.profile!.id;

      return Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
        decoration: BoxDecoration(
          color: getAppColor(Colors.white).withOpacity(.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: AppAvatar(
                      imgUrl: widget.post.profile == null ? "" : widget.post.profile!.avatar.toString(),
                      radius: 45,
                    ),
                    onPressed: null,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.profile!.displayName.toString(),
                      style: TextStyle(
                        color: getAppColor(Colors.black) ,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "@${widget.post.profile!.username}",
                      style: TextStyle(
                        color: getAppColor(Colors.grey),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        timeago.format(time),
                        style: TextStyle(
                          color: getAppColor(Colors.grey),
                          fontSize: Get.textScaleFactor * 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if(widget.showActions)
                        PopupMenuButton(
                            color: getAppColor(Colors.white),
                            icon: Icon(
                              FeatherIcons.moreHorizontal,
                              color: getAppColor(Colors.black),
                              size: 20,
                            ),
                            onSelected: (value) {
                              /*if (value == 0) {
                                  var body = {
                                    "postId": widget.post.id,
                                  };
                                  widget.homeController.postData(body, "/wayagram-service/all-posts/create-bookmark?profileId=${widget.fullProfile.id}",updatePages: false).then((value){
                                    if(value.isSuccessful){
                                      AppOverlay.showSuccessSnackBar(title: "Bookmark",content: "Post bookmarked successfully");
                                    }else{
                                      AppOverlay.showErrorSnackBar(title: "Bookmark",content: value.message != null ? value.message.toString() : "Something went wrong");
                                    }
                                  });
                                }
                                else if (value == 1) {
                                  Share.share('${Api.baseWebUrl}${widget.post.id}', subject: 'Wayagram Post');
                                }
                                else if (value == 2) {
                                  //Get.to(() => Followers());
                                }
                                else if (value == 3) {
                                  var body = {
                                    "post_id": widget.post.id,
                                  };
                                  widget.homeController.deleteData(body, "/wayagram-service/all-posts/delete?profile_id=${widget.fullProfile.id}",updatePages: true).then((value){
                                    if(value.isSuccessful){
                                      AppOverlay.showSuccessSnackBar(title: "Delete",content: "Post deleted successfully");
                                    }else{
                                      AppOverlay.showErrorSnackBar(title: "Delete",content: value.message != null ? value.message.toString() : "Something went wrong");
                                    }
                                  });
                                }
                                else if (value == 4) {
                                  Get.to(() => ReportPost(post: widget.post,isPost: true));
                                }*/
                              if (value == 1) {
                                Share.share('${Api.baseWebUrl}${widget.post.id}', subject: 'Wayagram Product');
                              }
                              else if(value == 3){
                                var body = {
                                  "profile_id": controller.profile.id,
                                  "product_id": widget.post.id
                                };
                                controller.deleteData(body, "/wayagram-service/all-posts/delete-product").then((value){
                                  if(value.isSuccessful){
                                    AppOverlay.showSuccessSnackBar(title: "Delete",content: "Product deleted successfully");
                                    controller.update(['product_post']);
                                  }else{
                                    AppOverlay.showErrorSnackBar(title: "Delete",content: value.message != null ? value.message.toString() : "Something went wrong");
                                  }
                                });
                              }
                              else if(value == 4){
                                Get.to(() => ReportProduct(post: widget.post,isPost: true));
                              }
                            },
                            itemBuilder: (context) => [
                              /*PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      Get.currentRoute == "/BookmarksPage" ? "Remove" : "Bookmark",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: getAppColor(Colors.black),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),*/
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Share",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              /*if(isCurrentUserPost)
                            PopupMenuItem(
                              value: 2,
                              child: Text(
                                "Edit",
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: getAppColor(Colors.black),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),*/
                              if(isCurrentUserPost)
                                PopupMenuItem(
                                  value: 3,
                                  child: Text(
                                    "Delete",
                                    style: AppTextStyle.bodyText1.copyWith(
                                      color: getAppColor(Colors.black),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              if(!isCurrentUserPost)
                                PopupMenuItem(
                                  value: 4,
                                  child: Text(
                                    "Report",
                                    style: AppTextStyle.bodyText1.copyWith(
                                      color: getAppColor(Colors.black),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ]),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if(imageUrls.isNotEmpty)
              SizedBox(
                height: Get.height * 0.18,
                child: NewsfeedMultipleImageView(
                  imageUrls: imageUrls,
                  marginLeft: 10.0,
                  marginRight: 10.0,
                  marginBottom: 0,
                  marginTop: 0,
                  videoListController: videoListController,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: Get.width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagText(
                            text: widget.post.name.toString(),
                            decoratedStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            basicStyle: TextStyle(
                              color: getAppColor(Colors.black),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            onTap: (text) {

                            },
                            decorateAtSign: true,
                          ),
                          HashTagText(
                            text: widget.post.description.toString(),
                            decoratedStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            basicStyle: TextStyle(
                              color: getAppColor(Colors.black),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            onTap: (text) {

                            },
                            decorateAtSign: true,
                          ),
                          Row(
                            children: [
                              //tag icon
                              const Icon(
                                FeatherIcons.tag,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "NGN ${widget.post.amount}",
                                style: TextStyle(
                                  color: getAppColor(Colors.black),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    if(widget.showBuyButton)
                      AppButton(
                        title: "Buy",
                        onPressed: (){
                          Get.to(() => BuyProduct(post: widget.post));
                        },
                        bckgrndColor: AppColors.primary,
                        fontColor: getAppColor(AppColors.background),
                        width: Get.width * 0.2,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    if(!widget.showBuyButton && widget.showActions)
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: isCurrentUserPost ? (){
                              Get.to(() => ProductAnalytics(post: widget.post));
                            } : null,
                            child: Icon(
                              Icons.bar_chart,
                              color: isCurrentUserPost ? getAppColor(Colors.grey) : getAppColor(Colors.white).withOpacity(0.8),
                              size: 24,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                  ],
                )
            ),
          ],
        ),
      );
    });
  }
}