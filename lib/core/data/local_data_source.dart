import 'dart:convert';

import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/service/storage_service/fast_storage/waya_fast_storage_interface.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/shared/engagement/model/default.dart';

class WayaLocalDataSource {
  final wayaFastStorageService = WayaFastStorageService();
  static final instance = WayaLocalDataSource._();
  WayaLocalDataSource._();

  //? Singleton without you knowing.
  factory WayaLocalDataSource() => instance;

  Future<void> saveThemeModeBoolean(bool isDark) {
    return wayaFastStorageService.write<bool>(key: 'isDark', value: isDark);
  }

  bool? getCurrentThemeMode() {
    return wayaFastStorageService.read<bool?>(key: 'isDark');
  }

  Future<void> saveUser(UserAccountData user) {
    return wayaFastStorageService.write(key: 'user', value: user);
  }

  UserAccountData getUser() {
    return wayaFastStorageService.read(key: 'user');
  }

  Future<void> saveUserId(dynamic user) {
    return wayaFastStorageService.write(key: 'userId', value: user);
  }

  dynamic getUserId() {
    return wayaFastStorageService.read(key: 'userId');
  }

  Future<void> saveToken(dynamic user) {
    return wayaFastStorageService.write(key: 'token', value: user);
  }

  dynamic getToken() {
    return wayaFastStorageService.read(key: 'token');
  }

  Future<void> saveBusiness(BusinessAccountData user) {
    return wayaFastStorageService.write(key: 'business', value: user);
  }

  BusinessAccountData getBusiness() {
    return wayaFastStorageService.read(key: 'business');
  }

  Future<void> saveSelectedBusinessType(Select biz) {
    return wayaFastStorageService.write<Select>(key: 'bizType', value: biz);
  }

  Future<void> saveDeviceToken(String token) {
    return wayaFastStorageService.write<String>(
        key: 'isFCMTokenFine', value: token.substring(0, 4));
  }

  bool getIsFcmTokenFine() {
    return wayaFastStorageService.read(key: 'isFCMTokenFine') != null;
  }

  Select getSelectedBusinessType() {
    return wayaFastStorageService.read(key: 'bizType');
  }

  Future<void> saveSearchHistory(List<String> history) {
    return wayaFastStorageService.write<List<String>>(
        key: 'search-history', value: history);
  }

  List<String>? getSearchHistory() {
    return wayaFastStorageService
        .read<List<dynamic>?>(key: 'search-history')
        ?.map((item) => item.toString())
        .toList();
  }

  Future<void> saveViewedMoments(List<String> history) {
    return wayaFastStorageService.write<List<String>>(
        key: 'viewed-moments', value: history);
  }

  List<String>? getViewedMoments() {
    return wayaFastStorageService
        .read<List<dynamic>?>(key: 'viewed-moments')
        ?.map((item) => item.toString())
        .toList();
  }

  Future<void> saveLastUpdateUserName(DateTime date) {
    return wayaFastStorageService.write<DateTime>(
        key: 'last-update-username', value: date);
  }

  Future<void> saveLastUpdateDisplayName(DateTime date) {
    return wayaFastStorageService.write<DateTime>(
        key: 'last-update-displayname', value: date);
  }

  DateTime? getLastUpdateUserName() {
    return wayaFastStorageService.read<DateTime?>(key: 'last-update-username');
  }

  DateTime? getLastUpdateDisplayName() {
    return wayaFastStorageService.read<DateTime?>(
        key: 'last-update-displayname');

  }
    Future<void> saveSeenUGT(bool hasSeen) {
      return wayaFastStorageService.write<bool>(
          key: 'seen-ugt', value: hasSeen);
    }

    bool getSeenUGT() {
      return wayaFastStorageService.read<bool?>(key: 'seen-ugt') ?? false;
    }

    Future<void> viewMoment(String momentId) {
      final moments = getViewedMoments() ?? <String>[];
      if (!moments.contains(momentId)) {
        moments.add(momentId);
      }
      return saveViewedMoments(moments);
    }

    Future<void> removeViewedMoments(int index) {
      final moments = getSearchHistory() ?? <String>[];
      if (index < moments.length && index >= 0) {
        moments.removeAt(index);
      }
      return saveViewedMoments(moments);
    }

    Future<void> addSearchToHistory(String search) {
      if (search.length < 3) return Future.value(null);
      final history = getSearchHistory() ?? <String>[];
      history.add(search);
      return saveSearchHistory(history);
    }

    Future<void> removeFromSearchHistory(int index) {
      final history = getSearchHistory() ?? <String>[];
      if (index < history.length && index >= 0) {
        history.removeAt(index);
      }
      return saveSearchHistory(history);
    }

    Future<void> saveEngagementData(
        Map<ServiceType, EngagementData> data) async {
      final jsonData = jsonEncode(
          data.map((key, value) => MapEntry(key.name, value.toJson())));
      await wayaFastStorageService.write<String>(
          key: 'engagementData', value: jsonData);
    }

    Future<Map<ServiceType, EngagementData>> getEngagementData() async {
      final jsonData =
          wayaFastStorageService.read<String?>(key: 'engagementData');

      if (jsonData == null) {
        return {
          for (var service in ServiceType.values) service: EngagementData()
        };
      }

      final Map<String, dynamic> decodedData = jsonDecode(jsonData);
      return decodedData.map(
        (key, value) => MapEntry(
          ServiceType.values.firstWhere((e) => e.name == key),
          EngagementData.fromJson(value),
        ),
      );
    }
  }
