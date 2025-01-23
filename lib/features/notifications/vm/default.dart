import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/notifications/models/notification_response.dart';
import 'package:wayagram/features/notifications/repo/default.dart';
import 'package:wayagram/features/notifications/state/default.dart';
import 'package:wayagram/features/notifications/state/filter_notification.dart';

class NotificationVm extends StateNotifier<NotificationState> {
  final NotificationRepository _repo;
  // ignore: unused_field
  final Ref _ref;
  final Logger _logger;

  // This is fine.
  NotificationVm(
    this._repo,
    this._ref,
    this._logger,
    super.state,
  );

  /// Helper function used to get all notifications.
  Future<List<NotificationModel>> getUserNotifications() async {
    final result = <NotificationModel>[];

    //? First, notify this guy that we are loading.
    state = state.copyWith(isLoading: true);

    //? Now, try to get the notifications and fall back when failed.
    try {
      final response = await _repo.getUserNotifications();

      //? If this went well...
      if (response.success) {
        final data = NotificationResponseModel.fromJson(response.data['data']);
        result.addAll(data.data);
      }

      //? Since it failed, we should probably do failure cleanups in the future.
      else {}

      //? Notify our listeners that the game has been switched up.
      state = state.copyWith(isLoading: false, notifications: [...result]);
    } catch (e) {
      _logger.log(Level.error, e);
      state = state.copyWith(isLoading: false);
    }

    // Return this.
    return result;
  }

  /// Configure whether or not we are only looking at requests at the moment.
  /// This is an extremely local use-case so it probably should not even exist.
  void setIsRequestsOnly(bool value) {
    state = state.copyWith(requestsOnly: value);
  }
}

final notificationProvider = StateNotifierProvider<NotificationVm, NotificationState>(
  (ref) {
    return NotificationVm(
      NotificationRepository(),
      ref,
      getLogger("NotificationVm"),
      NotificationState(
        page: 1,
        totalSize: 24,
        requestsOnly: false,
        isLoading: false,
        searchQuery: "",
        filters: FilterNotificationState(
          controller: TextEditingController(),
          showWalletNotifications: true,
          showMarketplaceNotifications: true,
          showQuotationNotifications: true,
          showDonationNotifications: true,
          showEventsNotifications: true,
          showUgtNotifications: true,
          showPollingAndVotingNotifications: true,
        ),
        notifications: [
          //? Dummy notifications.
          NotificationModel(
            id: "notif-1",
            type: 'push',
            messageType: NotificationMessageType.transaction,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "Payment Received",
              body: "You have received ₦5,000 from XYZ Ltd.",
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: false,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-2",
            type: 'push',
            messageType: NotificationMessageType.follower,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Follower Alert",
              body: "John Doe started following you.",
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: false,
          ),

          // This is fine too.
          NotificationModel(
            id: "notif-3",
            type: 'push',
            messageType: NotificationMessageType.event,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "Upcoming Event: Webinar on UX Design",
              body: "Starts in 30 minutes",
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-4",
            type: 'push',
            messageType: NotificationMessageType.poll,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "The Results Are In!",
              body: "Your poll 'Favourite Design' has ended",
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: false,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-5",
            type: 'push',
            messageType: NotificationMessageType.chat,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Message from Jane",
              body: '"Hey are you available for a call?"',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-5",
            type: 'push',
            messageType: NotificationMessageType.chat,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Message from Jane",
              body: '"Hey are you available for a call?"',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-6",
            type: 'push',
            messageType: NotificationMessageType.comment,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Comment",
              body: 'Fasas Commented "Hey, are you available for a call?"',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-7",
            type: 'push',
            messageType: NotificationMessageType.donation,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Donation Received",
              body: 'You just received a new donation on "Help Sanni Walk Again"',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-8",
            type: 'push',
            messageType: NotificationMessageType.transaction,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "Debit Transaction",
              body: 'You spent ₦480 voting in a poll',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine
          NotificationModel(
            id: "notif-9",
            type: 'push',
            messageType: NotificationMessageType.transaction,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "Payment Received",
              body: "You have received ₦50,000 from Trevor Baker",
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-10",
            type: 'push',
            messageType: NotificationMessageType.follower,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Follower Alert",
              body: "Jane Fischer started following you.",
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine too.
          NotificationModel(
            id: "notif-11",
            type: 'push',
            messageType: NotificationMessageType.event,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "Upcoming Event: Waya Bank Launch",
              body: "Coming up in 11 days, be there!",
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-12",
            type: 'push',
            messageType: NotificationMessageType.poll,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "The Results Are In!",
              body: "Not bad. Your vote was the second most popular one in the poll.",
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-13",
            type: 'push',
            messageType: NotificationMessageType.chat,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Message from Jacob",
              body: '"Pick a time and place."',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-14",
            type: 'push',
            messageType: NotificationMessageType.chat,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Message from Jane",
              body: '"What\'s your take?"',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-15",
            type: 'push',
            messageType: NotificationMessageType.comment,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Comment",
              body: 'Archie commented "Nice shoes. Where did you get them?"',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-16",
            type: 'push',
            messageType: NotificationMessageType.transaction,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "Debit Transaction",
              body: 'You withdrew ₦8,000 from the bank',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-17",
            type: 'push',
            messageType: NotificationMessageType.donation,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Donation Received",
              body: 'You just received a new donation on "Help Sanni Walk Again"',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-18",
            type: 'push',
            messageType: NotificationMessageType.groupInvite,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "Group Team Invite",
              body: 'Collaborate as a team member on the "Empire Music" group',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-19",
            type: 'push',
            messageType: NotificationMessageType.friendRequest,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Friend Request",
              body: 'John Doe is asking to be your friend',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),

          // This is fine.
          NotificationModel(
            id: "notif-20",
            type: 'push',
            messageType: NotificationMessageType.followRequest,
            target: NotificationTarget(token: ""),
            message: NotificationMessage(
              subject: "New Follow Request",
              body: 'Samantha Higgins wants to follow you',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            read: true,
          ),
        ],
      ),
    );
  },
);
