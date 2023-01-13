import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/group_model_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../groups_and_pages/group.dart';
import '../../groups_and_pages/page.dart';

class GroupView extends StatefulWidget{
  GroupView({
    Key? key,
    this.isLoading = false,
    this.posts,
    this.isGroup = true,
    this.isJoined = false, this.onButtonClick, this.minimum = -1,
  }) : super(key: key);

  final bool isLoading;
  final bool isGroup;
  final bool isJoined;
  final int minimum;
  final List<GroupModelEntity>? posts;
  final Function(GroupModelEntity info)? onButtonClick;

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  @override
  Widget build(BuildContext context) {
    int count = widget.posts == null ? 0 : widget.posts!.length;
    if(widget.minimum > -1){
      if(count > widget.minimum){
        count = widget.minimum;
      }
    }
    var savedPosts = ReadWriteValue('wayagram_joined_groups', '', MyPref.box);
    var savedPostsPages = MyPref.pagesFollowed.val;

    List<GroupModelEntity> postsGroups = [];
    if(savedPosts.val.isNotEmpty){
      postsGroups = GroupModelEntity.getService(jsonDecode(savedPosts.val));
    }
    List<GroupModelEntity> postsPages = [];
    if(savedPostsPages.isNotEmpty){
      postsPages = GroupModelEntity.getService(jsonDecode(savedPostsPages));
    }

    return ListView.builder(
      itemCount: widget.isLoading ? 3 : count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if(widget.isLoading){
          return SizedBox(
            height: Get.height * 0.08,
            width: Get.width * 0.35,
            child: Shimmer.fromColors(
              baseColor: getAppColor(Colors.grey).withOpacity(0.8),
              highlightColor: getAppColor(Colors.grey).withOpacity(0.2),
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
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
        var post = widget.posts![index];
        var isJoined1 = postsGroups.any((element) => element.id == post.id);
        if(!widget.isGroup){
          isJoined1 = false;
          isJoined1 = postsPages.any((element) => element.id == post.id);
        }
        return InkWell(
          onTap: (){
            if(widget.isGroup) {
              Get.to(() => Group(group: post,key: ValueKey(post.id),joined: widget.isJoined));
            }else{
              Get.to(() => PageScreen(page: post,key: ValueKey(post.id)));
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
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
                      isGroup: widget.isGroup,
                      isPage: !widget.isGroup,
                    ),
                    onPressed: null,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.name.toString(),
                      style: TextStyle(
                        color: getAppColor(Colors.black) ,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: Get.width*0.5,
                      child: Text(
                        post.description.toString(),
                        style: TextStyle(
                          color: getAppColor(Colors.grey),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if(!widget.isJoined && !isJoined1)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          title: widget.isGroup ? 'Join' : 'Follow',
                          onPressed: () async {
                            if(widget.onButtonClick != null){
                              await widget.onButtonClick!(post);
                              setState(() {

                              });
                            }
                          },
                          borderRadius: 5,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          bckgrndColor: getAppColor(AppColors.background),
                          fontColor: AppColors.primary,
                          border: Border.all(color: AppColors.primary),
                          fontSize: Get.width*0.04,
                          width: Get.width*0.25,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}