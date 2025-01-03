import 'package:wayagram/core/data/model.dart';
import 'package:wayagram/core/service/storage_service/fast_storage/waya_fast_storage_interface.dart';
import 'package:wayagram/features/auth/account_creation/data/select_account_data.dart';
import 'package:wayagram/features/shop/cart/data/model.dart';

class WayaLocalDataSource {
  final wayaFastStorageService = WayaFastStorageService();

  saveThemeModeBoolean(bool isDark) {
    wayaFastStorageService.write<bool>(key: 'isDark', value: isDark);
  }

  bool? getCurrentThemeMode() {
    return wayaFastStorageService.read<bool?>(key: 'isDark');
  }

  saveUserType(SelectAccountData type) {
    wayaFastStorageService.write<SelectAccountData>(key: 'userType', value: type);
  }

  SelectAccountData getUserType() {
    return wayaFastStorageService.read(key: 'userType');
  }

  saveToCart(List<Cart> cart) {
    wayaFastStorageService.write<List<Cart>>(key: 'cart', value: cart);
  }

  List<Cart> getCart() {
    return wayaFastStorageService.read(key: 'cart');
  }

  saveUser(dynamic user) {
    return wayaFastStorageService.write(key: 'user', value: user);
  }

  dynamic getUser() {
    return wayaFastStorageService.read(key: 'user');
  }

    saveBusiness(dynamic user) {
    return wayaFastStorageService.write(key: 'business', value: user);
  }

  dynamic getBusiness() {
    return wayaFastStorageService.read(key: 'business');
  }


  saveSelectedBusinessType(Select biz) {
    return wayaFastStorageService.write<Select>(key: 'bizType', value: biz);
  }

  Select getSelectedBusinessType() {
    return wayaFastStorageService.read(key: 'bizType');
  }



}
