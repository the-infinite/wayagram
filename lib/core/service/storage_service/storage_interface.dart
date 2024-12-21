abstract class StorageInterface {
  Future<void> write({required String key, required String value});
  Future<dynamic> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
  Future<void> readAll({required Map<String, String> values});
}
