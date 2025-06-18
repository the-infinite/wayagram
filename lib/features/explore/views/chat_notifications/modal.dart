import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/explore/vm/social_notifications.dart';
import 'package:wayagram/features/notifications/vm/default.dart';
import 'package:wayagram/features/notifications/widgets/filter_button.dart';

class SocialFilterOverlayController {
  OverlayEntry? _entry;
  void Function()? _callback;
  final WidgetRef _ref;
  final _showLikes = ValueNotifier(false);
  final _showComments = ValueNotifier(false);
  final _showFollowRequests = ValueNotifier(false);
  final _showLivestream = ValueNotifier(false);
  final _showGroupInvite = ValueNotifier(false);
  final _showCalls = ValueNotifier(false);
  final _showShares = ValueNotifier(false);
  final _showView = ValueNotifier(false);
  final _showEvent = ValueNotifier(false);
  final _showPoll = ValueNotifier(false);

  /// Construct a new overlay controller with only one purpose.
  SocialFilterOverlayController(this._ref);

  /// Return the current overlay entry that this popup is listening for.
  OverlayEntry get entry => _entry!;

  /// Retrieve the filter value for the event notifications.
  bool get showEvent => _showEvent.value;

  /// Retrieve the filter value for the wallet notifications.
  bool get showPoll => _showPoll.value;

  /// Retrieve the filter value for like notifications.
  bool get showLikes => _showLikes.value;

  /// Retrieve the filter value for comment notifications.
  bool get showComments => _showComments.value;

  /// Retrieve the filter value for follow request notifications.
  bool get showFollowRequests => _showFollowRequests.value;

  /// Retrieve the filter value for livestream notifications.
  bool get showLivestream => _showLivestream.value;

  /// Retrieve the filter value for group invite notifications.
  bool get showGroupInvite => _showGroupInvite.value;

  /// Retrieve the filter value for call notifications.
  bool get showCalls => _showCalls.value;

  /// Retrieve the filter value for share notifications.
  bool get showShares => _showShares.value;

  /// Retrieve the filter value for view notifications.
  bool get showView => _showView.value;

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
    if (_entry != null) {
      entry.remove();
      entry.dispose();
    }
    _entry = null;
    _callback?.call();
  }

  /// Then the functions used to toggle event notifications.
  void setEvent(bool value) {
    _showEvent.value = value;
  }

  /// Then the functions used to toggle poll notifications.
  void setPoll(bool value) {
    _showPoll.value = value;
  }

  /// Then the functions used to toggle like notifications.
  void setLikes(bool value) {
    _showLikes.value = value;
  }

  /// Then the functions used to toggle comment notifications.
  void setComments(bool value) {
    _showComments.value = value;
  }

  /// Then the functions used to toggle follow request notifications.
  void setFollowRequests(bool value) {
    _showFollowRequests.value = value;
  }

  /// Then the functions used to toggle livestream notifications.
  void setLivestream(bool value) {
    _showLivestream.value = value;
  }

  /// Then the functions used to toggle group invite notifications.
  void setGroupInvite(bool value) {
    _showGroupInvite.value = value;
  }

  /// Then the functions used to toggle call notifications.
  void setCalls(bool value) {
    _showCalls.value = value;
  }

  /// Then the functions used to toggle share notifications.
  void setShares(bool value) {
    _showShares.value = value;
  }

  /// Then the functions used to toggle view notifications.
  void setView(bool value) {
    _showView.value = value;
  }

  /// Controller utility used to help update the notification filter by directly
  /// updating the value of its filter state.
  void apply() {
    final notifier = _ref.read(socialNotificationProvider.notifier);
    notifier.setFilters(
      notifier.currentState.filters.copyWith(
        isApplied: true,
        showPolls: showPoll,
        showEvents: showEvent,
        showLikes: showLikes,
        showComments: showComments,
        showFollowRequests: showFollowRequests,
        showLivestream: showLivestream,
        showGroupInvite: showGroupInvite,
        showCalls: showCalls,
        showShares: showShares,
        showView: showView,
      ),
    );
    close();
  }

  /// Controller utility used to help update the notification filter by removing
  /// the filters applied absolutely.
  void clear() {
    final notifier = _ref.read(socialNotificationProvider.notifier);
    notifier.clearFilters();
    close();

    // Now, disable these values again.
    setLikes(false);
    setComments(false);
    setFollowRequests(false);
    setLivestream(false);
    setGroupInvite(false);
    setCalls(false);
    setShares(false);
    setView(false);
    setEvent(false);
    setPoll(false);
  }
}

class SocialFilterModal extends StatelessWidget {
  final SocialFilterOverlayController controller;

  // This is the new filter modal's constructor.
  const SocialFilterModal(this.controller, {super.key});

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
          padding: const EdgeInsets.symmetric(vertical: 15),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Filter",
                  style: WayaTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Choose a filter",
                  style: WayaTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: WayaColors.greyColor600,
                  ),
                ),
              ),

              // Some space.
              const Gap(5),

              //? For the preliminary filters.
              FilterToggleButton(
                name: "Event Notifications",
                controller: controller._showEvent,
                isFiltering: isFiltering,
              ),
              //? For the preliminary filters.
              FilterToggleButton(
                name: "Poll Notifications",
                controller: controller._showPoll,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Like Notifications",
                controller: controller._showLikes,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Comment Notifications",
                controller: controller._showComments,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Follow Requests",
                controller: controller._showFollowRequests,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Livestream Notifications",
                controller: controller._showLivestream,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Group Invitations",
                controller: controller._showGroupInvite,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Call Notifications",
                controller: controller._showCalls,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "Share Notifications",
                controller: controller._showShares,
                isFiltering: isFiltering,
              ),
              FilterToggleButton(
                name: "View Notifications",
                controller: controller._showView,
                isFiltering: isFiltering,
              ),

              // Now, do it like this.
              const Gap(20),

              //* Now for the buttons that would be used to accept or reject
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Accept invite button.
                    Expanded(
                      child: WayaButton(
                        text: "Apply",
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
                        text: "Clear",
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
