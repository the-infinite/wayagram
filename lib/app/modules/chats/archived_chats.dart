import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/theme/app_styles.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/socket_models/chat_list_over_view.dart';
import '../../global_widgets/app_avatar.dart';
import 'chat_screen.dart';

class ArchivedChats extends StatelessWidget {
  const ArchivedChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ChatControllerWayagram>(id:'chats_overview',builder: (chatController) {
      List<ChatOverview> chatOverview = [];
      if(chatController.chatListOverView!=null){
        if(chatController.chatListOverView!.chatOverview!=null){
          //print('chatOverview: ${chatController.chatListOverView!.chatOverview!.length}');
          chatOverview = chatController.chatListOverView!.chatOverview!;
        }
      }
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: getAppColor(AppColors.background),
            statusBarIconBrightness: getAppBrightness(),
            statusBarBrightness: getAppBrightness(),
            systemNavigationBarColor: getAppColor(AppColors.background),
            systemNavigationBarIconBrightness: getAppBrightness()
        ),
        child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: getAppColor(AppColors.background),
              title: Text('Archive', style: AppTextStyle.subtitle1.copyWith(
                color: getAppColor(Color(0xff4F4F4F)),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              )),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black)),
                onPressed: () => Navigator.pop(context),
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: getAppColor(AppColors.background),
                  statusBarIconBrightness: getAppBrightness(),
                  statusBarBrightness: getAppBrightness(),
                  systemNavigationBarColor: getAppColor(AppColors.background),
                  systemNavigationBarIconBrightness: getAppBrightness()
              ),
            ),
            backgroundColor: getAppColor(AppColors.background),
            body: Container(
              color: getAppColor(AppColors.background),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(chatController.chatListOverView!=null)
                      ListView.builder(
                        itemCount: chatOverview.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var post = chatOverview[index];
                          var avater = "";
                          var name = "";
                          var time = "";
                          var lastMessage = "";
                          bool archived = false;
                          if(post.isGroup == true){
                            avater = post.group!.groupImageUrl.toString();
                            name = post.group!.groupName.toString();
                            //time = DateFormat.yMMMMEEEEd().format(DateTime.parse(post.group!.updatedAt.toString()));
                            //time = DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
                            time = timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
                            lastMessage = post.message.toString();
                          }else{
                            archived = post.senderArchived == true;
                            name = post.otherDisplayName.toString();
                            avater = post.otherImageURL.toString();
                            time = timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
                            lastMessage = post.message.toString();
                          }
                          if(!archived){
                            return const SizedBox.shrink();
                          }
                          return InkWell(
                            onTap: (){
                              Get.to(() => ChatScreen(chatOverview: post));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
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
                                      SizedBox(width: 10,),
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          if(post.isGroup == true)
                                            SizedBox(
                                              width: Get.width*0.8,
                                              child: HashTagText(text: name, decoratedStyle: TextStyle(
                                                color: Colors.blue,
                                                fontSize: Get.textScaleFactor * 17,
                                                fontWeight: FontWeight.w600,
                                              ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                color: getAppColor(Colors.black),
                                                fontSize: Get.textScaleFactor * 17,
                                                fontWeight: FontWeight.w600,),
                                                softWrap: true,
                                                onTap: (text) {

                                                },
                                                decorateAtSign: true,
                                                maxLines: 1,
                                              ),
                                            ),
                                          if(post.isGroup != true)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: Get.width*0.8,
                                                  child: HashTagText(text: name, decoratedStyle: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: Get.textScaleFactor * 17,
                                                    fontWeight: FontWeight.w600,
                                                  ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                    color: getAppColor(Colors.black),
                                                    fontSize: Get.textScaleFactor * 17,
                                                    fontWeight: FontWeight.w600,),
                                                    softWrap: true,
                                                    onTap: (text) {

                                                    },
                                                    decorateAtSign: true,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                if(lastMessage.isNotEmpty || lastMessage!="null")
                                                  Text(lastMessage, style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: Get.textScaleFactor * 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),),
                                              ],
                                            ),
                                          Text(time, style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Get.textScaleFactor * 15,
                                            fontWeight: FontWeight.w500,
                                          ),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Get.height*0.005),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });

  }
}