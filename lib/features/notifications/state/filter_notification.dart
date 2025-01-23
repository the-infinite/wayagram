import 'package:flutter/material.dart';

class FilterNotificationState {
  final TextEditingController controller;
  final bool showWalletNotifications;
  final bool showMarketplaceNotifications;
  final bool showQuotationNotifications;
  final bool showDonationNotifications;
  final bool showEventsNotifications;
  final bool showUgtNotifications;
  final bool showPollingAndVotingNotifications;

  // This is fine.
  FilterNotificationState({
    required this.controller,
    required this.showWalletNotifications,
    required this.showMarketplaceNotifications,
    required this.showQuotationNotifications,
    required this.showDonationNotifications,
    required this.showEventsNotifications,
    required this.showUgtNotifications,
    required this.showPollingAndVotingNotifications,
  });

  // This is fine.
  FilterNotificationState copyWith({
    final bool? showMarketplaceNotifications,
    final bool? showQuotationNotifications,
    final bool? showDonationNotifications,
    final bool? showEventsNotifications,
    final bool? showUgtNotifications,
    final bool? showPollingAndVotingNotifications,
  }) {
    return FilterNotificationState(
      controller: controller,
      showWalletNotifications: showWalletNotifications,
      showMarketplaceNotifications: showMarketplaceNotifications ?? this.showMarketplaceNotifications,
      showQuotationNotifications: showQuotationNotifications ?? this.showQuotationNotifications,
      showDonationNotifications: showDonationNotifications ?? this.showDonationNotifications,
      showEventsNotifications: showEventsNotifications ?? this.showEventsNotifications,
      showUgtNotifications: showUgtNotifications ?? this.showUgtNotifications,
      showPollingAndVotingNotifications: showPollingAndVotingNotifications ?? this.showPollingAndVotingNotifications,
    );
  }
}
