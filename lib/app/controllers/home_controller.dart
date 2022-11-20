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
import '../data/model/full_user_profile_entity.dart';
import '../data/model/log_in_model_entity.dart';
import '../data/model/profile_model_entity.dart';
import '../data/providers/api_response.dart';
import '../data/providers/my_pref.dart';
import '../modules/home/tabs/home_tab.dart';
import '../modules/home/tabs/notifications_tab.dart';
import '../repository/user_repo.dart';

class HomeController extends GetxController {
  final UserRepository userRepo;

  var defaultSearchValue = "";
  TextEditingController otp = TextEditingController();
  RxInt currentBottomNavPage = 0.obs;

  late TabController shopController;
  bool isPersonalShop = false;

  late TabController notificationController;
  bool isNotification = false;

  late TabController chatController;
  bool isChat = false;

  HomeController(this.userRepo);

  List<Widget> pages = const [
    HomeTab(),
    DiscoverTab(),
    ShopsTab(),
    NotificationsTab(),
    ChatsTab()
  ];
  String image1 = "";
  String image2 = "";
  List<String> imagePaths = [];
  List<Contact> contacts = [];
  List<Contact> contactToShow = [];
  List<SearchPeopleResponse> searchPeopleResponse = [];
  bool hasContactPermission = false;

  var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
  var logInDetails = LogInModelEntity.fromJson(jsonDecode(MyPref.logInDetail.val));

  Future<void> checkPermissionStatus() async{
    var status = await Permission.contacts.status;
    if (await FlutterContacts.requestPermission()) {
      var contacts = await FlutterContacts.getContacts(withProperties: true,withThumbnail: true,withPhoto: true);
      this.contacts = contacts;
      contactToShow.clear();
      contactToShow.addAll(contacts.sublist(0, contacts.length > 15 ? 15 : contacts.length));
      update(['contact']);
      for (var element in contactToShow) {
        if(element.phones.isNotEmpty){
          var number = element.phones.first.normalizedNumber.replaceAll("+", "");
          if(number.isEmpty){
            number = element.phones.first.number.replaceAll("+", "").replaceFirst("0", "");
          }
          getData("auth-service/api/v1/search/search-profile-phoneNumber/$number", false).then((response) {
            if(response.isSuccessful){
              var data = SearchPeopleResponse.listFromJson(response.data);
              if(data.isNotEmpty){
                searchPeopleResponse.addAll(data);
              }
            }
          });
          var body = {
            "contactList": [
              {
                "phone": number
              }
            ]
          };
          postData(body, "wayagram-service/main/save-contact");
        }
      }
    }else{
      hasContactPermission = false;
      contacts.clear();
      contactToShow.clear();
      update(['contact']);
    }
  }

  Future<void> updateContactList() async{
    var status = await Permission.contacts.status;
    if (status == PermissionStatus.granted) {
      if(contactToShow.length < contacts.length){
        var oldLength = contactToShow.length;
        var newLength = contactToShow.length+10 > contacts.length ? contacts.length : contactToShow.length+10;
        await Future.forEach(
            contacts.sublist(oldLength,newLength),
                (contact) async {
              contactToShow.add(contact as Contact);
            }
        );
        await Future.forEach(contacts.sublist(oldLength,newLength), (contact) async {
          var element = contact as Contact;
          if(element.phones.isNotEmpty){
            var number = element.phones.first.normalizedNumber.replaceAll("+", "");
            if(number.isEmpty){
              number = element.phones.first.number.replaceAll("+", "").replaceFirst("0", "");
            }
            var response = await getData("auth-service/api/v1/search/search-profile-phoneNumber/$number", false);
            if(response.isSuccessful){
              var data = SearchPeopleResponse.listFromJson(response.data);
              if(data.isNotEmpty){
                searchPeopleResponse.addAll(data);
              }
            }
            var body = {
              "contactList": [
                {
                  "phone": number
                }
              ]
            };
            postData(body, "wayagram-service/main/save-contact");
          }
        });
        update(['contact']);
      }
    }else{
      contacts.clear();
      contactToShow.clear();
      update(['contact']);
    }
  }

  toggleShop(int index, {bool animate = true}) {
    update(['home']);
  }

  toggleNotification(int index, {bool animate = true}) {
    update(['home']);
  }

  toggleChat(int index) {
    update(['home']);
  }

  //home
  Future<ApiResponse> get getMoments => userRepo.getMoments();
  Future<ApiResponse> get getPosts => userRepo.getPosts();

