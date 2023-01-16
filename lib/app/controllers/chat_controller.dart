import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/tabs/chats_tab.dart';
import 'package:wayagram/app/modules/home/tabs/discover_tab.dart';
import 'package:wayagram/app/modules/home/tabs/shops_tab.dart';

import '../../core/theme/app_colors.dart';
import '../data/model/ContactList.dart';
import '../data/model/ContactsToUpload.dart';
import '../data/model/SearchPeopleResponse.dart';
import '../data/model/all_posts_entity.dart';
import '../data/model/full_user_profile_entity.dart';
import '../data/model/group_model_entity.dart';
import '../data/model/log_in_model_entity.dart';
import '../data/model/profile_model_entity.dart';
import '../data/providers/api_response.dart';
import '../data/providers/my_pref.dart';
import '../data/socket_models/chat_list_over_view.dart';
import '../data/socket_models/previous_chat_model.dart';
import '../modules/home/tabs/home_tab.dart';
import '../modules/home/tabs/notifications_tab.dart';
import '../repository/user_repo.dart';

class ChatControllerWayagram extends GetxController {
  final UserRepository userRepo;
  ChatControllerWayagram(this.userRepo);

  ChatListOverView? chatListOverView;
  List<String> userOnline = [];
  Map<String,PreviousChatModel> previousChatMap = {};
  final jsonEncoder = JsonEncoder();

  void connectToSocket(){
    setUpMessagesScreen();
    userRepo.api.connectToServer(
      onConnect: () {
        print('socket_connected to socket');
        listenToMessages();
      },
      onDisconnect: () {
        print('socket_disconnected from socket');
      },
      onConnectError:() {
        print('socket_connect_error');
      },
      onError: (data) {
        print('socket_error: $data');
      },
    );
  }

  void setUpMessagesScreen(){
    if(MyPref.chatOverView.val.isNotEmpty){
      chatListOverView = ChatListOverView.fromJson(jsonDecode(MyPref.chatOverView.val));
    }
    update(['chats_overview']);
  }

  void listenToMessages(){
    userRepo.api.listenToEvent('user_connected', (data) {
      userOnline.add(data.toString());
      update(['chats_screen']);
      if (kDebugMode) {
        print('socket_user_connected: $data');
      }
    });
    userRepo.api.listenToEvent('message', (data) {
      if (kDebugMode) {
        print('socket_message: $data');
      }
    });
    userRepo.api.listenToEvent('new_message', (data) {
      if (kDebugMode) {
        print('socket_new_message: $data');
      }
    });
    userRepo.api.listenToEvent('notify_user', (data) {
      if (kDebugMode) {
        print('notify_user: $data');
      }
    });
    userRepo.api.listenToEvent('load_chat_overview', (data) {
      chatListOverView = ChatListOverView.fromJson(data);
      MyPref.chatOverView.val = jsonEncode(data);
      update(['chats_overview']);
      if (kDebugMode) {
        print('socket_load_chat_overview: $data');
      }
    });
    /*userRepo.api.listenToEvent('load_previous_chats', (data) {
      //var previousChats = PreviousChatModel.fromJson(data);
      if (kDebugMode) {
        //print('socket_load_previous_chats: $data');
      }
    });*/
    userRepo.api.listenToEvent('user_chat_error', (data) {
      if (kDebugMode) {
        print('user_chat_error: $data');
      }
    });
    userRepo.api.listenToEvent('group_chat_error', (data) {

    });
    userRepo.api.listenToEvent('notify_group_member', (data) {

    });
    userRepo.api.listenToEvent('is_online_group_members', (data) {
      if (kDebugMode) {
        print('socket_is_online_group_members: $data');
      }
    });
    userRepo.api.listenToEvent('load_group_chat_overview', (data) {
      if (kDebugMode) {
        print('socket_group_chat_overview: $data');
      }
    });
    userRepo.api.listenToEvent('load_previous_group_chats', (data) {

    });
    userRepo.api.listenToEvent('is_user_typing', (data) {
      if (kDebugMode) {
        print('socket_is_user_typing: $data');
      }
    });
    userRepo.api.listenToEvent('message_deleted', (data) {

    });
    userRepo.api.listenToEvent('notify_user_deleted', (data) {

    });
    userRepo.api.listenToEvent('clear_chats', (data) {

    });
    userRepo.api.listenToEvent('is_user_online', (data) {
      if (kDebugMode) {
        print('socket_is_user_online: $data');
      }
    });

    userRepo.api.listenToEvent('block_user', (data) {
      if (kDebugMode) {
        print('socket_user_blocked: $data');
      }
    });

    userRepo.api.emitEvent('chat_overview', {});
    //userRepo.api.emitEvent("is_user_online", {});
    //var string = {"otherId": "492bbb2c-4fc2-4ef4-9c65-ca449575e2b7"};
    //userRepo.api.emitEvent('previous_chats', jsonEncode(string));
  }

  Future<void> emitMessages(String eventName,Map<String,dynamic> data,{bool encode = true}) async {
    userRepo.api.emitEvent(eventName, encode ? jsonEncode(data) : data);
  }

  void listenToCustomEvent(String eventName, Function(dynamic) callback){
    userRepo.api.listenToEvent(eventName, (data) {
      callback(data);
    });
  }

  void stopListeningToEvent(String eventName){
    userRepo.api.removeCustomListener(eventName);
  }


  /////
  void deleteSingleMessage({
    required String chatID,
    required String receiverId,
    bool deleteForEveryOne = true,
    bool deletedForReceiver = true ,
    bool deletedForSender = true,
  }){
    var body ={
      "chatId": chatID,
      "receiverId": receiverId,
      "deleteForEveryOne": deleteForEveryOne,
      "deletedForReciever": deletedForReceiver,
      "deletedForSender": deletedForSender,
    };
    emitMessages('delete_message', body);
  }

  void blockUser(String id){
    var body ={
      "id": id
    };
    userRepo.api.emitEvent('block_user', body);
  }

  void archiveUser(String id){
    var body ={
      "chatId": id
    };
    userRepo.api.emitEvent('archive_chat_overview', body);
  }

  void unarchiveUser(String id){
    var body ={
      "chatId": id
    };
    userRepo.api.emitEvent('unarchive_chat_overview', body);
  }

  void unBlockUser(String id){
    var body ={
      "id": id
    };
    userRepo.api.emitEvent('unblock_user', body);
  }

  void leaveGroup(String id,String userID){
    var body ={
      "groupId": id,
      "userId": userID
    };
    userRepo.api.emitEvent('leave_group', jsonEncode(body));
  }

  void archiveChat(){
    emitMessages('block_chat', {});
  }

  void clearChat(String otherId){
    var body ={
      "otherId": otherId,
    };
    emitMessages('clear_chats', body);
  }
}