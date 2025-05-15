import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/local_data_source.dart';

import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';
import 'package:wayagram/features/notifications/vm/default.dart';

class States {
  final bool isLoading;

  States({this.isLoading = false});

  States copyWith({bool? isLoading}) {
    return States(isLoading: isLoading ?? this.isLoading);
  }
}

class SetNotificationVm extends StateNotifier<States> {
  final Ref ref;
  SetNotificationVm(this.ref) : super(States());

  Future<void> setNotification() async {
    //? This is fine.
    final notificationVm = ref.read(notificationProvider.notifier);

    try {
      state = state.copyWith(isLoading: true);
      //? If this has not yet generated any device tokens, send them across.
      final result = await notificationVm.sendDeviceToken();

      //? If this was fine...
      if (result) {
        WayaLocalDataSource().saveDeviceToken(WayaValueHelper.createUid());
      }
      // Before moving forward, try to retrieve the user's notifications.
      notificationVm.getUserNotifications();

      // final accountTypeState = ref.watch(selectAccountProvider);
      // if (accountTypeState.selectedType!.type == "PERSONAL") {
      //   WayaNav.toNamed('/account-setup-success');
      // } else {
      //   WayaNav.toNamed('/add-business-account');
      // }
       WayaNav.toNamed(SelectInterest.route);
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.notifications,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final setNotificationVmProvider =
    StateNotifierProvider<SetNotificationVm, States>((ref) {
  return SetNotificationVm(ref);
});
