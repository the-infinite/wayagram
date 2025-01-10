import 'package:wayagram/core/service/storage_service/secure/waya_secure_storage_interface.dart';

class WayaSecureDataSource extends WayaSecureStorageService {
  final wayaSecureDataSource = WayaSecureStorageService();

  saveToken(String? token) async {
    return await wayaSecureDataSource.write<String?>(
        key: 'token', value: token);
  }

  saveRefreshToken(String? token) {
    return wayaSecureDataSource.write<String?>(
        key: 'refresh-token', value: token);
  }

  Future<String?> getToken() async {
    return await wayaSecureDataSource.read(key: 'token');
  }

  Future<String?> getRefreshToken() async {
    return wayaSecureDataSource.read(key: 'refresh-token');
  }

  saveUserId(String? user) {
    return wayaSecureDataSource.write(key: 'userId', value: user);
  }

  Future<String?> getUserId() {
    return wayaSecureDataSource.read(key: 'userId');
  }

  saveBusinessId(String? user) {
    return wayaSecureDataSource.write(key: 'businessId', value: user);
  }

  Future<String?> getBusinessId() {
    return wayaSecureDataSource.read(key: 'businessId');
  }
}
