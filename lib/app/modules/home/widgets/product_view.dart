import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../controllers/home_controller.dart';
import '../../../data/model/all_events_entity.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/model/products_model_entity.dart';
import '../../../global_widgets/app_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/newsfeed_multiple_imageview.dart';

class ProductView extends StatelessWidget{
  const ProductView({
    Key? key,
    this.isLoading = false,
    this.posts,
  }) : super(key: key);

  final bool isLoading;
  final List<ProductsModelData>? posts;
  @override
  Widget build(BuildContext context) {
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
              baseColor: Colors.grey.withOpacity(0.8),
              highlightColor: Colors.grey.withOpacity(0.2),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                height: Get.height * 0.18,
                width: Get.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.5),
                ),
              ),
            ),
          );
        }
        var post = posts![index];
        var time = DateTime.parse(post.createdAt!);
        List<String> imageUrls = [];
        for (var element in post.productImages!) {
          imageUrls.add(element.imageUrl.toString());
        }
        return Container(
          margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: AppAvatar(
                        imgUrl: post.profile!.avatar.toString(),
                        radius: 45,
                      ),
                      onPressed: null,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.profile!.displayName.toString(),
                        style: const TextStyle(
                          color: Colors.black ,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "@${post.profile!.username}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        Text(
                          timeago.format(time),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          FeatherIcons.moreVertical,
                          color: Colors.black,
                          size: 20,
                        ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagText(
                            text: post.name.toString(),
                            decoratedStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            basicStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            onTap: (text) {

                            },
                            decorateAtSign: true,
                          ),
                          HashTagText(
                            text: post.description.toString(),
                            decoratedStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            basicStyle: const TextStyle(
                              color: Colors.black,
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
                                post.amount.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      AppButton(
                        title: "Buy",
                        onPressed: (){},
                        bckgrndColor: AppColors.background,
                        fontColor: AppColors.primary,
                      ),
                    ],
                  )
              ),
            ],
          ),
        );
      },
    );
  }

}