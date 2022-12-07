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
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/CommentModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
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

class ViewPost extends StatefulWidget {
  const ViewPost({Key? key,required this.post}) : super(key: key);

  final AllPostsEntity post;

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  FocusNode inputNode = FocusNode();
  var commentController = TextEditingController();
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

    //print(post.id);
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
              "Post",
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
                      //hasBorder: false,
                    ),
                    FutureBuilder<ApiResponse>(
                        future: controller.getData("/wayagram-service/all-posts/post-comments?post_id=${widget.post.id}&page=1&limit=10", true),
                        builder: (context, snapshot) {
                          var savedPosts = ReadWriteValue('wayagram_comment_${widget.post.id}', '', MyPref.box);
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                            final posts = CommentModel.listFromJson(snapshot.data!.data['data']);
                            savedPosts.val = jsonEncode(posts);
                            return CommentPostsView(
                              posts: posts,
                              onReplyClick: (id, username) async {
                                if(parentID.isEmpty || usernameToReplyTo == username){
                                  parentID = id;
                                  usernameToReplyTo = username;
                                  controller.update(["comment_page"]);
                                }else{
                                  parentID = "";
                                  usernameToReplyTo = "";
                                  controller.update(["comment_page"]);
                                  await Future.delayed(const Duration(milliseconds: 300));
                                  parentID = id;
                                  usernameToReplyTo = username;
                                  controller.update(["comment_page"]);
                                }
                                //openKeyboard();
                              },
                            );
                          } else if(savedPosts.val.isNotEmpty){
                            var posts = CommentModel.listFromJson(jsonDecode(savedPosts.val));
                            return CommentPostsView(
                              posts: posts,
                              onReplyClick: (id, username) async {
                                if(parentID.isEmpty || usernameToReplyTo == username){
                                  parentID = id;
                                  usernameToReplyTo = username;
                                  controller.update(["comment_page"]);
                                }else{
                                  parentID = "";
                                  usernameToReplyTo = "";
                                  controller.update(["comment_page"]);
                                  await Future.delayed(const Duration(milliseconds: 300));
                                  parentID = id;
                                  usernameToReplyTo = username;
                                  controller.update(["comment_page"]);
                                }
                              },
                            );
                          }else{
                            if(snapshot.connectionState == ConnectionState.done){
                              return const SizedBox.shrink();
                            }
                            return const CommentPostsView(isLoading: true);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: const Color(0xffEDEAEA),
                  height: 1.0,
                ),
                SizedBox(height: Get.height*0.008),
                AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    child: usernameToReplyTo.isEmpty ? const SizedBox.shrink() : Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width*0.035),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width*0.8,
                            child: HashTagText(
                              text: "Replying to @$usernameToReplyTo",
                              basicStyle: AppTextStyle.bodyText1.copyWith(
                                color: Colors.black,
                                fontSize: Get.textScaleFactor * 16,
                                fontWeight: FontWeight.normal,
                              ),
                              decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                color: Colors.blue,
                                fontSize: Get.textScaleFactor * 16,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              decorateAtSign: true,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: (){
                              parentID = "";
                              usernameToReplyTo = "";
                              controller.update(["comment_page"]);
                            },
                            child: const Icon(Icons.cancel_rounded, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                ),
                if(usernameToReplyTo.isNotEmpty)
                  SizedBox(height: Get.height*0.008),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: Get.width*0.02),
                      child: SizedBox(
                        width: Get.width * 0.8,
                        child: AppInput(
                          hintText: 'Write a message...',
                          controller: commentController,
                          borderRadius: 100,
                          filledColor: Colors.grey.shade300,
                          borderSide: BorderSide.none,
                          hintColor: Colors.grey.shade500,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          focusNode: inputNode,
                        ),
                      ),
                    ),
                    AppButton(
                      title: 'Send',
                      onPressed: () async {
                        if(commentController.text.isNotEmpty){
                          var data = {
                            "post_id": widget.post.id,
                            "comment": commentController.text,
                            "profile_id": fullProfile.id,
                            "type": "user"
                          };
                          if(parentID.isNotEmpty){
                            data["parent_id"] = parentID;
                          }
                          var response = await controller.postData(data,"/wayagram-service/all-posts/comment-create");
                          if(response.isSuccessful){
                            widget.post.commentCount = (int.parse(widget.post.commentCount.toString()) + 1).toString();
                            commentController.clear();
                            if(parentID.isNotEmpty){
                              controller.getCommentID = parentID;
                              parentID = "";
                              usernameToReplyTo = "";
                            }
                            controller.update(["comment_page"]);
                            controller.getPosts.then((value) {
                              controller.update(["home_tab"]);
                            });
                            closeKeyboard();
                          }else{
                            AppOverlay.showErrorSnackBar(title: "Error", content: "Unable to comment, please try again later");
                          }
                        }
                      },
                      borderRadius: 10,
                      fontColor: AppColors.button,
                      bckgrndColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      width: Get.width * 0.15,
                      fontSize: Get.textScaleFactor * 18,
                    )
                  ],
                ),
                SizedBox(height: Get.height*0.008)
              ],
            ),
          ),
        );
      }),
    );
  }
}