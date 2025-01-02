import 'package:wayagram/core/service/storage_service/secure/waya_secure_storage_interface.dart';

class WayaSecureDataSource extends WayaSecureStorageService {
   final wayaSecureDataSource = WayaSecureStorageService();

  saveToken(String token) {
    return wayaSecureDataSource.write<String>(key: 'token', value: token);
  }

  saveRefreshToken(String token) {
    return wayaSecureDataSource.write<String>(
        key: 'refresh-token', value: token);
  }

  String? getToken() {
    return wayaSecureDataSource.read(key: 'token');
  }

  String? getRefreshToken() {
    return wayaSecureDataSource.read(key: 'refresh-token');
  }
}
