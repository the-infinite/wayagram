import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/notifications/vm/default.dart';
import 'package:wayagram/features/notifications/widgets/filter_button.dart';

class FilterOverlayController {
  OverlayEntry? _entry;
  void Function()? _callback;
  final WidgetRef _ref;
  final ValueNotifier<bool> _showMarketplace = ValueNotifier(false);
  final ValueNotifier<bool> _showQuotation = ValueNotifier(false);
  final ValueNotifier<bool> _showWallet = ValueNotifier(false);
  final ValueNotifier<bool> _showDonation = ValueNotifier(false);
  final ValueNotifier<bool> _showEvent = ValueNotifier(false);
  final ValueNotifier<bool> _showUgt = ValueNotifier(false);
  final ValueNotifier<bool> _showPoll = ValueNotifier(false);

  /// Construct a new overlay controller with only one purpose.
  FilterOverlayController(this._ref);

  /// Return the current overlay entry that this popup is listening for.
  OverlayEntry get entry => _entry!;

  /// Retrieve the filter value for the wallet notifications.
  bool get showWallet => _showWallet.value;

  /// Retrieve the filter value for the marketplace notifications.
  bool get showMarketplace => _showMarketplace.value;

  /// Retrieve the filter value for the quotation notifications.
  bool get showQuotation => _showQuotation.value;

  /// Retrieve the filter value for the donation notifications.
  bool get showDonation => _showDonation.value;

  /// Retrieve the filter value for the event notifications.
  bool get showEvent => _showEvent.value;

  /// Retrieve the filter value for the wallet notifications.
  bool get showUgt => _showUgt.value;

  /// Retrieve the filter value for the wallet notifications.
  bool get showPoll => _showPoll.value;

  /// Update the current overlay entry that this is listening in on.
  void setEntry(OverlayEntry entry) {
    _entry = entry;
  }

  /// Set the callback that is invoked whenever the filter overlay is closed (properly)
  void setCallback(void Function() callback) {
    _callback = callback;
  }

  /// Then to close this overlay controller.
  void close() {
    entry.remove();
    entry.dispose();
    _entry = null;
    _callback?.call();
  }

  /// Then the functions used to toggle wallet notifications.
  void setWallet(bool value) {
    _showWallet.value = value;
  }

  /// Then the functions used to toggle marketplace notifications.
  void setMarketplace(bool value) {
    _showMarketplace.value = value;
  }

  /// Then the functions used to toggle quotation notifications.
  void setQuotation(bool value) {
    _showQuotation.value = value;
  }

  /// Then the functions used to toggle donation notifications.
  void setDonation(bool value) {
    _showDonation.value = value;
  }

  /// Then the functions used to toggle event notifications.
  void setEvent(bool value) {
    _showEvent.value = value;
  }

  /// Then the functions used to toggle University Got Talent notifications.
  void setUgt(bool value) {
    _showUgt.value = value;
  }

  /// Then the functions used to toggle poll notifications.
  void setPoll(bool value) {
    _showPoll.value = value;
  }

  /// Controller utility used to help update the notification filter by directly
  /// updating the value of its filter state.
  void apply() {
    final notifier = _ref.watch(notificationProvider.notifier);
    notifier.setFilters(
      notifier.currentState.filters.copyWith(
        isApplied: true,
        showWalletNotifications: showWallet,
        showMarketplaceNotifications: showMarketplace,
        showQuotationNotifications: showQuotation,
        showDonationNotifications: showDonation,
        showEventsNotifications: showEvent,
        showUgtNotifications: showUgt,
        showPollingAndVotingNotifications: showPoll,
      ),
    );
    close();
  }

  /// Controller utility used to help update the notification filter by removing
  /// the filters applied absolutely.
  void clear() {
    final notifier = _ref.watch(notificationProvider.notifier);
    notifier.clearFilters();
    close();
  }
}

class FilterModal extends StatelessWidget {
  final FilterOverlayController controller;

  // This is the new filter modal's constructor.
  const FilterModal(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    //? The user might close this page and cause this to go out of scope and
    //? this is the way to handle that. At that point in time the controller._ref
    //? property would be unusable. Therefore, this should be fool-proof.
    try {
      // The size of the screen.
      final size = MediaQuery.sizeOf(context);
      final notifier = controller._ref.read(notificationProvider.notifier);
      final isFiltering = notifier.currentState.filters.isApplied;

      // Build the actual thing.
      return Material(
        child: Container(
          width: size.width * 0.75,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WayaColors.transparent,
            border: Border.all(width: 1, color: WayaColors.greyColor300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? First, text that is and corresponds to the titles of this section.
              Text(
                "Filter",
                style: WayaTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Choose a filter",
                style: WayaTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: WayaColors.greyColor600,
                ),
              ),

              // Some space.
              const Gap(5),

              //? For the preliminary filters.
              FilterToggleButton(
                name: "Wallet Notifications",
                controller: controller._showWallet,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Marketplace Notifications",
                controller: controller._showMarketplace,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Quotation Notifications",
                controller: controller._showQuotation,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Donation Notifications",
                controller: controller._showDonation,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Event Notifications",
                controller: controller._showEvent,
                isFiltering: isFiltering,
              ),

              // Some space.
              const Gap(5),

              //? First, text that is and corresponds to the titles of this section.
              Text(
                "Voting and UGT",
                style: WayaTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Choose a filter",
                style: WayaTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: WayaColors.greyColor600,
                ),
              ),

              //? For the notifications with a high degree of specificity
              FilterToggleButton(
                name: "UGT Notifications",
                controller: controller._showUgt,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Poll and Voting Notifications",
                controller: controller._showPoll,
                isFiltering: isFiltering,
              ),

              // Now, do it like this.
              const Gap(20),

              //* Now for the buttons that would be used to accept or reject
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Accept invite button.
                  Expanded(
                    child: WayaButton(
                      text: "Apply filters",
                      textColor: WayaColors.white,
                      callback: controller.apply,
                      color: WayaColors.primary500,
                      height: null,
                      verticalPadding: 8,
                      horizontalPadding: 12,
                    ),
                  ),

                  // Some space.
                  const Gap(10),

                  // Accept invite button.
                  Expanded(
                    child: WayaButton(
                      text: "Clear filters",
                      textColor: WayaColors.customBlack,
                      callback: controller.clear,
                      color: WayaColors.transparent,
                      height: null,
                      verticalPadding: 8,
                      horizontalPadding: 12,
                      border: Border.all(
                        color: WayaColors.greyColor500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      controller.close();
      return const SizedBox();
    }
  }
}
