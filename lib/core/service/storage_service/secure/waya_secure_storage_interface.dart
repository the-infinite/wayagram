import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wayagram/core/service/storage_service/storage_interface.dart';

abstract class WayaSecureStorageInterface implements StorageInterface {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> writeData({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  Future<dynamic> readData({required String key}) async {
    return await storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await storage.deleteAll();
  }

  @override
  Future<dynamic> readAll({required Map<String, String> values}) async {
    Map<String, String> allValues = await storage.readAll();
    values.addAll(allValues);
  }
}
