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
import '../modules/home/tabs/home_tab.dart';
import '../modules/home/tabs/notifications_tab.dart';
import '../repository/user_repo.dart';

class ChatController extends GetxController {
  final UserRepository userRepo;
  ChatController(this.userRepo);

  ChatListOverView? chatListOverView;

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

    });
    userRepo.api.listenToEvent('message', (data) {

    });
    userRepo.api.listenToEvent('new_message', (data) {

    });
    userRepo.api.listenToEvent('notify_user', (data) {

    });
    userRepo.api.listenToEvent('load_chat_overview', (data) {
      chatListOverView = ChatListOverView.fromJson(data);
      MyPref.chatOverView.val = jsonEncode(data);
      update(['chats_overview']);
    });
    userRepo.api.listenToEvent('load_previous_chats', (data) {

    });
    userRepo.api.listenToEvent('user_chat_error', (data) {

    });
    userRepo.api.listenToEvent('group_chat_error', (data) {

    });
    userRepo.api.listenToEvent('notify_group_member', (data) {

    });
    userRepo.api.listenToEvent('is_online_group_members', (data) {

    });
    userRepo.api.listenToEvent('load_group_chat_overview', (data) {

    });
    userRepo.api.listenToEvent('load_previous_group_chats', (data) {

    });
    userRepo.api.listenToEvent('is_user_typing', (data) {

    });
    userRepo.api.listenToEvent('message_deleted', (data) {

    });
    userRepo.api.listenToEvent('notify_user_deleted', (data) {

    });
    userRepo.api.listenToEvent('clear_chats', (data) {

    });
    userRepo.api.listenToEvent('is_user_online', (data) {

    });

    userRepo.api.emitEvent('chat_overview', {});
  }

  void emitMessages(){

  }
}