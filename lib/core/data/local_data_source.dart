import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/service/storage_service/fast_storage/waya_fast_storage_interface.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/account_creation/data/select_account_data.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

class WayaLocalDataSource {
  final wayaFastStorageService = WayaFastStorageService();

  saveThemeModeBoolean(bool isDark) {
    wayaFastStorageService.write<bool>(key: 'isDark', value: isDark);
  }

  bool? getCurrentThemeMode() {
    return wayaFastStorageService.read<bool?>(key: 'isDark');
  }

  saveUserType(SelectAccountData type) {
    wayaFastStorageService.write(key: 'userType', value: type.toJson());
  }

  SelectAccountData getUserType() {
    return SelectAccountData.fromJson(wayaFastStorageService.read(key: 'userType'));
  }

  saveUser(UserAccountData user) {
    return wayaFastStorageService.write(key: 'user', value: user);
  }

  UserAccountData getUser() {
    return wayaFastStorageService.read(key: 'user');
  }

  saveUserId(dynamic user) {
    return wayaFastStorageService.write(key: 'userId', value: user);
  }

  dynamic getUserId() {
    return wayaFastStorageService.read(key: 'userId');
  }

  savetoken(dynamic user) {
    return wayaFastStorageService.write(key: 'token', value: user);
  }

  dynamic gettoken() {
    return wayaFastStorageService.read(key: 'token');
  }

  saveBusiness(BusinessAccountData user) {
    return wayaFastStorageService.write(key: 'business', value: user);
  }

  BusinessAccountData getBusiness() {
    return wayaFastStorageService.read(key: 'business');
  }

  saveSelectedBusinessType(Select biz) {
    return wayaFastStorageService.write<Select>(key: 'bizType', value: biz);
  }

  saveDeviceToken(String token) {
    return wayaFastStorageService.write<String>(key: 'isFCMTokenFine', value: token.substring(0, 4));
  }

  bool getIsFcmTokenFine() {
    return wayaFastStorageService.read(key: 'isFCMTokenFine') != null;
  }

  Select getSelectedBusinessType() {
    return wayaFastStorageService.read(key: 'bizType');
  }

  saveSearchHistory(List<String> history) {
    return wayaFastStorageService.write<List<String>>(key: 'search-history', value: history);
  }

  List<String> getSearchHistory() {
    return wayaFastStorageService.read(key: 'search-history');
  }
}
