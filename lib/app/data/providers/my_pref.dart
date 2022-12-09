import 'package:get_storage/get_storage.dart';

class MyPref  {
  static final box = () => GetStorage('MyPref');
  static final currentApp = ReadWriteValue('wayagram_current_app', "wayagram", box);
  static final anotherApp = ReadWriteValue('wayagram_another_app', false, box);

  static final uniqueID = ReadWriteValue('wayagram_unique_device_id', '', box);
  static final fcmID = ReadWriteValue('wayagram_fcm_id', '', box);

  static final userId = ReadWriteValue('wayagram_userId', '', box);
  static final profileId = ReadWriteValue('wayagram_profileId', '', box);
  static final authToken = ReadWriteValue('wayagram_auth-token', '', box);
  static final logInDetail = ReadWriteValue('wayagram_logInDetail', '', box);
  //static final userProfile = ReadWriteValue('wayagram_userProfile', '', box);
  static final fullProfile = ReadWriteValue('wayagram_full_profile', '', box);
  static final account = ReadWriteValue('wayagram_account', '', box);

  //home boxes
  static final posts = ReadWriteValue('wayagram_posts', '', box);
  static final bookmarks = ReadWriteValue('wayagram_bookmarks', '', box);
  static final topClips = ReadWriteValue('wayagram_top_clips', '', box);
  static final moments = ReadWriteValue('wayagram_moments', '', box);
  static final eventsToAttend = ReadWriteValue('wayagram_events_to_attend', '', box);
  static final createdEvents = ReadWriteValue('wayagram_created_events', '', box);
  static final allProducts = ReadWriteValue('wayagram_all_products', '', box);
  static final myProducts = ReadWriteValue('wayagram_my_products', '', box);
  static final notifications = ReadWriteValue('wayagram_notifications', '', box);

  //friends boxes
  static final friends = ReadWriteValue('wayagram_friends', '', box);
  static final restrictedAccounts = ReadWriteValue('wayagram_restricted_accounts', '', box);
  static final mutedAccounts = ReadWriteValue('wayagram_muted_accounts', '', box);
  static final followers = ReadWriteValue('wayagram_followers', '', box);
  static final following = ReadWriteValue('wayagram_following', '', box);
  static final friendSuggestions = ReadWriteValue('wayagram_friend_suggestion', '', box);
  static final friendRequests = ReadWriteValue('wayagram_friend_request', '', box);

  //Pages boxes
  static final suggestedPages = ReadWriteValue('wayagram_suggested_pages', '', box);
  static final pagesCreated = ReadWriteValue('wayagram_pages_created', '', box);
  static final pagesFollowed = ReadWriteValue('wayagram_pages_followed', '', box);
  static final pageCategories = ReadWriteValue('wayagram_page_categories', '', box);

  static final groups = ReadWriteValue('wayagram_groups', '', box);
  static final suggestedGroups = ReadWriteValue('wayagram_suggested_groups', '', box);
  static final groupsCreated = ReadWriteValue('wayagram_groups_created', '', box);
  static final groupsFollowed = ReadWriteValue('wayagram_groups_followed', '', box);
  static final groupCategories = ReadWriteValue('wayagram_group_categories', '', box);


  //Chats and Calls boxes
  static final chatOverView = ReadWriteValue('wayagram_chat_overview', '', box);
  static final callOverView = ReadWriteValue('wayagram_call_overview', '', box);
  
  static Future<void> clearBoxes() async {
    await box().erase();
  }
}

