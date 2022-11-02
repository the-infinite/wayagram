import 'package:get_storage/get_storage.dart';

class MyPref  {
  static final _box = () => GetStorage('MyPref');

  static final userId = ReadWriteValue('wayagram_userId', '', _box);
  static final authToken = ReadWriteValue('wayagram_auth-token', '', _box);
  static final logInDetail = ReadWriteValue('wayagram_logInDetail', '', _box);
  static final userProfile = ReadWriteValue('wayagram_userProfile', '', _box);
  static final fullProfile = ReadWriteValue('wayagram_full_profile', '', _box);
  static final account = ReadWriteValue('wayagram_account', '', _box);

  //home boxes
  static final posts = ReadWriteValue('wayagram_posts', '', _box);
  static final moments = ReadWriteValue('wayagram_moments', '', _box);
  static final groups = ReadWriteValue('wayagram_groups', '', _box);
  static final suggestedGroups = ReadWriteValue('wayagram_suggested_groups', '', _box);
  static final suggestedPages = ReadWriteValue('wayagram_suggested_pages', '', _box);
  static final eventsToAttend = ReadWriteValue('wayagram_events_to_attend', '', _box);
  static final allProducts = ReadWriteValue('wayagram_all_products', '', _box);
  static final myProducts = ReadWriteValue('wayagram_my_products', '', _box);
  static final notifications = ReadWriteValue('wayagram_notifications', '', _box);

  //friends boxes
  static final friends = ReadWriteValue('wayagram_friends', '', _box);
  static final restrictedAccounts = ReadWriteValue('wayagram_restricted_accounts', '', _box);
  static final mutedAccounts = ReadWriteValue('wayagram_muted_accounts', '', _box);
  static final followers = ReadWriteValue('wayagram_followers', '', _box);
  static final following = ReadWriteValue('wayagram_following', '', _box);
  static final friendSuggestions = ReadWriteValue('wayagram_friend_suggestion', '', _box);
  static final friendRequests = ReadWriteValue('wayagram_friend_request', '', _box);

  static Future<void> clearBoxes() async {
    await _box().erase();
  }
}

