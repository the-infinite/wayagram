import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/notifications/vm/notification_vm.dart';

part 'set_notification_vm.g.dart';

class States {
  final bool isLoading;

  States({this.isLoading = false});

  States copyWith({bool? isLoading}) {
    return States(isLoading: isLoading ?? this.isLoading);
  }
}

@riverpod
class SetNotification extends _$SetNotification {
  @override
  States build() {
    return States();
  }

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
      WayaNav.toNamed(SelectInterest.route);
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
