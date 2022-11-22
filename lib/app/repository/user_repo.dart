import 'dart:convert';

import 'package:wayagram/app/data/model/account_model_entity.dart';
import 'package:wayagram/app/data/model/blocked_accounts_entity.dart';
import 'package:wayagram/app/data/model/followers_model_entity.dart';
import 'package:wayagram/app/data/model/following_model_entity.dart';
import 'package:wayagram/app/data/model/full_user_profile_entity.dart';

import '../data/model/all_events_entity.dart';
import '../data/model/all_posts_entity.dart';
import '../data/model/friends_model_entity.dart';
import '../data/model/friends_suggestions_entity.dart';
import '../data/model/group_model_entity.dart';
import '../data/model/log_in_model_entity.dart';
import '../data/model/moments_model_entity.dart';
import '../data/model/notification_model_entity.dart';
import '../data/model/page_categories_model.dart';
import '../data/model/posts_model_entity.dart';
import '../data/model/products_model_entity.dart';
import '../data/model/profile_model_entity.dart';
import '../data/providers/api.dart';
import '../data/providers/api_response.dart';
import '../data/providers/my_pref.dart';

class UserRepository {
  final Api api;

  UserRepository(this.api);

  //Authentication
  Future<ApiResponse> signUpCorporate(dynamic body) async {
    final response = await api.postData('/auth-service/api/v1/auth/create-corporate', body: body,sso: false);
    return response;
  }
  Future<ApiResponse> signUpNormalUser(dynamic body) async {
    final response = await api.postData('/auth-service/api/v1/auth/create', body: body,sso: false);
    return response;
  }
  Future<ApiResponse> signIn(dynamic body) async {
    final response = await api.postData('/auth-service/api/v1/auth/login', body: body,sso: false);
    if(response.isSuccessful){
      response.data = LogInModelEntity.fromJson(response.data);
    }
    return response;
  }
  Future<ApiResponse> resendAuthOTP(dynamic emailOrPhone) async {
    final response = await api.getData('/auth-service/api/v1/auth/resend-otp/signup/${emailOrPhone.toString()}',sso: false);
    return response;
  }
  Future<ApiResponse> verifyOTP(dynamic body) async {
    final response = await api.postData('/auth-service/api/v1/auth/verify-otp', body: body,sso: false);
    return response;
  }
  Future<ApiResponse> createPIN(dynamic body) async {
    final response = await api.postData('/auth-service/api/v1/auth/create/passcode', body: body,hasHeader: true);
    return response;
  }

