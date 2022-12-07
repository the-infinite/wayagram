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
import 'package:voice_message_package/voice_message_package.dart';
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
import '../../data/socket_models/previous_chat_model.dart' as normal_chat;
import '../../data/socket_models/send_message_response.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;
import 'dart:math' as math;


import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/person_view.dart';
import '../../global_widgets/smart_image.dart';
import '../home/widgets/HashTagView.dart';
import '../home/widgets/group_view.dart';

import '../home/widgets/posts_view.dart' as post_view;

import 'package:timeago/timeago.dart' as timeago;

import '../search/search.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chatOverview}) : super(key: key);

  final ChatOverview chatOverview;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var chatController = Get.find<ChatController>();
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
          duration: const Duration(milliseconds: 200),
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
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<ChatController>(id:'chats_screen',builder: (chatController) {
        var chatNormalInfo = {"otherId": id};
        var chatGroupInfo = {"groupId":id};
        if(mounted){
          if(post.isGroup == true){

          }else{
            chatController.listenToCustomEvent('load_previous_chats',(chatData){
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
                            imgUrl: avatar,
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
                    IconButton(onPressed: (){
                      comingSoon();
                    }, icon: const Icon(Icons.videocam_rounded, color: Colors.black,size: 24)),
                    IconButton(onPressed: (){
                      comingSoon();
                    }, icon: const Icon(Icons.call_rounded, color: Colors.black,size: 20,)),
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
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.shade200,
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
                                  bool isFile = false;
                                  if(chat.messageType == "fileMessage"){
                                    isFile = true;
                                    print("${chat.messageType} ${chat.fileUrl}");
                                  }
                                  if(chat.senderId == fullProfile.id){
                                    if(chat.deleted == true){
                                      return Container();
                                    }
                                    if(chat.deletedForSender == true){
                                      return Container();
                                    }
                                  }
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                    child: Column(
                                      crossAxisAlignment: chat.senderId == fullProfile.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: Get.height*0.005),
                                        Container(
                                          width: isFile ? Get.width*0.6 :Get.width*0.55,
                                          decoration: chat.senderId == fullProfile.id ? const BoxDecoration(
                                            color: AppColors.button,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(0),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          ) : const BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile ? 0 : 10,
                                                  right: getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile ? 0 : 10,
                                                  bottom: getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile ? 0 : 10,
                                                  top: getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile ? 0 : 10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if(!isFile)
                                                    HashTagText(
                                                    text: chat.deleted == true ? "This message was deleted" : chat.message.toString(),
                                                    decoratedStyle: AppTextStyle.bodyText1.copyWith(
                                                      color: chat.senderId != fullProfile.id ?  Colors.blue : AppColors.primary,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                    basicStyle: AppTextStyle.bodyText1.copyWith(
                                                      color: chat.deleted == true ? Colors.blue : chat.senderId == fullProfile.id ? Colors.white :Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal,
                                                      fontStyle: chat.deleted == true ? FontStyle.italic : FontStyle.normal,
                                                    ),
                                                    onTap: (text) {
                                                      controller.defaultSearchValue = text;
                                                      Get.to(() => const Search());
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
                                                        radius: 12,
                                                      ),
                                                    ),
                                                  if(getUrlType(chat.fileUrl.toString()) == UrlType.AUDIO && isFile)
                                                    VoiceMessage(
                                                      audioSrc: chat.fileUrl.toString(),
                                                      played: false, // To show played badge or not.
                                                      me: chat.senderId == fullProfile.id, // Set message side.
                                                      onPlay: () {},
                                                      meBgColor: AppColors.button,
                                                      contactBgColor: AppColors.background,
                                                      contactPlayIconColor: AppColors.background,
                                                    ),
                                                  if(getUrlType(chat.fileUrl.toString()) != UrlType.AUDIO && getUrlType(chat.fileUrl.toString()) != UrlType.VIDEO && getUrlType(chat.fileUrl.toString()) != UrlType.IMAGE && isFile)
                                                    Row(
                                                      children: [
                                                        Container(
                                                            decoration: BoxDecoration(
                                                            color: chat.senderId == fullProfile.id ? AppColors.background : AppColors.button,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          height: Get.height*0.04,
                                                          width: Get.width*0.08,
                                                            child: Icon(Icons.attach_file, color: chat.senderId == fullProfile.id ? Colors.black : Colors.white,),
                                                        ),
                                                        SizedBox(width: Get.width*0.01),
                                                        Column(
                                                          children: [
                                                            SizedBox(
                                                              width: Get.width*0.4,
                                                              child: Text(
                                                                chat.fileUrl.toString().split("/").last,
                                                                style: AppTextStyle.bodyText1.copyWith(
                                                                  color: chat.senderId == fullProfile.id ? Colors.white :Colors.black,
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
                              decoration: const BoxDecoration(
                                color: AppColors.background,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  await _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                  );
                                  chatController.update(['chats_screen']);
                                  canScrollDown = true;
                                },
                                icon: const Icon(FeatherIcons.arrowDown, color: Colors.black,),
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
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  Map<String,dynamic> body = {};
                                  body['file'] = await dio.MultipartFile.fromFile(
                                    file.path,
                                    filename: file.path.split('/').last,
                                  );
                                  //https://services.staging.wayagram.ng/social-file-resource/aws-upload-file?&sso_id=121
                                  controller.postData(dio.FormData.fromMap(body), "/social-file-resource/aws-upload-file?").then((value){
                                    if(value.isSuccessful){
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
                                  });
                                }
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
                              if(post.isGroup == true){
                                var chatGroupInfo = {"groupId":id};
                              }else {
                                if(chatTextController.text.isNotEmpty){
                                  var message = {
                                    "receiverId":post.otherId.toString(),
                                    "chatId":post.chatId.toString(),
                                    "message":chatTextController.text.toString(),
                                    "forwardMessage":false,
                                    "messageType": "textMessage"
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
          );
        });
      }),
    );
  }

  void comingSoon() {
    const String failed = "assets/images/failed.svg";
    showDialog(
        context: Get.context!,
        builder: (_) => AlertDialog(
          shape: const RoundedRectangleBorder(
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
                      SvgPicture.asset(
                        failed,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Coming soon')
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