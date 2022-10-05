import 'package:get_storage/get_storage.dart';

class MyPref  {
  static final _box = () => GetStorage('MyPref');

  static final userId = ReadWriteValue('userId', '', _box);
  static final authToken = ReadWriteValue('auth-token', '', _box);
  static final userDetail = ReadWriteValue('userProfile', '', _box);

  static Future<void> clearBoxes() async {
    await _box().erase();
  }
}