  //Search
  Future<ApiResponse> searchPost(String query) => userRepo.getData("wayagram-service/all-posts/search?query=$query");
  Future<ApiResponse> searchPages(String query) => userRepo.getData("wayagram-service/main/page/search-pages?query=$query&pageNumber=1&userId=${profile.id}");
  Future<ApiResponse> searchGroups(String query) => userRepo.getData("wayagram-service/main/group/search-groups?query=$query&pageNumber=1&userId=${profile.id}");
  Future<ApiResponse> searchPeople(String query) => userRepo.getData("wayagram-service/main/profile/search?query=$query&profile_id=${profile.id}");

  //discover
  Future<ApiResponse> get getGroups => userRepo.getGroups();
  Future<ApiResponse> get getSuggestedGroups => userRepo.getSuggestedGroups();
  Future<ApiResponse> get getSuggestedPages => userRepo.getSuggestedPages();
  Future<ApiResponse> get getEventsToAttend => userRepo.getEventsToAttend();

  Future<ApiResponse> get getPagesFollowed => userRepo.getPagesFollowed();
  Future<ApiResponse> get getPagesCreated => userRepo.getPagesCreated();

  Future<ApiResponse> get getGroupsFollowed => userRepo.getGroupsFollowed();
  Future<ApiResponse> get getGroupsCreated => userRepo.getGroupsCreated();

  //Shops
  Future<ApiResponse> get getAllProducts => userRepo.getAllProducts();
  Future<ApiResponse> get getMyProducts => userRepo.getMyProducts();

  //Notifications
  Future<ApiResponse> get getNotification => userRepo.getAllNotifications();

  Future<ApiResponse> get getBlocked => userRepo.getRestrictedAccount();
  Future<ApiResponse> get getMuted => userRepo.getMutedAccount();
  Future<ApiResponse> get getFollowing => userRepo.getFollowing();
  Future<ApiResponse> get getFollowers => userRepo.getFollowers();
  Future<ApiResponse> get getFriendSuggestions => userRepo.getFriendSuggestions();

  Future<ApiResponse> updateProfile(dynamic body) async {
    final response = await userRepo.updateProfile(body);
    await userRepo.getFullUserProfile(profile.userId.toString());
    update(['profile_page','home','settings','app_drawer']);
    AppOverlay.showInfoDialog(
        title: response.isSuccessful ? 'Success' : 'Error',
        content: response.message,
        onPressed: () async {
          if(Get.currentRoute == '/updateProfile') {
            if(response.isSuccessful) {
              Get.back();
              Get.back();
            }else{
              Get.back();
            }
          }
        }
    );
    return response;
  }

  Future<ApiResponse> postData(dynamic body,String url) async {
    final response = await userRepo.postData(url, body);
    debugPrint(response.message);
    userRepo.getFullUserProfile(profile.userId.toString()).then((value){
      update(['profile_page','home','settings']);
      getAllUserData().then((value) => update(['profile_page','home','settings']));
    });
    return response;
  }

  Future<ApiResponse> putData(dynamic body,String url) async {
    final response = await userRepo.putData(url, body);
    userRepo.getFullUserProfile(profile.userId.toString()).then((value){
      update(['home','profile_page','settings','app_drawer']);
      getAllUserData().then((value) => update(['profile_page','home','settings','app_drawer']));
    });
    return response;
  }

  Future<ApiResponse> getData(String url,bool hasSSO) async {
    final response = await userRepo.getData(url, sso: hasSSO);
    return response;
  }

  Future<void> getAllUserData() async {
    await userRepo.getFriends();
    await userRepo.getRestrictedAccount();
    await userRepo.getMutedAccount();
    await userRepo.getFollowers();
    await userRepo.getFollowing();
    await userRepo.getFriendSuggestions();
    await userRepo.getMoments();
    await userRepo.getPosts();
    //await userRepo.getGroups();
    await userRepo.getSuggestedGroups();
    await userRepo.getSuggestedPages();
    await userRepo.getEventsToAttend();
    await userRepo.getAllProducts();
    await userRepo.getMyProducts();
    await userRepo.getAllNotifications();
    await userRepo.getAccountNumber();
    await userRepo.getPageCategories();
    await userRepo.getGroupCategories();
  }

  void launchURL(String url) async {
    try {
      await launch(
        url,
        customTabsOption: const CustomTabsOption(
          toolbarColor: AppColors.primary,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
        ),
        safariVCOption: const SafariViewControllerOption(
          preferredBarTintColor: AppColors.primary,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}