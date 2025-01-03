import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wayagram/core/service/storage_service/storage_interface.dart';

 class WayaSecureStorageService  {
  final FlutterSecureStorage storage = FlutterSecureStorage();



  Future<void> write<T>({required String key, required T value}) async {
    await storage.write(key: key, value: value.toString());
  }


Future<String?> read<T>({required String key}) async {
    return await storage.read(key: key);
  }


  Future<void> delete({required String key}) async {
    await storage.delete(key: key);
  }


  Future<void> deleteAll() async {
    await storage.deleteAll();
  }

  Future<dynamic> readAll({required Map<String, String> values}) async {
    Map<String, String> allValues = await storage.readAll();
    values.addAll(allValues);
  }
}
