import 'package:get_storage/get_storage.dart';
import 'package:wayagram/core/service/storage_service/storage_interface.dart';

class WayaFastStorageService implements StorageInterface {
  final box = GetStorage();
  bool _initialized = false;

  Future<void> ensureInitialized() async {
    try {
      if (!_initialized) {
        await box.initStorage;
        _initialized = true;
      }
    } catch (_) {}
  }

  @override
  Future<void> delete({required String key}) async {
    await ensureInitialized();
    await box.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    await ensureInitialized();
    box.erase();
  }

  @override
  read<T>({required String key}) {
    return box.read(key);
  }

  @override
  Future<void> write<T>({required String key, required T value}) async {
    await ensureInitialized();
    box.write(key, value);
  }

  @override
  Future<void> readAll({required Map<String, String> values}) async {
    await ensureInitialized();
    return box.getValues();
  }
}
