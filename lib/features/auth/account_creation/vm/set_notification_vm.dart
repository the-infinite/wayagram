import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';

class SetNotificationVm extends StateNotifier<void> {
  final Ref ref;
  SetNotificationVm(this.ref) : super(null);

  Future<void> setNotification() async {
    final accountTypeState = ref.watch(selectAccountProvider);
    if (accountTypeState.selectedType!.type == "PERSONAL") {
      WayaNav.toNamed('/account-setup-success');
    } else {
      WayaNav.toNamed('/add-business-account');
    }
  }
}

final setNotificationVmProvider =
    StateNotifierProvider<SetNotificationVm, void>((ref) {
  return SetNotificationVm(ref);
});
