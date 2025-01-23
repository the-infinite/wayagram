import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/notifications/vm/default.dart';
import 'package:wayagram/features/notifications/widgets/notification_widget.dart';

class AllNotifications extends ConsumerWidget {
  final List<NotificationModel> data;

  // Construct.
  const AllNotifications({
    super.key,
    required this.data,
  });

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
            data.length,
            (index) => NotificationCardWidget(
              index: index,
              data: data[index],
            ),
          ),
        ),
      ),
    );
  }
}
