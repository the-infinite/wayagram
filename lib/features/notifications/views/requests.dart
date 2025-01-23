import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/notifications/vm/default.dart';

class RequestNotifications extends ConsumerWidget {
  const RequestNotifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notify = ref.watch(notificationProvider.notifier);

    // Return this one.
    return RefreshIndicator(
      onRefresh: () => notify.getUserNotifications(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            100,
            (index) => Text(
              "Text #$index",
              style: WayaTextStyles.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
