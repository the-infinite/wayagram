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
import '../modules/home/tabs/home_tab.dart';
import '../modules/home/tabs/notifications_tab.dart';
import '../repository/user_repo.dart';

class HomeControllerWayagram extends GetxController {
  final UserRepository userRepo;

  var defaultSearchValue = "";
  var defaultSearchPos = 0;
  var searchFilter = "Most Recent";
  TextEditingController otp = TextEditingController();
  RxInt currentBottomNavPage = 0.obs;

  late TabController shopController;
  bool isPersonalShop = false;

  late TabController notificationController;
  bool isNotification = false;

  late TabController chatController;
  bool isChat = false;

  String getCommentID = "";

  HomeControllerWayagram(this.userRepo);

  AllPostsEntity? postToQuote;
  GroupModelEntity? groupToPost;
  GroupModelEntity? pageToPost;

  GroupModelEntity? groupToReportIn;
  GroupModelEntity? pageToReportIn;

  bool isProductPost = false;

  List<Widget> pages = [
    const HomeTab(),
    const DiscoverTab(),
    const ShopsTab(),
    const NotificationsTab(),
    const ChatsTab()
  ];
  String image1 = "";
  String image2 = "";
  List<String> imagePaths = [];
  List<Contact> contacts = [];
  List<Contact> contactToShow = [];
  List<SearchPeopleResponse> searchPeopleResponse = [];
  bool hasContactPermission = false;

  var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
  //var logInDetails = LogInModelEntity.fromJson(jsonDecode(MyPref.logInDetail.val));
  Future<void> getUserProfile() async {
    ApiResponse response = await userRepo.getFullUserProfile(profile.userId.toString());
    if(response.isSuccessful){
      var data = response.data as FullUserProfileEntity;
      MyPref.fullProfile.val = jsonEncode(response.data);
      MyPref.profileId.val = data.id.toString();
      MyPref.notificationCount.val = data.notificationCount ?? 0;
    }
  }

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
  Future<ApiResponse> get getBookmarks => userRepo.getBookmarks();
  Future<ApiResponse> get getTopClips => userRepo.getTopClips();

  //Search
  Future<ApiResponse> searchPost(String query) => userRepo.getData("wayagram-service/all-posts/search?query=$query&filterBy=DESCRIPTION");
  Future<ApiResponse> searchPages(String query) => userRepo.getData("wayagram-service/main/page/search-pages?query=$query&pageNumber=1&userId=${profile.id}");
  Future<ApiResponse> searchGroups(String query) => userRepo.getData("wayagram-service/main/group/search-groups?query=$query&pageNumber=1&userId=${profile.id}");
  Future<ApiResponse> searchPeople(String query) => userRepo.getData("wayagram-service/main/profile/search?query=$query&profile_id=${profile.id}");
  Future<ApiResponse> searchProduct(String query) => userRepo.getData("wayagram-service/all-posts/search-products?query=$query&filterBy=DESCRIPTION");

