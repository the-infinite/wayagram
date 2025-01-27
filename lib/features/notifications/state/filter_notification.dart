import 'package:flutter/material.dart';

class FilterNotificationState {
  final TextEditingController controller;
  final bool isApplied;
  final bool showWalletNotifications;
  final bool showMarketplaceNotifications;
  final bool showQuotationNotifications;
  final bool showDonationNotifications;
  final bool showEventsNotifications;
  final bool showUgtNotifications;
  final bool showPollingAndVotingNotifications;

  // This is fine.
  FilterNotificationState({
    required this.isApplied,
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
    final bool? isApplied,
    final bool? showMarketplaceNotifications,
    final bool? showWalletNotifications,
    final bool? showQuotationNotifications,
    final bool? showDonationNotifications,
    final bool? showEventsNotifications,
    final bool? showUgtNotifications,
    final bool? showPollingAndVotingNotifications,
  }) {
    return FilterNotificationState(
      isApplied: isApplied ?? this.isApplied,
      controller: controller,
      showWalletNotifications: showWalletNotifications ?? this.showWalletNotifications,
      showMarketplaceNotifications: showMarketplaceNotifications ?? this.showMarketplaceNotifications,
      showQuotationNotifications: showQuotationNotifications ?? this.showQuotationNotifications,
      showDonationNotifications: showDonationNotifications ?? this.showDonationNotifications,
      showEventsNotifications: showEventsNotifications ?? this.showEventsNotifications,
      showUgtNotifications: showUgtNotifications ?? this.showUgtNotifications,
      showPollingAndVotingNotifications: showPollingAndVotingNotifications ?? this.showPollingAndVotingNotifications,
    );
  }

  /// This is the default state of the filter object.
  static final initial = FilterNotificationState(
    isApplied: false,
    controller: TextEditingController(),
    showWalletNotifications: false,
    showMarketplaceNotifications: false,
    showQuotationNotifications: false,
    showDonationNotifications: false,
    showEventsNotifications: false,
    showUgtNotifications: false,
    showPollingAndVotingNotifications: false,
  );
}
