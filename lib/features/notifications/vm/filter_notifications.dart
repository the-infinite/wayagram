import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/notifications/state/filter_notification.dart';

class FilterNotificationsNotifier extends StateNotifier<FilterNotificationState> {
  FilterNotificationsNotifier(super.state);
}

final notificationsFilterProvider = StateNotifierProvider<FilterNotificationsNotifier, FilterNotificationState>(
  (ref) {
    return FilterNotificationsNotifier(
      FilterNotificationState(
        controller: TextEditingController(),
        showWalletNotifications: true,
        showMarketplaceNotifications: true,
        showQuotationNotifications: true,
        showDonationNotifications: true,
        showEventsNotifications: true,
        showUgtNotifications: true,
        showPollingAndVotingNotifications: true,
      ),
    );
  },
);
