import 'package:get_storage/get_storage.dart';
import 'package:wayagram/core/service/storage_service/storage_interface.dart';

class WayaFastStorageService implements StorageInterface {
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
  read<T>({required String key}) {
    return box.read(key);
  }

  @override
  Future<void> write<T>({required String key, required T value}) async {
    box.write(key, value);
  }

  @override
  Future<void> readAll({required Map<String, String> values}) {
    return box.getValues();
  }
}
