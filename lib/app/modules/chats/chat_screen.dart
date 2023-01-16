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
import 'package:wayagram/app/modules/chats/chat_profile.dart';
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
import '../../data/socket_models/previous_chat_model.dart';
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
import '../home/widgets/bottom_sheet.dart';
import '../home/widgets/group_view.dart';

import '../home/widgets/posts_view.dart' as post_view;

import 'package:timeago/timeago.dart' as timeago;

import '../search/search.dart';
import '../send_money/send_money.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.chatOverview}) : super(key: key);

  final ChatOverview chatOverview;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  PreviousChat? chatToReply;

  var chatController = Get.find<ChatControllerWayagram>();
  bool canScrollDown = true;
  final ScrollController _scrollController = ScrollController();

  normal_chat.PreviousChatModel? previousChatModel;
  List<normal_chat.PreviousChat> previousChat = [];
  List<String> selectedMessages = [];

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
   // var time = "";
   // var lastMessage = "";
    var membersString = "";
    var username = "";
    if(post.isGroup == true){
      avatar = post.group!.groupImageUrl.toString();
      name = post.group!.groupName.toString();
     // time = timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
     // lastMessage = post.message.toString();
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
      username = post.otherUserName.toString();
      //time = timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(post.time.toString())));
      //lastMessage = post.message.toString();
      id = post.otherId.toString();
    }

    var chatNormalInfo = {"otherId": id};
    var chatGroupInfo = {"groupId":id};

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<ChatControllerWayagram>(id:'chats_screen',builder: (chatController) {
        if(mounted){
          if(post.isGroup == true){
            chatController.listenToCustomEvent('load_previous_group_chats',(chatData){
              chatController.userRepo.api.emitEvent('chat_overview', {});
              previousChatModel = normal_chat.PreviousChatModel.fromJson(chatData);
              if(previousChatModel!.previousChat != null){
                if(previousChat.isNotEmpty){
                  previousChat.clear();
                  previousChat.addAll(previousChatModel!.previousChat!);
                  previousChat.sort((a,b) {
                    return int.parse(b.time.toString()).compareTo(int.parse(a.time.toString()));
                  });
                  chatController.update(['chats_screen']);
                  _scrollDown();
                }else{
                  previousChat.addAll(previousChatModel!.previousChat!);
                  previousChat.sort((a,b) {
                    return int.parse(b.time.toString()).compareTo(int.parse(a.time.toString()));
                  });
                  chatController.update(['chats_screen']);
                  _scrollDown(animate: false);
                }
              }
              chatController.stopListeningToEvent("load_previous_group_chats");
            });
            chatController.emitMessages('previous_group_chats', chatGroupInfo,encode: false);
            /*chatController.listenToCustomEvent("new_message", (p0){
              chatController.listenToCustomEvent('load_previous_group_chats',(chatData){
                chatController.userRepo.api.emitEvent('chat_overview', {});
                previousChatModel = normal_chat.PreviousChatModel.fromJson(chatData);
                if(previousChatModel!.previousChat != null){
                  if(previousChat.isNotEmpty){
                    previousChat.clear();
                    previousChat.addAll(previousChatModel!.previousChat!);
                    previousChat.sort((a,b) {
                      return int.parse(b.time.toString()).compareTo(int.parse(a.time.toString()));
                    });
                    chatController.update(['chats_screen']);
                    _scrollDown();
                  }else{
                    previousChat.addAll(previousChatModel!.previousChat!);
                    previousChat.sort((a,b) {
                      return int.parse(b.time.toString()).compareTo(int.parse(a.time.toString()));
                    });
                    chatController.update(['chats_screen']);
                    _scrollDown(animate: false);
                  }
                }
                chatController.stopListeningToEvent("load_previous_group_chats");
              });
              chatController.emitMessages('previous_group_chats', chatGroupInfo,encode: false);
            });*/
          }else{
            chatController.listenToCustomEvent('load_previous_chats',(chatData){
              chatController.userRepo.api.emitEvent('chat_overview', {});
              previousChatModel = normal_chat.PreviousChatModel.fromJson(chatData);
              if(previousChatModel!.previousChat != null){
                if(previousChat.isNotEmpty){
                  previousChat.clear();
                  previousChat.addAll(previousChatModel!.previousChat!);
                  previousChat.sort((a,b) {
                    return int.parse(b.time.toString()).compareTo(int.parse(a.time.toString()));
                  });
                  chatController.update(['chats_screen']);
                  _scrollDown();
                }else{
                  previousChat.addAll(previousChatModel!.previousChat!);
                  previousChat.sort((a,b) {
                    return int.parse(b.time.toString()).compareTo(int.parse(a.time.toString()));
                  });
                  chatController.update(['chats_screen']);
                  _scrollDown(animate: false);
                }
              }
              chatController.stopListeningToEvent("load_previous_chats");
            });
            chatController.emitMessages('previous_chats', chatNormalInfo);
          }
        }
        //callMessage
        //fileMessage
        return  GetBuilder<HomeControllerWayagram>(builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: getAppColor(AppColors.background),
              title: InkWell(
                onTap: (){
                  Get.to(() => ChatProfile(chatOverview: widget.chatOverview));
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
                            imgUrl: avatar,
                            isGroup: post.isGroup == true,
                          ),
                        ),
                        SizedBox(width: 10,),
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
                                      color: getAppColor(Colors.black),
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
                                      color: getAppColor(AppColors.onBackground),
                                      fontSize: Get.textScaleFactor * 17,
                                      fontWeight: FontWeight.w600,
                                    ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                      color: getAppColor(AppColors.onBackground),
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
                                  Text(chatController.userOnline.contains(username) ? "Online" : "Offline", style: TextStyle(
                                      color: chatController.userOnline.contains(username) ? AppColors.primary : Colors.grey,
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
                icon: Icon(
                  FeatherIcons.arrowLeft,
                  color: getAppColor(Colors.black),
                ),
                onPressed: () {
                  Get.back();
                },
                iconSize: Get.width * 0.06,
              ),
              actions: [
                Row(
                  children: [
                    IconButton(onPressed: (){
                      comingSoon();
                    }, icon: Icon(Icons.videocam_rounded, color: getAppColor(Colors.black),size: 24)),
                    IconButton(onPressed: (){
                      comingSoon();
                    }, icon: Icon(Icons.call_rounded, color: getAppColor(Colors.black),size: 20,)),
                    PopupMenuButton(
                      color: getAppColor(Colors.white),
                      icon: Icon(Icons.more_vert,color: getAppColor(Colors.black)),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          child: Text(
                            post.isGroup == true ? "Invite To Group" : "Send Money",
                            style: AppTextStyle.bodyText1.copyWith(
                              color: getAppColor(Colors.black),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            "Clear Chat",
                            style: AppTextStyle.bodyText1.copyWith(
                              color: getAppColor(Colors.black),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if(value==0){
                          if(post.isGroup == true){

                          }else{
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
                          }
                        }
                        else if(value == 1){
                          chatController.clearChat(id);
                          AppOverlay.showSuccessSnackBar(content: "Chat Cleared Successfully");
                        }
                      },
                    ),
                  ],
                )
              ],
              centerTitle: false,
              titleSpacing: 0,
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
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: getAppColor(Colors.grey.shade200),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.01, vertical: 0),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      canScrollDown = true;
                    }else if(scrollInfo.metrics.pixels < scrollInfo.metrics.maxScrollExtent){
                      canScrollDown = false;
                    }
                    chatController.update(['chats_screen']);
                    return false;
                  },
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            if(previousChatModel != null && post.isGroup != true)
                              ListView.builder(
                                itemCount: previousChat.length,
                                shrinkWrap: true,
                                reverse: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var chat = previousChat[index];
                                  PreviousChat? repliedChat;
                                  bool isRepliedFile = false;
                                  if(chat.replyMessageId != null){
                                    repliedChat = previousChat.firstWhere((element) => element.id == chat.replyMessageId);
                                  }
                                  bool isFile = chat.messageType == "fileMessage";
                                  if(chat.senderId == fullProfile.id){
                                    if(chat.deleted == true){
                                      return Container();
                                    }
                                    if(chat.deletedForSender == true){
                                      return Container();
                                    }
                                  }
                                  EdgeInsetsGeometry padding = EdgeInsets.only(
                                    top: Get.height * 0.01,
                                    bottom: Get.height * 0.01,
                                    left: 10,
                                    right: 10,
                                  );
                                  if(getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile){
                                    padding= EdgeInsets.only(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        top: 0);
                                  }
                                  else if((getUrlType(chat.fileUrl.toString()) == UrlType.VIDEO || getUrlType(chat.fileUrl.toString()) == UrlType.IMAGE) && isFile){
                                    padding= EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        bottom: 5,
                                        top: 5
                                    );
                                  }
                                  else if(isFile){
                                    padding= EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 10
                                    );
                                  }

                                  EdgeInsetsGeometry repliedPadding = EdgeInsets.only(
                                    top: Get.height * 0.01,
                                    bottom: Get.height * 0.01,
                                    left: 10,
                                    right: 10,
                                  );
                                  if(repliedChat != null){
                                    isRepliedFile = repliedChat.messageType == "fileMessage";
                                    if(getUrlType(repliedChat.fileUrl.toString()) == UrlType.AUDIO && isRepliedFile){
                                      repliedPadding= const EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0);
                                    }
                                    else if((getUrlType(repliedChat.fileUrl.toString()) == UrlType.VIDEO || getUrlType(repliedChat.fileUrl.toString()) == UrlType.IMAGE) && isRepliedFile){
                                      repliedPadding= const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          bottom: 5,
                                          top: 5
                                      );
                                    }
                                    else if(isRepliedFile){
                                      repliedPadding= const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 10
                                      );
                                    }
                                  }

                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                    child: Column(
                                      crossAxisAlignment: chat.senderId == fullProfile.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: Get.height*0.005),
                                        if(chat.forwardMessage == true)
                                          Row(
                                          mainAxisAlignment: chat.senderId == fullProfile.id ? MainAxisAlignment.end : MainAxisAlignment.start,
                                          children: [
                                            Icon(FeatherIcons.cornerUpRight, color: getAppColor(Colors.grey), size: 15,),
                                            HashTagText(
                                              text: "Forwarded",
                                              decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                                color: getAppColor(Colors.grey),
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              basicStyle: AppTextStyle.bodyText1.copyWith(
                                                color: getAppColor(Colors.grey),
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              decorateAtSign: false,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: isFile ? Get.width*0.65 :Get.width*0.55,
                                          decoration: chat.senderId == fullProfile.id ? const BoxDecoration(
                                            color: AppColors.button,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(0),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          ) : BoxDecoration(
                                            color: getAppColor(AppColors.background),
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          ),
                                          child: Padding(
                                              padding: padding,
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  SizedBox(
                                                    width: isFile ? Get.width*0.65 :Get.width*0.55,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        if(repliedChat!=null)
                                                          Container(
                                                            padding: repliedPadding,
                                                            width: double.infinity,
                                                            decoration: chat.senderId == fullProfile.id ? BoxDecoration(
                                                              color: getAppColor(AppColors.background),
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(0),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                                            ) : const BoxDecoration(
                                                              color: AppColors.button,
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(20)),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                if(!isRepliedFile)
                                                                  HashTagText(
                                                                  text: repliedChat.deleted == true ? "This message was deleted" : repliedChat.message.toString(),
                                                                  decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                                                    color: chat.senderId != fullProfile.id ?  Colors.blue : AppColors.primary,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.normal,
                                                                  ),
                                                                  basicStyle: AppTextStyle.bodyText1.copyWith(
                                                                    color: chat.deleted == true ? Colors.blue : chat.senderId != fullProfile.id ? Colors.white : getAppColor(AppColors.onBackground),
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontStyle: chat.deleted == true ? FontStyle.italic : FontStyle.normal,
                                                                  ),
                                                                  onTap: (text) {
                                                                    controller.defaultSearchValue = text;
                                                                    Get.to(() => Search());
                                                                  },
                                                                  decorateAtSign: true,
                                                                ),
                                                                if((getUrlType(repliedChat.fileUrl.toString()) == UrlType.VIDEO || getUrlType(repliedChat.fileUrl.toString()) == UrlType.IMAGE) && isRepliedFile)
                                                                  SizedBox(
                                                                    height: Get.height * 0.18,
                                                                    child: NewsfeedMultipleImageView(
                                                                      imageUrls: [repliedChat.fileUrl.toString()],
                                                                      marginLeft: 0.0,
                                                                      marginRight: 0.0,
                                                                      marginBottom: 0,
                                                                      marginTop: 0,
                                                                      radius: 10,
                                                                    ),
                                                                  ),
                                                                if(getUrlType(repliedChat.fileUrl.toString()) == UrlType.AUDIO && isRepliedFile)
                                                                  VoiceMessage(
                                                                    audioSrc: repliedChat.fileUrl.toString(),
                                                                    played: false, // To show played badge or not.
                                                                    me: repliedChat.senderId == fullProfile.id, // Set message side.
                                                                    onPlay: () {},
                                                                    meBgColor: AppColors.button,
                                                                    contactBgColor: getAppColor(AppColors.background),
                                                                    contactPlayIconColor: getAppColor(AppColors.background),
                                                                  ),
                                                                if(getUrlType(repliedChat.fileUrl.toString()) != UrlType.AUDIO && getUrlType(repliedChat.fileUrl.toString()) != UrlType.VIDEO && getUrlType(repliedChat.fileUrl.toString()) != UrlType.IMAGE && isRepliedFile)
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          color: repliedChat.senderId == fullProfile.id ? getAppColor(AppColors.background) : AppColors.button,
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                        height: Get.height*0.04,
                                                                        width: Get.width*0.08,
                                                                        child: Icon(Icons.attach_file, color: repliedChat.senderId == fullProfile.id ? getAppColor(AppColors.background) : Colors.white,),
                                                                      ),
                                                                      SizedBox(width: Get.width*0.01),
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: Get.width*0.4,
                                                                            child: Text(
                                                                              repliedChat.fileUrl.toString().split("/").last,
                                                                              style: AppTextStyle.bodyText1.copyWith(
                                                                                color: repliedChat.senderId == fullProfile.id ? Colors.white :getAppColor(AppColors.background),
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: Get.width*0.4,
                                                                            child: Text(
                                                                              repliedChat.fileUrl.toString().split(".").last.toUpperCase(),
                                                                              style: AppTextStyle.bodyText1.copyWith(
                                                                                color: repliedChat.senderId == fullProfile.id ? AppColors.primary :AppColors.button,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        if(!isFile)
                                                          HashTagText(
                                                          text: chat.deleted == true ? "This message was deleted" : chat.message.toString(),
                                                          decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                                            color: chat.senderId != fullProfile.id ?  Colors.blue : AppColors.primary,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                          basicStyle: AppTextStyle.bodyText1.copyWith(
                                                            color: chat.deleted == true ? Colors.blue : chat.senderId == fullProfile.id ?  Colors.white : getAppColor(AppColors.onBackground),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.normal,
                                                            fontStyle: chat.deleted == true ? FontStyle.italic : FontStyle.normal,
                                                          ),
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                        if((getUrlType(chat.fileUrl.toString()) == UrlType.VIDEO || getUrlType(chat.fileUrl.toString()) == UrlType.IMAGE) && isFile)
                                                          SizedBox(
                                                            height: Get.height * 0.18,
                                                            child: NewsfeedMultipleImageView(
                                                              imageUrls: [chat.fileUrl.toString()],
                                                              marginLeft: 0.0,
                                                              marginRight: 0.0,
                                                              marginBottom: 0,
                                                              marginTop: 0,
                                                              radius: 15,
                                                            ),
                                                          ),
                                                        if(getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile)
                                                          VoiceMessage(
                                                            audioSrc: chat.fileUrl.toString(),
                                                            played: false, // To show played badge or not.
                                                            me: chat.senderId == fullProfile.id, // Set message side.
                                                            onPlay: () {},
                                                            meBgColor: AppColors.button,
                                                            contactBgColor: getAppColor(AppColors.background),
                                                            contactPlayIconColor: getAppColor(AppColors.background),
                                                          ),
                                                        if(getUrlType(chat.fileUrl.toString()) != UrlType.AUDIO && getUrlType(chat.fileUrl.toString()) != UrlType.VIDEO && getUrlType(chat.fileUrl.toString()) != UrlType.IMAGE && isFile)
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                  color: chat.senderId == fullProfile.id ? getAppColor(AppColors.background) : AppColors.button,
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                height: Get.height*0.04,
                                                                width: Get.width*0.08,
                                                                  child: Icon(Icons.attach_file, color: chat.senderId == fullProfile.id ? getAppColor(Colors.black) : Colors.white,),
                                                              ),
                                                              SizedBox(width: Get.width*0.01),
                                                              Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width: Get.width*0.4,
                                                                    child: Text(
                                                                      chat.fileUrl.toString().split("/").last,
                                                                      style: AppTextStyle.bodyText1.copyWith(
                                                                        color: chat.senderId == fullProfile.id ? Colors.white :getAppColor(Colors.black),
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: Get.width*0.4,
                                                                    child: Text(
                                                                      chat.fileUrl.toString().split(".").last.toUpperCase(),
                                                                      style: AppTextStyle.bodyText1.copyWith(
                                                                        color: chat.senderId == fullProfile.id ? AppColors.primary :AppColors.button,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuButton(
                                                      color: getAppColor(Colors.white),
                                                      padding: EdgeInsets.zero,
                                                      child: Container(
                                                        height: Get.height*0.03,
                                                        width: Get.width*0.05,
                                                        padding: EdgeInsets.zero,
                                                        margin: EdgeInsets.zero,
                                                        decoration: chat.senderId == fullProfile.id ? const BoxDecoration(
                                                          color: AppColors.button,
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(0)),
                                                        ) : BoxDecoration(
                                                          color: getAppColor(AppColors.background),
                                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(0)),
                                                        ),
                                                        child: Icon(
                                                          Icons.arrow_drop_down_rounded,
                                                          color: chat.senderId == fullProfile.id ? Colors.white : getAppColor(Colors.black),
                                                          size: 22,
                                                        ),
                                                      ),
                                                      onSelected: (value) {
                                                        if(value == 0){
                                                          chatToReply = chat;
                                                          chatController.update();
                                                        }else if(value == 1){
                                                          Get.bottomSheet(
                                                              PersonBottomSheet(
                                                                buttonText: "Forward",
                                                                title: "Forward To",
                                                                onTap: (person) async {
                                                                  var message = {
                                                                    "receiverId":person.id,
                                                                    "chatId":post.chatId.toString(),
                                                                    "message":chat.message.toString(),
                                                                    "forwardMessage":true,
                                                                    "messageType": chat.messageType.toString(),
                                                                    "fileUrl":chat.fileUrl.toString(),
                                                                  };
                                                                  chatController.listenToCustomEvent('notify_user',(data){
                                                                    SendMessageResponse sendMessageResponse = SendMessageResponse.fromJson(data);
                                                                    if(sendMessageResponse.status == true){
                                                                      chatTextController.clear();
                                                                      chatToReply = null;
                                                                      chatController.update();
                                                                    }
                                                                    chatController.stopListeningToEvent("notify_user");
                                                                  });
                                                                  chatController.emitMessages("send_message", message);
                                                                  AppOverlay.showSuccessSnackBar(content: "Message Forwarded");
                                                                },
                                                              ),
                                                              isScrollControlled: true
                                                          );
                                                        }else if(value == 2){
                                                          AppOverlay.showDeviceDialog(
                                                            title: "Delete Message",
                                                            content: "Are you sure you want to delete this message?",
                                                            positiveText: "Delete",
                                                            onPositivePressed: () {
                                                              chatController.deleteSingleMessage(
                                                                  chatID: chat.id.toString(),
                                                                  receiverId: chat.receiverId.toString()
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          value: 0,
                                                          child: Text(
                                                            "Reply",
                                                            style: AppTextStyle.bodyText1.copyWith(
                                                              color: getAppColor(Colors.black),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 1,
                                                          child: Text(
                                                            "Forward",
                                                            style: AppTextStyle.bodyText1.copyWith(
                                                              color: getAppColor(Colors.black),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 2,
                                                          child: Text(
                                                            "Delete",
                                                            style: AppTextStyle.bodyText1.copyWith(
                                                              color: getAppColor(Colors.black),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ],
                                              )
                                          ),
                                        ),
                                        SizedBox(height: Get.height*0.005),
                                      ],
                                    ),
                                  );
                                },
                              ),

                            if(previousChatModel != null && post.isGroup == true)
                              ListView.builder(
                                itemCount: previousChat.length,
                                shrinkWrap: true,
                                reverse: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var chat = previousChat[index];
                                  PreviousChat? repliedChat;
                                  bool isRepliedFile = false;
                                  if(chat.replyMessageId != null){
                                    repliedChat = previousChat.firstWhere((element) => element.id == chat.replyMessageId);
                                  }
                                  bool isFile = chat.messageType == "fileMessage";
                                  if(chat.senderId == fullProfile.id){
                                    if(chat.deleted == true){
                                      return Container();
                                    }
                                    if(chat.deletedForSender == true){
                                      return Container();
                                    }
                                  }
                                  EdgeInsetsGeometry padding = EdgeInsets.only(
                                    top: Get.height * 0.01,
                                    bottom: Get.height * 0.01,
                                    left: 10,
                                    right: 10,
                                  );
                                  if(getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile){
                                    padding= EdgeInsets.only(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        top: 0);
                                  }
                                  else if((getUrlType(chat.fileUrl.toString()) == UrlType.VIDEO || getUrlType(chat.fileUrl.toString()) == UrlType.IMAGE) && isFile){
                                    padding= EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        bottom: 5,
                                        top: 5
                                    );
                                  }
                                  else if(isFile){
                                    padding= EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 10
                                    );
                                  }

                                  EdgeInsetsGeometry repliedPadding = EdgeInsets.only(
                                    top: Get.height * 0.01,
                                    bottom: Get.height * 0.01,
                                    left: 10,
                                    right: 10,
                                  );
                                  if(repliedChat != null){
                                    isRepliedFile = repliedChat.messageType == "fileMessage";
                                    if(getUrlType(repliedChat.fileUrl.toString()) == UrlType.AUDIO && isRepliedFile){
                                      repliedPadding= const EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0);
                                    }
                                    else if((getUrlType(repliedChat.fileUrl.toString()) == UrlType.VIDEO || getUrlType(repliedChat.fileUrl.toString()) == UrlType.IMAGE) && isRepliedFile){
                                      repliedPadding= const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          bottom: 5,
                                          top: 5
                                      );
                                    }
                                    else if(isRepliedFile){
                                      repliedPadding= const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 10
                                      );
                                    }
                                  }

                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                    child: Column(
                                      crossAxisAlignment: chat.senderId == fullProfile.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: Get.height*0.005),
                                        if(chat.forwardMessage == true)
                                          Row(
                                            mainAxisAlignment: chat.senderId == fullProfile.id ? MainAxisAlignment.end : MainAxisAlignment.start,
                                            children: [
                                              Icon(FeatherIcons.cornerUpRight, color: getAppColor(Colors.grey), size: 15,),
                                              HashTagText(
                                                text: "Forwarded",
                                                decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                                  color: getAppColor(Colors.grey),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                basicStyle: AppTextStyle.bodyText1.copyWith(
                                                  color: getAppColor(Colors.grey),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                decorateAtSign: false,
                                              ),
                                            ],
                                          ),
                                        Container(
                                          width: isFile ? Get.width*0.65 :Get.width*0.55,
                                          decoration: chat.senderId == fullProfile.id ? const BoxDecoration(
                                            color: AppColors.button,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(0),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          ) : BoxDecoration(
                                            color: getAppColor(AppColors.background),
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          ),
                                          child: Padding(
                                              padding: padding,
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  SizedBox(
                                                    width: isFile ? Get.width*0.65 :Get.width*0.55,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        if(chat.senderId != fullProfile.id)
                                                          HashTagText(
                                                          text:chat.senderUserName.toString(),
                                                          decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                                            color: getAppColor(AppColors.button),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                          basicStyle: AppTextStyle.bodyText1.copyWith(
                                                            color: getAppColor(AppColors.button),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                        if(repliedChat!=null)
                                                          Container(
                                                            padding: repliedPadding,
                                                            width: double.infinity,
                                                            decoration: chat.senderId == fullProfile.id ? BoxDecoration(
                                                              color: getAppColor(AppColors.background),
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(0),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                                            ) : const BoxDecoration(
                                                              color: AppColors.button,
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(20)),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                if(!isRepliedFile)
                                                                  HashTagText(
                                                                    text: repliedChat.deleted == true ? "This message was deleted" : repliedChat.message.toString(),
                                                                    decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                                                      color: chat.senderId != fullProfile.id ?  Colors.blue : AppColors.primary,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.normal,
                                                                    ),
                                                                    basicStyle: AppTextStyle.bodyText1.copyWith(
                                                                      color: chat.deleted == true ? Colors.blue : chat.senderId != fullProfile.id ? Colors.white : getAppColor(AppColors.onBackground),
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.normal,
                                                                      fontStyle: chat.deleted == true ? FontStyle.italic : FontStyle.normal,
                                                                    ),
                                                                    onTap: (text) {
                                                                      controller.defaultSearchValue = text;
                                                                      Get.to(() => Search());
                                                                    },
                                                                    decorateAtSign: true,
                                                                  ),
                                                                if((getUrlType(repliedChat.fileUrl.toString()) == UrlType.VIDEO || getUrlType(repliedChat.fileUrl.toString()) == UrlType.IMAGE) && isRepliedFile)
                                                                  SizedBox(
                                                                    height: Get.height * 0.18,
                                                                    child: NewsfeedMultipleImageView(
                                                                      imageUrls: [repliedChat.fileUrl.toString()],
                                                                      marginLeft: 0.0,
                                                                      marginRight: 0.0,
                                                                      marginBottom: 0,
                                                                      marginTop: 0,
                                                                      radius: 10,
                                                                    ),
                                                                  ),
                                                                if(getUrlType(repliedChat.fileUrl.toString()) == UrlType.AUDIO && isRepliedFile)
                                                                  VoiceMessage(
                                                                    audioSrc: repliedChat.fileUrl.toString(),
                                                                    played: false, // To show played badge or not.
                                                                    me: repliedChat.senderId == fullProfile.id, // Set message side.
                                                                    onPlay: () {},
                                                                    meBgColor: AppColors.button,
                                                                    contactBgColor: getAppColor(AppColors.background),
                                                                    contactPlayIconColor: getAppColor(AppColors.background),
                                                                  ),
                                                                if(getUrlType(repliedChat.fileUrl.toString()) != UrlType.AUDIO && getUrlType(repliedChat.fileUrl.toString()) != UrlType.VIDEO && getUrlType(repliedChat.fileUrl.toString()) != UrlType.IMAGE && isRepliedFile)
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          color: repliedChat.senderId == fullProfile.id ? getAppColor(AppColors.background) : AppColors.button,
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                        height: Get.height*0.04,
                                                                        width: Get.width*0.08,
                                                                        child: Icon(Icons.attach_file, color: repliedChat.senderId == fullProfile.id ? getAppColor(AppColors.background) : Colors.white,),
                                                                      ),
                                                                      SizedBox(width: Get.width*0.01),
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            width: Get.width*0.4,
                                                                            child: Text(
                                                                              repliedChat.fileUrl.toString().split("/").last,
                                                                              style: AppTextStyle.bodyText1.copyWith(
                                                                                color: repliedChat.senderId == fullProfile.id ? Colors.white :getAppColor(AppColors.background),
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: Get.width*0.4,
                                                                            child: Text(
                                                                              repliedChat.fileUrl.toString().split(".").last.toUpperCase(),
                                                                              style: AppTextStyle.bodyText1.copyWith(
                                                                                color: repliedChat.senderId == fullProfile.id ? AppColors.primary :AppColors.button,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        if(!isFile)
                                                          HashTagText(
                                                            text: chat.deleted == true ? "This message was deleted" : chat.message.toString(),
                                                            decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                                              color: chat.senderId != fullProfile.id ?  Colors.blue : AppColors.primary,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal,
                                                            ),
                                                            basicStyle: AppTextStyle.bodyText1.copyWith(
                                                              color: chat.deleted == true ? Colors.blue : chat.senderId == fullProfile.id ?  Colors.white : getAppColor(AppColors.onBackground),
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal,
                                                              fontStyle: chat.deleted == true ? FontStyle.italic : FontStyle.normal,
                                                            ),
                                                            onTap: (text) {
                                                              controller.defaultSearchValue = text;
                                                              Get.to(() => Search());
                                                            },
                                                            decorateAtSign: true,
                                                          ),
                                                        if((getUrlType(chat.fileUrl.toString()) == UrlType.VIDEO || getUrlType(chat.fileUrl.toString()) == UrlType.IMAGE) && isFile)
                                                          SizedBox(
                                                            height: Get.height * 0.18,
                                                            child: NewsfeedMultipleImageView(
                                                              imageUrls: [chat.fileUrl.toString()],
                                                              marginLeft: 0.0,
                                                              marginRight: 0.0,
                                                              marginBottom: 0,
                                                              marginTop: 0,
                                                              radius: 15,
                                                            ),
                                                          ),
                                                        if(getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile)
                                                          VoiceMessage(
                                                            audioSrc: chat.fileUrl.toString(),
                                                            played: false, // To show played badge or not.
                                                            me: chat.senderId == fullProfile.id, // Set message side.
                                                            onPlay: () {},
                                                            meBgColor: AppColors.button,
                                                            contactBgColor: getAppColor(AppColors.background),
                                                            contactPlayIconColor: getAppColor(AppColors.background),
                                                          ),
                                                        if(getUrlType(chat.fileUrl.toString()) != UrlType.AUDIO && getUrlType(chat.fileUrl.toString()) != UrlType.VIDEO && getUrlType(chat.fileUrl.toString()) != UrlType.IMAGE && isFile)
                                                          Row(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  color: chat.senderId == fullProfile.id ? getAppColor(AppColors.background) : AppColors.button,
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                height: Get.height*0.04,
                                                                width: Get.width*0.08,
                                                                child: Icon(Icons.attach_file, color: chat.senderId == fullProfile.id ? getAppColor(Colors.black) : Colors.white,),
                                                              ),
                                                              SizedBox(width: Get.width*0.01),
                                                              Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width: Get.width*0.4,
                                                                    child: Text(
                                                                      chat.fileUrl.toString().split("/").last,
                                                                      style: AppTextStyle.bodyText1.copyWith(
                                                                        color: chat.senderId == fullProfile.id ? Colors.white :getAppColor(Colors.black),
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: Get.width*0.4,
                                                                    child: Text(
                                                                      chat.fileUrl.toString().split(".").last.toUpperCase(),
                                                                      style: AppTextStyle.bodyText1.copyWith(
                                                                        color: chat.senderId == fullProfile.id ? AppColors.primary :AppColors.button,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuButton(
                                                      color: getAppColor(Colors.white),
                                                      padding: EdgeInsets.zero,
                                                      child: Container(
                                                        height: Get.height*0.03,
                                                        width: Get.width*0.05,
                                                        padding: EdgeInsets.zero,
                                                        margin: EdgeInsets.zero,
                                                        decoration: chat.senderId == fullProfile.id ? const BoxDecoration(
                                                          color: AppColors.button,
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(0)),
                                                        ) : BoxDecoration(
                                                          color: getAppColor(AppColors.background),
                                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(0)),
                                                        ),
                                                        child: Icon(
                                                          Icons.arrow_drop_down_rounded,
                                                          color: chat.senderId == fullProfile.id ? Colors.white : getAppColor(Colors.black),
                                                          size: 22,
                                                        ),
                                                      ),
                                                      onSelected: (value) {
                                                        if(value == 0){
                                                          chatToReply = chat;
                                                          chatController.update();
                                                        }else if(value == 1){
                                                          Get.bottomSheet(
                                                              PersonBottomSheet(
                                                                buttonText: "Forward",
                                                                title: "Forward To",
                                                                onTap: (person) async {
                                                                  var message = {
                                                                    "receiverId":person.id,
                                                                    "chatId":post.chatId.toString(),
                                                                    "message":chat.message.toString(),
                                                                    "forwardMessage":true,
                                                                    "messageType": chat.messageType.toString(),
                                                                    "fileUrl":chat.fileUrl.toString(),
                                                                  };
                                                                  chatController.listenToCustomEvent('notify_user',(data){
                                                                    SendMessageResponse sendMessageResponse = SendMessageResponse.fromJson(data);
                                                                    if(sendMessageResponse.status == true){
                                                                      chatTextController.clear();
                                                                      chatToReply = null;
                                                                      chatController.update();
                                                                    }
                                                                    chatController.stopListeningToEvent("notify_user");
                                                                  });
                                                                  chatController.emitMessages("send_message", message);
                                                                  AppOverlay.showSuccessSnackBar(content: "Message Forwarded");
                                                                },
                                                              ),
                                                              isScrollControlled: true
                                                          );
                                                        }else if(value == 2){
                                                          AppOverlay.showDeviceDialog(
                                                            title: "Delete Message",
                                                            content: "Are you sure you want to delete this message?",
                                                            positiveText: "Delete",
                                                            onPositivePressed: () {
                                                              chatController.deleteSingleMessage(
                                                                  chatID: chat.id.toString(),
                                                                  receiverId: id
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          value: 0,
                                                          child: Text(
                                                            "Reply",
                                                            style: AppTextStyle.bodyText1.copyWith(
                                                              color: getAppColor(Colors.black),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 1,
                                                          child: Text(
                                                            "Forward",
                                                            style: AppTextStyle.bodyText1.copyWith(
                                                              color: getAppColor(Colors.black),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 2,
                                                          child: Text(
                                                            "Delete",
                                                            style: AppTextStyle.bodyText1.copyWith(
                                                              color: getAppColor(Colors.black),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ],
                                              )
                                          ),
                                        ),
                                        SizedBox(height: Get.height*0.005),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      if(!canScrollDown)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: 0),
                            child: Container(
                              width: Get.width*0.1,
                              height: Get.height*0.1,
                              decoration: BoxDecoration(
                                color: getAppColor(AppColors.background),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  await _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                  );
                                  chatController.update(['chats_screen']);
                                  canScrollDown = true;
                                },
                                icon: Icon(FeatherIcons.arrowDown, color: getAppColor(Colors.black),),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                color: getAppColor(AppColors.background),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Color(0xffEDEAEA),
                      height: 1.0,
                    ),
                    SizedBox(height: Get.height*0.008),
                    AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        child: chatToReply == null ? const SizedBox.shrink() : Padding(
                          padding: EdgeInsets.symmetric(horizontal: Get.width*0.035),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width*0.8,
                                child: HashTagText(
                                  text: chatToReply!.message.toString(),
                                  basicStyle: AppTextStyle.bodyText1.copyWith(
                                    color: getAppColor(Colors.black),
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
                              Spacer(),
                              InkWell(
                                onTap: (){
                                  chatToReply = null;
                                  chatController.update();
                                },
                                child: Icon(Icons.cancel_rounded, color: Colors.grey),
                              )
                            ],
                          ),
                        )
                    ),
                    if(chatToReply != null)
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
                              filledColor: getAppColor(Colors.grey.shade300),
                              borderSide: BorderSide.none,
                              hintColor: getAppColor(Colors.grey.shade500),
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              focusNode: inputNode,
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    File file = File(result.files.single.path!);
                                    Map<String,dynamic> body = {};
                                    var contentType = lookupMimeType(result.files.single.path!);
                                    body['file'] = await dio.MultipartFile.fromFile(
                                      file.path,
                                      filename: file.path.split('/').last,
                                      contentType: http_parser.MediaType.parse(contentType!),
                                    );
                                    controller.postData(dio.FormData.fromMap(body), "/social-file-resource/aws-upload-file?").then((value){
                                      if(value.isSuccessful){
                                        if(post.isGroup == true){
                                          var message = {
                                            "chatId":post.chatId.toString(),
                                            "message":"file",
                                            "forwardMessage":false,
                                            "messageType": "fileMessage",
                                            "groupId": id,
                                            "fileUrl": value.url.toString(),
                                          };
                                          chatController.listenToCustomEvent('notify_user',(data){
                                            SendMessageResponse sendMessageResponse = SendMessageResponse.fromJson(data);
                                            if(sendMessageResponse.status == true){
                                              chatTextController.clear();
                                              chatController.update(['chats_screen']);
                                            }
                                            chatController.stopListeningToEvent("notify_user");
                                          });
                                          chatController.emitMessages("send_group_message", message);
                                        }else{
                                          var message = {
                                            "receiverId":post.otherId.toString(),
                                            "chatId":post.chatId.toString(),
                                            "message":"file",
                                            "forwardMessage":false,
                                            "messageType": "fileMessage",
                                            "fileUrl": value.url.toString(),
                                          };
                                          chatController.listenToCustomEvent('notify_user',(data){
                                            SendMessageResponse sendMessageResponse = SendMessageResponse.fromJson(data);
                                            if(sendMessageResponse.status == true){
                                              chatTextController.clear();
                                              chatController.update(['chats_screen']);
                                            }
                                            chatController.stopListeningToEvent("notify_user");
                                          });
                                          chatController.emitMessages("send_message", message);
                                        }
                                      }
                                    });
                                  }
                                },
                                icon: Transform.rotate(
                                  angle: 45 * math.pi / 180,
                                  child: Icon(
                                    Icons.attach_file_rounded,
                                    color: getAppColor(Colors.grey),
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
                                if(post.isGroup == true){
                                  if(chatTextController.text.isNotEmpty){
                                    var message = {
                                      "chatId":post.chatId.toString(),
                                      "message":chatTextController.text.toString(),
                                      "forwardMessage":false,
                                      "messageType": "textMessage",
                                      "groupId": id,
                                      "fileUrl":"null",
                                    };
                                    if(chatToReply != null){
                                      message['replyMessageId'] = chatToReply!.id.toString();
                                    }
                                    chatController.listenToCustomEvent('notify_user',(data){
                                      SendMessageResponse sendMessageResponse = SendMessageResponse.fromJson(data);
                                      if(sendMessageResponse.status == true){
                                        chatTextController.clear();
                                        chatToReply = null;
                                        chatController.update();
                                      }
                                      chatController.stopListeningToEvent("notify_user");
                                    });
                                    chatController.emitMessages("send_group_message", message);
                                  }
                                }
                                else {
                                  if(chatTextController.text.isNotEmpty){
                                    var message = {
                                      "receiverId":post.otherId.toString(),
                                      "chatId":post.chatId.toString(),
                                      "message":chatTextController.text.toString(),
                                      "forwardMessage":false,
                                      "messageType": "textMessage"
                                    };
                                    if(chatToReply != null){
                                      message['replyMessageId'] = chatToReply!.id.toString();
                                    }
                                    chatController.listenToCustomEvent('notify_user',(data){
                                      SendMessageResponse sendMessageResponse = SendMessageResponse.fromJson(data);
                                      if(sendMessageResponse.status == true){
                                        chatTextController.clear();
                                        chatToReply = null;
                                        chatController.update();
                                      }
                                      chatController.stopListeningToEvent("notify_user");
                                    });
                                    chatController.emitMessages("send_message", message);
                                  }
                                }
                              },
                              icon: Icon(
                                //chatTextController.text.isEmpty
                                  //  ? Icons.mic_rounded:
                              Icons.send_rounded,
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
    chatController.stopListeningToEvent("load_previous_chats");
  }
}