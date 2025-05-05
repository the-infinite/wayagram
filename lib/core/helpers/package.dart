import 'package:package_info_plus/package_info_plus.dart';

class PackageData {
  static PackageInfo? _info;
  static PackageInfo get info => _info!;

  static Future<PackageInfo> get getAndLoad async {
    _info ??= await PackageInfo.fromPlatform();
    return _info!;
  }
}
