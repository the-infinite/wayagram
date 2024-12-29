import 'package:wayagram/core/service/storage_service/fast_storage/waya_fast_storage_interface.dart';
import 'package:wayagram/features/shop/cart/data/model.dart';

class WayaLocalDataSource {
  final wayaFastStorageService = WayaFastStorageService();

  saveThemeModeBoolean(bool isDark) {
    wayaFastStorageService.write<bool>(key: 'isDark', value: isDark);
  }

  bool? getCurrentThemeMode() {
    return wayaFastStorageService.read<bool?>(key: 'isDark');
  }

  saveUserType(String type) {
    wayaFastStorageService.write<String>(key: 'userType', value: type);
  }

  String getUserType() {
    return wayaFastStorageService.read(key: 'userType');
  }

  saveToCart(List<Cart> cart) {
    wayaFastStorageService.write<List<Cart>>(key: 'cart', value: cart);
  }

  List<Cart> getCart() {
    return wayaFastStorageService.read(key: 'cart');
  }
}