  //discover
  Future<ApiResponse> get getGroups => userRepo.getGroups();
  Future<ApiResponse> get getSuggestedGroups => userRepo.getSuggestedGroups();
  Future<ApiResponse> get getSuggestedPages => userRepo.getSuggestedPages();
  Future<ApiResponse> get getEventsToAttend => userRepo.getEventsToAttend();
  Future<ApiResponse> get getCreatedEvents => userRepo.getAllCreatedEvents();

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
    try{
      update(['profile_page','home','settings','app_drawer']);
    }catch(e){
      debugPrint(e.toString());
    }
    if(response.isSuccessful) {
      if(Get.currentRoute == '/UpdateProfile') {
        Get.back();
      }
      AppOverlay.showSuccessSnackBar(content: "Profile Updated Successfully");
    }else{
      AppOverlay.showErrorSnackBar(content: response.message.toString());
    }
    return response;
  }

  Future<ApiResponse> postData(dynamic body,String url,{bool updatePages = true,String? pin}) async {
    final response = await userRepo.postData(url, body, pin: pin);
    if (kDebugMode) {
      print(body);
      print(response.data);
      print(response.message);
    }
    userRepo.getFullUserProfile(profile.userId.toString()).then((value){
      try{
        if(updatePages){
          update(['profile_page','home','settings']);
        }
      }catch(e){
        debugPrint(e.toString());
      }
      getAllUserData().then((value){
        try{
          if(updatePages){
            update(['profile_page','home','settings']);
          }
        }catch(e){
          debugPrint(e.toString());
        }
      });
    });
    return response;
  }

  Future<ApiResponse> putData(dynamic body,String url,{bool updatePages = true,String? pin}) async {
    final response = await userRepo.putData(url, body, pin: pin);
    if (kDebugMode) {
      print(response.message);
    }
    userRepo.getFullUserProfile(profile.userId.toString()).then((value){
      try{
        if(updatePages){
          update(['profile_page','home','settings']);
        }
      }catch(e){
        debugPrint(e.toString());
      }
      getAllUserData().then((value){
        try{
          if(updatePages){
            update(['profile_page','home','settings']);
          }
        }catch(e){
          debugPrint(e.toString());
        }
      });
    });
    return response;
  }

  Future<ApiResponse> patchData(dynamic body,String url,{bool updatePages = true,String? pin}) async {
    final response = await userRepo.patchData(url, body, pin: pin);
    if (kDebugMode) {
      print(response.message);
    }
    userRepo.getFullUserProfile(profile.userId.toString()).then((value){
      try{
        if(updatePages){
          update(['profile_page','home','settings']);
        }
      }catch(e){
        debugPrint(e.toString());
      }
      getAllUserData().then((value){
        try{
          if(updatePages){
            update(['profile_page','home','settings']);
          }
        }catch(e){
          debugPrint(e.toString());
        }
      });
    });
    return response;
  }

  Future<ApiResponse> deleteData(dynamic body,String url,{bool updatePages = true,String? pin}) async {
    final response = await userRepo.deleteData(url, body, pin: pin);
    userRepo.getFullUserProfile(profile.userId.toString()).then((value){
      if(updatePages){
        update(['profile_page','home','settings','home_tab']);
      }
      getAllUserData().then((value){
        try{
          if(updatePages){
            update(['profile_page','home','settings']);
          }
        }catch(e){
          debugPrint(e.toString());
        }
      });
    });
    return response;
  }

  Future<ApiResponse> getData(String url,bool hasSSO,{bool updatePages = true,String? pin}) async {
    final response = await userRepo.getData(url, sso: hasSSO, pin: pin);
    userRepo.getFullUserProfile(profile.userId.toString()).then((value){
      try{
        if(updatePages){
          update(['profile_page','home','settings']);
        }
      }catch(e){
        debugPrint(e.toString());
      }
      getAllUserData().then((value){
        try{
          if(updatePages){
            update(['profile_page','home','settings']);
          }
        }catch(e){
          debugPrint(e.toString());
        }
      });
    });
    return response;
  }

  Future<void> getAllUserData() async {
    try{
      await userRepo.getMoments();
      await userRepo.getPosts();

      await userRepo.getRestrictedAccount();
      await userRepo.getMutedAccount();
      await userRepo.getFollowers();
      await userRepo.getFollowing();

      await userRepo.getPageCategories();
      await userRepo.getGroupCategories();
    }catch(e){
      debugPrint(e.toString());
    }
    //await userRepo.getFriends();

    //await userRepo.getFriendSuggestions();

    //await userRepo.getGroups();
    //await userRepo.getSuggestedGroups();
    //await userRepo.getSuggestedPages();
    //await userRepo.getEventsToAttend();
    //await userRepo.getAllProducts();
    //await userRepo.getMyProducts();
    //await userRepo.getAllNotifications();
    //await userRepo.getAccountNumber();

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