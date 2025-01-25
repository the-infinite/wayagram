import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/features/general_settings/notifications/vm/default.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  static const route = "/settings/notifications";

  // Then this is fine.
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final state = ref.watch(notificationSettingsProvider);
    final notifier = ref.watch(notificationSettingsProvider.notifier);

    // Now, the widget itself.
    return WayaScaffold(
      isLoading: state.isLoading,
      isScrollable: false,
      progressIndicator: Material(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      title: 'Notification Settings',
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [],
        ),
      ),
    );
  }
}
