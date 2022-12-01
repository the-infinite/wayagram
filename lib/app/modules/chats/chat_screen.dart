import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/app/global_widgets/app_input.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/SearchHashtagsModel.dart';
import '../../data/model/SearhPeopleModel.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../data/socket_models/chat_list_over_view.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;
import 'dart:math' as math;


import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/person_view.dart';
import '../home/widgets/HashTagView.dart';
import '../home/widgets/group_view.dart';

import '../home/widgets/posts_view.dart' as post_view;

import 'package:timeago/timeago.dart' as timeago;


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chatOverview}) : super(key: key);

  final ChatOverview chatOverview;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FocusNode inputNode = FocusNode();
  var chatTextController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

  void openKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(inputNode);
  }

  void closeKeyboard(BuildContext context){
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.chatOverview;
    var avater = "";
    var name = "";
    var time = "";
    var lastMessage = "";
    var membersString = "";
    if(post.isGroup == true){
      avater = post.group!.groupImageUrl.toString();
      name = post.group!.groupName.toString();
      time = timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
      lastMessage = post.message.toString();
      if(post.members != null){
        for(int i = 0; i < post.members!.length; i++){
          if(i == 0){
            membersString = post.members![i].name.toString();
          }else{
            membersString = "$membersString, ${post.members![i].name}";
          }
        }
      }
    }else{
      name = post.otherDisplayName.toString();
      avater = post.otherImageURL.toString();
      time = timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
      lastMessage = post.message.toString();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<ChatController>(id:'chats_screen',builder: (chatController) {
        return  GetBuilder<HomeController>(builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.background,
              title: InkWell(
                onTap: (){

                },
                child: Column(
                  children: [
                    SizedBox(height: Get.height*0.005),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: Get.height*0.04,
                          width: Get.height*0.04,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: AppAvatar(
                            imgUrl: avater,
                            isGroup: post.isGroup == true,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            if(post.isGroup == true)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Get.width*0.4,
                                    child: HashTagText(text: name, decoratedStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: Get.textScaleFactor * 17,
                                      fontWeight: FontWeight.w600,
                                    ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                      color: Colors.black,
                                      fontSize: Get.textScaleFactor * 17,
                                      fontWeight: FontWeight.w600,),
                                      softWrap: true,
                                      onTap: (text) {

                                      },
                                      decorateAtSign: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                    SizedBox(
                                      width: Get.width*0.4,
                                      child: Text(membersString, style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: Get.textScaleFactor * 15,
                                        fontWeight: FontWeight.w500,
                                      ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                    ),
                                ],
                              ),
                            if(post.isGroup != true)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Get.width*0.4,
                                    child: HashTagText(text: name, decoratedStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: Get.textScaleFactor * 17,
                                      fontWeight: FontWeight.w600,
                                    ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                      color: Colors.black,
                                      fontSize: Get.textScaleFactor * 17,
                                      fontWeight: FontWeight.w600,),
                                      softWrap: true,
                                      onTap: (text) {

                                      },
                                      decorateAtSign: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text("Offline", style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: Get.textScaleFactor * 15,
                                      fontWeight: FontWeight.w500,
                                  ),),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height*0.005),
                  ],
                ),
              ),
              leading: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  FeatherIcons.arrowLeft,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
                iconSize: Get.width * 0.06,
              ),
              actions: [
                Row(
                  children: [
                    IconButton(onPressed: (){}, icon: const Icon(Icons.videocam_rounded, color: Colors.black,size: 24)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.call_rounded, color: Colors.black,size: 20,)),
                    IconButton(onPressed: (){}, icon: const Icon(FeatherIcons.moreVertical, color: Colors.black,size: 20)),
                  ],
                )
              ],
              centerTitle: false,
              titleSpacing: 0,
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
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.01, vertical: Get.height*0.01),
                child: Column(
                  children: [

                  ],
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
                            controller: chatTextController,
                            borderRadius: 100,
                            filledColor: Colors.grey.shade300,
                            borderSide: BorderSide.none,
                            hintColor: Colors.grey.shade500,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            focusNode: inputNode,
                            suffixIcon: IconButton(
                              onPressed: () {

                              },
                              icon: Transform.rotate(
                                angle: 45 * math.pi / 180,
                                child: const Icon(
                                  Icons.attach_file_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              chatController.update(['chats_screen']);
                            },
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: Get.width*0.02),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            onPressed: () {

                            },
                            icon: Icon(
                              chatTextController.text.isEmpty
                                  ? Icons.mic_rounded
                                  : Icons.send_rounded,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: Get.height*0.008),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}