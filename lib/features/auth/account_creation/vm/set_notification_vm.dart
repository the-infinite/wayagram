import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';

class SetNotificationVm extends ChangeNotifier {
  final Ref ref;
  SetNotificationVm(this.ref);
  final WayaLocalDataSource _localDataSource = WayaLocalDataSource();

  Future<void> setNotification() async {
    if (_localDataSource.getUserType() == "personal") {
      WayaNav.toNamed('/account-setup-success');
    } else {
      WayaNav.toNamed('/add-business-account');
    }
  }
}

final setNotificationVmProvider =
    ChangeNotifierProvider<SetNotificationVm>((ref) {
  return SetNotificationVm(ref);
});
