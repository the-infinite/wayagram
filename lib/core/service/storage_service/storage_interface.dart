abstract class StorageInterface {
  Future<void> write<T>({required String key, required T value});
  T read<T>({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
  Future<void> readAll({required Map<String, String> values});
}
