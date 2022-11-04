import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/group_model_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../global_widgets/app_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/newsfeed_multiple_imageview.dart';

class GroupView extends StatelessWidget{
  const GroupView({
    Key? key,
    this.isLoading = false,
    this.posts,
    this.isGroup = true,
    this.isJoined = false,
  }) : super(key: key);

  final bool isLoading;
  final bool isGroup;
  final bool isJoined;
  final List<GroupModelEntity>? posts;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: isLoading ? 3 : posts!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if(isLoading){
          return SizedBox(
            height: Get.height * 0.08,
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
        return Container(
          margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                  icon: AppAvatar(
                    imgUrl: post.imageUrl.toString(),
                    radius: 50,
                  ),
                  onPressed: null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.name.toString(),
                    style: const TextStyle(
                      color: Colors.black ,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: Get.width*0.7,
                    child: Text(
                      post.description.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if(!isJoined)
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: [
                      SizedBox(
                        width: Get.width*0.2,
                        child: AppButton(
                          title: isGroup ? 'Join' : 'Follow',
                          onPressed: () async {

                          },
                          borderRadius: 5,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          bckgrndColor: AppColors.background,
                          fontColor: AppColors.primary,
                          border: Border.all(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

}