  //Profile,Friends,Accounts and Connections
  /*Future<ApiResponse> getUserProfile(String userID) async {
    final response = await api.getData('/auth-service/api/v1/profile/$userID',hasHeader: true,sso: false);
    if(response.isSuccessful){
      response.data = ProfileModelEntity.fromJson(response.data);
      MyPref.userProfile.val = jsonEncode(response.data);
    }
    await getFullUserProfile(userID);
    return response;
  }*/
  Future<ApiResponse> getFullUserProfile(String userID) async {
    final response = await api.getData('/wayagram-service/main/profile/get-by-user-id?user_id=$userID',hasHeader: true);
    if(response.isSuccessful){
      response.data = FullUserProfileEntity.fromJson(response.data);
      MyPref.fullProfile.val = jsonEncode(response.data);
    }
    getFollowedByWayaOfficial();
    return response;
  }
  Future<ApiResponse> getFollowedByWayaOfficial() async {
    //var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    var body = {
      "user_id": profile.userId.toString()
    };
    final response = await api.postData(
        '/wayagram-service/graph/friend/waya-auto-follow',
        hasHeader: true,
        body: body
    );
    return response;
  }
  Future<ApiResponse> getFriends() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/graph/friend?user_id=${profile.userId}',hasHeader: true);
    if(response.isSuccessful){
      response.data = FriendsModelEntity.fromJson(response.data);
      MyPref.friends.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getAccountNumber() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    print(profile.userId);
    final response = await api.getData('/account-service/account/getAccounts/${profile.userId}',hasHeader: true);
    print(response.message);
    if(response.isSuccessful){
      response.data = AccountModelEntity.fromJson(response.data);
      MyPref.account.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getRestrictedAccount() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/graph/friend/get-all-restricted-accounts?user_id=${profile.userId}',hasHeader: true);
    if(response.isSuccessful){
      response.data = BlockedAccountsEntity.getService(response.data);
      MyPref.restrictedAccounts.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getMutedAccount() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/graph/friend/get-all-muted-accounts?user_id=${profile.userId}',hasHeader: true);
    if(response.isSuccessful){
      response.data = BlockedAccountsEntity.getService(response.data);
      MyPref.mutedAccounts.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getFollowers() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/graph/friend/followers?user_id=${profile.userId}',hasHeader: true);
    if(response.isSuccessful){
      response.data = FollowersModelEntity.fromJson(response.data);
      MyPref.followers.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getFollowing({int page = 1}) async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=$page',hasHeader: true);
    if(response.isSuccessful){
      if(page == 1){
        response.data = FollowingModelEntity.fromJson(response.data);
        MyPref.following.val = jsonEncode(response.data);
        await getFollowing(page: page+1);
      }else{
        var newData = FollowingModelEntity.fromJson(response.data);
        var oldData = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
        if(newData.following != null){
          if(newData.following!.isNotEmpty){
            await Future.forEach(newData.following!, (element){
              if(!(oldData.following!.contains(element as FollowingModelFollowing))){
                oldData.following?.add(element);
              }
            });
            response.data = oldData;
            MyPref.following.val = jsonEncode(response.data);
            await getFollowing(page: page+1);
          }else{
            response.data = oldData;
            MyPref.following.val = jsonEncode(response.data);
          }
        }else{
          response.data = oldData;
          MyPref.following.val = jsonEncode(response.data);
        }
      }
    }
    return response;
  }
  Future<ApiResponse> getFriendSuggestions() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/graph/friend/suggestions?user_id=${profile.userId}',hasHeader: true);
    if(response.isSuccessful){
      response.data = FriendsSuggestionsEntity.getService(response.profiles);
      MyPref.friendSuggestions.val = jsonEncode(response.profiles);
    }
    return response;
  }

  Future<ApiResponse> updateProfile(dynamic body) async {
    final response = await api.putData('/wayagram-service/main/profile/update',hasHeader: true,body: body);
    return response;
  }
  Future<ApiResponse> postData(String url,dynamic body,{hasHeader = true,sso = true}) async {
    final response = await api.postData(url,hasHeader: hasHeader,sso: sso,body: body);
    return response;
  }
  Future<ApiResponse> getData(String url,{hasHeader = true,sso = true}) async {
    final response = await api.getData(url,hasHeader: hasHeader,sso: sso);
    return response;
  }
  Future<ApiResponse> putData(String url,dynamic body,{hasHeader = true,sso = true}) async {
    final response = await api.putData(url,hasHeader: hasHeader,sso: sso,body: body);
    return response;
  }
  //Not Done Yet
  Future<ApiResponse> getFriendRequests() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/graph/friend/requests?user_id=${profile.userId}',hasHeader: true);
    if(response.isSuccessful){
      response.data = ProfileModelEntity.fromJson(response.data);
      MyPref.friendRequests.val = jsonEncode(response.data);
    }
    return response;
  }

  //Home - Home
  Future<ApiResponse> getMoments() async {
    final response = await api.getData('/wayagram-service/all-posts/moments?page=1&limit=40',hasHeader: true);
    //print(response.data['data'][0]['Profile']);
    if (response.isSuccessful) {
      response.data = MomentsModelEntity.getService(response.data['data']);
      MyPref.moments.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getPosts() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/all-posts/feed?profile_id=${profile.id}&page=1&limit=40',hasHeader: true);
    if (response.isSuccessful) {
      //response.data = AllPostsEntity.getService(response.data['data']);
      var newData = AllPostsEntity.getService(response.data['data']);
      if(MyPref.posts.val.isNotEmpty){
        var oldData = AllPostsEntity.getService(jsonDecode(MyPref.posts.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.data = newData;
      MyPref.posts.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getBookmarks() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/all-posts/get-user-bookmarks?profileId=${profile.id}&page=1&limit=40',hasHeader: true);
    if (response.isSuccessful) {
      var newData = AllPostsEntity.getServiceForBookmarks(response.data['data']);
      if(MyPref.bookmarks.val.isNotEmpty){
        var oldData = AllPostsEntity.getService(jsonDecode(MyPref.bookmarks.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.data = newData;
      MyPref.bookmarks.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getTopClips() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/all-posts/get-top-clips?profile_id=${profile.id}&page=1&limit=40',hasHeader: true);
    if (response.isSuccessful) {
      //response.data = AllPostsEntity.getService(response.data['data']);
      var newData = AllPostsEntity.getService(response.data['data']);
      if(MyPref.topClips.val.isNotEmpty){
        var oldData = AllPostsEntity.getService(jsonDecode(MyPref.posts.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.data = newData;
      MyPref.topClips.val = jsonEncode(response.data);
    }
    return response;
  }

  //Home - Discover
  Future<ApiResponse> getGroups() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/main/group/get-all-groups?pageNumber=1&userId=${profile.id}',hasHeader: true);
    if (response.isSuccessful) {
      //response.data = AllPostsEntity.getService(response.data['data']);
      var newData = AllPostsEntity.getService(response.data['data']);
      if(MyPref.posts.val.isNotEmpty){
        var oldData = AllPostsEntity.getService(jsonDecode(MyPref.posts.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.data = newData;
      MyPref.posts.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getSuggestedGroups() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/main/group/get-group-suggestion?userId=${profile.id}',hasHeader: true);
    if (response.isSuccessful) {
      var newData = GroupModelEntity.getService(response.suggestion);
      if(MyPref.suggestedGroups.val.isNotEmpty){
        var oldData = GroupModelEntity.getService(jsonDecode(MyPref.suggestedGroups.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.suggestion = newData;
      MyPref.suggestedGroups.val = jsonEncode(response.suggestion);
    }
    return response;
  }
  Future<ApiResponse> getGroupsCreated() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/main/group/get-all-user-created-groups?pageNumber=1&userId=${profile.id}',hasHeader: true);
    if (response.isSuccessful) {
      var newData = GroupModelEntity.getService(response.data);
      if(MyPref.groupsCreated.val.isNotEmpty){
        var oldData = GroupModelEntity.getService(jsonDecode(MyPref.groupsCreated.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.data = newData;
      MyPref.groupsCreated.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getGroupsFollowed() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/main/group/get-user-groups?pageNumber=1&userId=${profile.id}',hasHeader: true);
    if (response.isSuccessful) {
      var newData = GroupModelEntity.getService(response.data);
      if(MyPref.groupsFollowed.val.isNotEmpty){
        var oldData = GroupModelEntity.getService(jsonDecode(MyPref.groupsFollowed.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.data = newData;
      MyPref.groupsFollowed.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getGroupCategories() async {
    final response = await api.getData('/wayagram-service/main/group/get-all-groups-categories?page=1&limit=100',hasHeader: true);
    if (response.isSuccessful) {
      var newData = PageCategoriesModel.listFromJson(response.interests['data']);
      /*if(MyPref.groupCategories.val.isNotEmpty){
        var oldData = PageCategoriesModel.listFromJson(jsonDecode(MyPref.groupCategories.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }*/
      response.data = newData;
      MyPref.groupCategories.val = jsonEncode(response.data);
    }
    return response;
  }

  Future<ApiResponse> getSuggestedPages() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/main/page/get-page-suggestion?userId=${profile.id}',hasHeader: true);
    if (response.isSuccessful) {
      var newData = GroupModelEntity.getService(response.suggestion);
      if(MyPref.suggestedPages.val.isNotEmpty){
        var oldData = GroupModelEntity.getService(jsonDecode(MyPref.suggestedPages.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.suggestion = newData;
      MyPref.suggestedPages.val = jsonEncode(response.suggestion);
    }
    return response;
  }
  Future<ApiResponse> getPagesCreated() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/main/page/get-all-user-pages?userId=${profile.id}',hasHeader: true);
    if (response.isSuccessful) {
      var newData = GroupModelEntity.getService(response.data);
      if(MyPref.pagesCreated.val.isNotEmpty){
        var oldData = GroupModelEntity.getService(jsonDecode(MyPref.pagesCreated.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.data = newData;
      MyPref.pagesCreated.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getPagesFollowed() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/main/page/get-all-pages-a-user-follows?userId=${profile.id}&pageNumber=1',hasHeader: true);
    if (response.isSuccessful) {
      var newData = GroupModelEntity.getService(response.data);
      if(MyPref.pagesFollowed.val.isNotEmpty){
        var oldData = GroupModelEntity.getService(jsonDecode(MyPref.pagesFollowed.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }
      response.data = newData;
      MyPref.pagesFollowed.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getEventsToAttend() async {
    //var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/all-posts/get-all-events?page=1&limit=40',hasHeader: true);
    if (response.isSuccessful) {
      var newData = AllEventsEntity.fromJson(response.data);
      response.data = newData;
      MyPref.eventsToAttend.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getPageCategories() async {
    final response = await api.getData('/wayagram-service/main/page/get-all-page-categories?page=1&limit=10',hasHeader: true);
    if (response.isSuccessful) {
      var newData = PageCategoriesModel.listFromJson(response.interests['data']);
      /*if(MyPref.pageCategories.val.isNotEmpty){
        var oldData = PageCategoriesModel.listFromJson(jsonDecode(MyPref.pageCategories.val));
        for (var element in oldData) {
          if(!newData.contains(element)){
            newData.add(element);
          }
        }
      }*/
      response.data = newData;
      MyPref.pageCategories.val = jsonEncode(response.data);
    }
    return response;
  }

  //Home - Shops
  Future<ApiResponse> getAllProducts() async {
    //var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/all-posts/get-all-products',hasHeader: true);
    if (response.isSuccessful) {
      var newData = ProductsModelEntity.fromJson(response.data);
      response.data = newData;
      MyPref.allProducts.val = jsonEncode(response.data);
    }
    return response;
  }
  Future<ApiResponse> getMyProducts() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/all-posts/get-user-products?profile_id=${profile.id}',hasHeader: true);
    if (response.isSuccessful) {
      var newData = ProductsModelEntity.fromJson(response.data);
      response.data = newData;
      if(newData.data!.isEmpty){
        var allProd = MyPref.allProducts.val;
        if(allProd.isNotEmpty){
          var allProdData = ProductsModelEntity.fromJson(jsonDecode(allProd));
          for (var element in allProdData.data!) {
            if(element.profile!.userId == profile.userId){
              newData.data!.add(element);
            }
          }
        }
      }
      response.data = newData;
      MyPref.myProducts.val = jsonEncode(newData);
    }
    return response;
  }
  //NotificationModelEntity

  //Home - Notifications
  Future<ApiResponse> getAllNotifications() async {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    final response = await api.getData('/wayagram-service/notification/get-notifications-user?profile_id=${profile.id}',hasHeader: true);
    if (response.isSuccessful) {
      var newData = NotificationModelEntity.fromJson(response.data);
      response.data = newData;
      MyPref.notifications.val = jsonEncode(newData);
    }
    return response;
  }
}
