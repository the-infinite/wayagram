import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_list/chat_list.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:wayagram/app/global_widgets/app_input.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';
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
import '../../data/socket_models/previous_chat_model.dart' as normal_chat;
import '../../data/socket_models/send_message_response.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';
import 'package:http_parser/http_parser.dart' as http_parser;

import 'package:dio/dio.dart' as dio;
import 'dart:math' as math;


import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/person_view.dart';
import '../../global_widgets/smart_image.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../home/widgets/HashTagView.dart';
import '../home/widgets/group_view.dart';

import '../home/widgets/posts_view.dart' as post_view;

import 'package:timeago/timeago.dart' as timeago;

import '../search/search.dart';
import '../send_money/send_money.dart';

class ChatProfile extends StatefulWidget {
  ChatProfile({Key? key, required this.chatOverview}) : super(key: key);

  final ChatOverview chatOverview;
  @override
  State<ChatProfile> createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  var chatController = Get.find<ChatControllerWayagram>();
  bool canScrollDown = true;
  final ScrollController _scrollController = ScrollController();

  normal_chat.PreviousChatModel? previousChatModel;
  List<normal_chat.PreviousChat> previousChat = [];

  FocusNode inputNode = FocusNode();
  var chatTextController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void openKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(inputNode);
  }

  void closeKeyboard(BuildContext context){
    FocusScope.of(context).unfocus();
  }

  void _scrollDown({bool animate = true}) {
    if (_scrollController.hasClients && canScrollDown){
      if(animate){
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
      }else{
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.chatOverview;
    var id = "";
    var avatar = "";
    var name = "";
    var time = "";
    var lastMessage = "";
    var membersString = "";
    if(post.isGroup == true){
      avatar = post.group!.groupImageUrl.toString();
      name = post.group!.groupName.toString();
      time = timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
      lastMessage = post.message.toString();
      id = post.group!.id.toString();
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
      avatar = post.otherImageURL.toString();
      time = timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
      lastMessage = post.message.toString();
      id = post.otherId.toString();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<ChatControllerWayagram>(id:'chats_screen',builder: (chatController) {
        var chatNormalInfo = {"otherId": id};
        var chatGroupInfo = {"groupId":id};
        if(mounted){
          if(post.isGroup == true){

          }else{

          }
        }
        return  GetBuilder<HomeControllerWayagram>(builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: getAppColor(AppColors.background),
              leading: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  FeatherIcons.arrowLeft,
                  color: getAppColor(AppColors.onBackground),
                ),
                onPressed: () {
                  Get.back();
                },
                iconSize: Get.width * 0.06,
              ),
              centerTitle: false,
              titleSpacing: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: getAppColor(AppColors.background),
                  statusBarIconBrightness: getAppBrightness(),
                  statusBarBrightness: getAppBrightness(),
                  systemNavigationBarColor: getAppColor(AppColors.background),
                  systemNavigationBarIconBrightness: getAppBrightness()
              ),
            ),
            body: SizedBox(
              width: Get.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.01, vertical: 0),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: Get.height*0.1,
                      width: Get.height*0.1,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(180),
                      ),
                      child: AppAvatar(
                        imgUrl: avatar,
                        isGroup: post.isGroup == true,
                      ),
                    ),
                    if(post.isGroup == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HashTagText(text: name, decoratedStyle: TextStyle(
                            color: getAppColor(AppColors.background),
                            fontSize: Get.textScaleFactor * 17,
                            fontWeight: FontWeight.w600,
                          ),basicStyle: AppTextStyle.bodyText1.copyWith(
                            color: getAppColor(AppColors.background),
                            fontSize: Get.textScaleFactor * 17,
                            fontWeight: FontWeight.w600,),
                            softWrap: true,
                            onTap: (text) {

                            },
                            decorateAtSign: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: Get.width*0.8,
                            child: Text(membersString, style: TextStyle(
                              color: getAppColor(Colors.grey),
                              fontSize: Get.textScaleFactor * 15,
                              fontWeight: FontWeight.w500,
                            ),overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    if(post.isGroup != true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HashTagText(text: name, decoratedStyle: TextStyle(
                            color: getAppColor(AppColors.background),
                            fontSize: Get.textScaleFactor * 17,
                            fontWeight: FontWeight.w600,
                          ),basicStyle: AppTextStyle.bodyText1.copyWith(
                            color: getAppColor(AppColors.background),
                            fontSize: Get.textScaleFactor * 17,
                            fontWeight: FontWeight.w600,),
                            softWrap: true,
                            onTap: (text) {

                            },
                            decorateAtSign: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text("Offline", style: TextStyle(
                            color: getAppColor(Colors.grey),
                            fontSize: Get.textScaleFactor * 15,
                            fontWeight: FontWeight.w500,
                          ),),
                        ],
                      ),
                    SizedBox(height: Get.height*0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(onPressed: (){
                              comingSoon();
                            }, icon: Icon(Icons.videocam_rounded, color: AppColors.primary,size: 24)),
                            Text("Video", style: TextStyle(
                              color: AppColors.primary,
                              fontSize: Get.textScaleFactor * 15,
                              fontWeight: FontWeight.w500,
                            ),textAlign: TextAlign.center,),
                          ],
                        ),
                        SizedBox(width: Get.width*0.1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(onPressed: (){
                              comingSoon();
                            }, icon: Icon(Icons.call_rounded, color: AppColors.primary,size: 20,)),
                            Text("Call", style: TextStyle(
                              color: AppColors.primary,
                              fontSize: Get.textScaleFactor * 15,
                              fontWeight: FontWeight.w500,
                            ),textAlign: TextAlign.center,),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height*0.01),
                    Container(
                      color: Color(0xffEDEAEA),
                      height: 1.0,
                    ),
                    if(post.isGroup == true)
                      SizedBox(height: Get.height*0.01),

                    if(post.isGroup == true)
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: Get.height*0.36,
                        ),
                        child: ListView.builder(
                          itemCount: post.members!.length,
                            shrinkWrap: true,
                            itemBuilder: (context,index){
                              var member = post.members![index];
                              return PersonProfileAction(
                                title: member.name.toString(),
                                subtitle: member.isAdmin == true ? "Admin" : "Member",
                                url: member.imageUrl.toString(),
                                onTap: (){

                            },
                          );
                            }
                        ),
                      ),

                    if(post.isGroup == true)
                      SizedBox(height: Get.height*0.01),
                    if(post.isGroup == true)
                      Container(
                      color: Color(0xffEDEAEA),
                      height: 1.0,
                    ),
                    SizedBox(height: Get.height*0.01),
                    if(post.isGroup == true)
                      ChatProfileAction(
                        title: "Invite To Group",
                        icon: Icons.person_add_alt_1_rounded,
                        onTap: (){

                        },
                      ),
                    if(post.isGroup != true)
                      ChatProfileAction(
                      title: "Send Money",
                      icon: Icons.money_rounded,
                      onTap: (){
                        var id = "";
                        if(post.senderUserId == fullProfile.userId){
                          id = post.receiverUserId;
                        }else{
                          id = post.senderUserId;
                        }
                        Get.to(() => SendMoney(
                          userIDToSendTo: id,
                          userDisplayName: name,
                          post: post,
                        ));
                      },
                    ),
                    ChatProfileAction(
                      title: "Clear Chat",
                      icon: Icons.delete_rounded,
                      onTap: (){

                      },
                    ),
                    ChatProfileAction(
                      title: "Archive Chat",
                      icon: Icons.archive_rounded,
                      onTap: (){

                      },
                    ),
                    if(post.isGroup != true)
                      ChatProfileAction(
                      title: "Block Contact",
                      icon: Icons.block_rounded,
                      bgColor: AppColors.bostonUniRed,
                      textColor: AppColors.bostonUniRed,
                      onTap: (){

                      },
                    ),
                    if(post.isGroup == true)
                      ChatProfileAction(
                        title: "Exit Group",
                        icon: Icons.exit_to_app_rounded,
                        bgColor: AppColors.bostonUniRed,
                        textColor: AppColors.bostonUniRed,
                        onTap: (){

                        },
                      )
                  ],
                ),
              ),
            ),
          );
        });
      }),
    );
  }

  void comingSoon() {
    String failed = "assets/images/failed.svg";
    showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return SizedBox(
                  height: height * 0.15,
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageHelper.svgImage(
                        failed,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Coming soon')
                    ],
                  ));
            },
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ChatProfileAction extends StatelessWidget {
  ChatProfileAction({
    Key? key, required this.title, required this.onTap, required this.icon,this.textColor,this.bgColor = AppColors.primary,this.iconColor = Colors.white
  }) : super(key: key);

  final String title;
  final Function() onTap;
  final IconData icon;
  final Color? textColor;
  final Color bgColor;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
        child: Row(
          children: [
            Container(
              height: Get.height*0.04,
              width: Get.height*0.04,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(icon, color: Colors.white, size: Get.height*0.02,),
            ),
            SizedBox(width: 10,),
            Text(title, style: TextStyle(
              color: textColor??getAppColor(Colors.black),
              fontSize: Get.textScaleFactor * 17,
              fontWeight: FontWeight.w500,
            ),),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class PersonProfileAction extends StatelessWidget {
  PersonProfileAction({
    Key? key, required this.title, required this.onTap, required this.url,this.textColor,this.bgColor = AppColors.primary,this.iconColor = Colors.white, required this.subtitle
  }) : super(key: key);

  final String title;
  final String url;
  final String subtitle;
  final Function() onTap;
  final Color? textColor;
  final Color bgColor;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
        child: Row(
          children: [
            Container(
              height: Get.height*0.04,
              width: Get.height*0.04,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: AppAvatar(
                imgUrl: url,
                isGroup: false,
              ),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  color: textColor ?? getAppColor(Colors.black),
                  fontSize: Get.textScaleFactor * 17,
                  fontWeight: FontWeight.w500,
                ),),
                Text(subtitle, style: TextStyle(
                  color: getAppColor(Colors.grey),
                  fontSize: Get.textScaleFactor * 12,
                  fontWeight: FontWeight.w500,
                ),),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}