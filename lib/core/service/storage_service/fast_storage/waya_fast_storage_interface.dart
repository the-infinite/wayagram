import 'package:get_storage/get_storage.dart';
import 'package:wayagram/core/service/storage_service/storage_interface.dart';

abstract class WayaFastStorageInterface implements StorageInterface {
  final box = GetStorage();
  @override
  Future<void> delete({required String key}) async {
    await box.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    box.erase();
  }

  @override
  read({required String key}) {
    return box.read(key);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    box.write(key, value);
  }
}
