import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/bottom_sheets/share/social_share.dart';
import 'package:wayagram/features/event/data/model/event_state.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/event/data/model/event_attendee_response_model.dart';
import 'package:wayagram/features/event/data/model/single_event_response_model.dart';
import 'package:wayagram/shared/engagement/provider/event_engagement_monitor.dart';

class EventVm extends StateNotifier<EventState> {
  final Ref ref;
  final WayaSecureDataSource _secureDataSource;
  final EventRepository _eventRepository;

  EventVm(this._secureDataSource, this._eventRepository, this.ref)
      : super(EventState());

  Future<void> getEvents() async {
    try {
      final response = await _eventRepository.getEvents();

      if (response.success) {
        print(response.data);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> joinedEvents() async {
    try {
      final userId = await _secureDataSource.getUserId();
      final response = await _eventRepository.eventsJoined(userId: userId!);

      if (response.success) {
        EventResponse eventResponse = EventResponse.fromJson(response.data);
        state = state.copyWith(joinedEvents: eventResponse.data.docs);
      }
    } catch (error) {
      print(error);
    }
  }

  // Future<void> fetchEventsWithStatus() async {
  //   try {
  //     state = state.copyWith(isLoadingEventWithStatus: true);
  //     final results = await Future.wait([
  //       getEventWithStatus(status: "upcoming"),
  //       getEventWithStatus(status: "past"),
  //     ]);
  //     print(results);
  //   } catch (error) {
  //     print("Error fetching events: $error");
  //   } finally {
  //     state = state.copyWith(isLoadingEventWithStatus: false);
  //   }
  // }

  Future<PaginatedResult<EventDoc>?> getEventWithStatus({required int page}) async {
    try {
      state = state.copyWith(isLoadingEventWithStatus: true);
      final response = await _eventRepository.getEventWithStatus(
          status: "upcoming", page: page);

      List<EventDoc> upcoming = [];
      bool hasNextPage = false;
      if (response.success) {
        EventResponse eventResponse = EventResponse.fromJson(response.data);
        upcoming = eventResponse.data.docs
            .where((event) =>
                event.privacyOption == 'public' &&
                event.eventStatus != 'paused')
            .toList();
        hasNextPage = eventResponse.data.hasNextPage;
        state = state.copyWith(upcomingEvents: upcoming);
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: upcoming);
    } catch (error) {
      print(error);
      return null;
    } finally {
      state = state.copyWith(isLoadingEventWithStatus: false);
    }
  }

  void getSingleEvent(EventDoc event) async {
    state = state.copyWith(singleEvent: event);
    final userId = await _secureDataSource.getUserId();
    state = state.copyWith(isUserEvent: event.userId == userId);
    //
  }

  Future<PaginatedResult<EventDoc>?> getUserEvents({required int page}) async {
    try {
      state = state.copyWith(isLoadingUserEvents: true);

      final userId = await _secureDataSource.getUserId();
      final response =
      await _eventRepository.getUserEvents(userId: userId!, page: page);
      List<EventDoc> myEvents = [];
      bool hasNextPage = false;
      if (response.success) {
        EventResponse eventResponse = EventResponse.fromJson(response.data);
        myEvents = eventResponse.data.docs;
        hasNextPage = eventResponse.data.hasNextPage;
        state = state.copyWith(myEvents: myEvents);
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: myEvents);
    } catch (error) {
      print(error);
      return null;
    } finally {
      state = state.copyWith(isLoadingUserEvents: false);
    }
  }

  Future<void> joinEvent(
      {required String eventId,
      required BuildContext context,
      required EventDoc event}) async {
    try {
      state = state.copyWith(isJoiningEvent: true);
      final userId = await _secureDataSource.getUserId();
      final response =
          await _eventRepository.joinEvent(userId: userId!, eventId: eventId);

      final provider = ref.read(eventEngagementProvider.notifier);

      provider.addLocation(event.location, EventPoint.joinEvent.value);
      provider.addEventType(event.eventType, EventPoint.joinEvent.value);
      if (response.success && context.mounted) {
         WayaNav.goBack();
     
        if (context.mounted) {
          WayaUtils.showNotice(
              context: context,
              secondButtonText: 'Explore more events',
              icon: Image.asset(
                WayaAssets.images.createEventSuccess.path,
                scale: 1.5,
              ),
              onPress: () {
                WayaNav.goBack();
              },
              buttonText: 'View Event Details',
              title: "You've successfully joined the event",
              message:
                  'Your spot is confirmed. Stay tuned for updates and get ready for an amazing experience',
              onCancel: () {
                WayaNav.toNamed(EventView.route);
              });
        }

        print(response.data);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isJoiningEvent: false);
    }
  }

  Future<void> reportEvent(
      {required String eventId,
      required String reason,
      String? comment,
      required BuildContext context}) async {
    try {
      state = state.copyWith(isReportingEvent: true);
      final userId = await _secureDataSource.getUserId();
      final response = await _eventRepository.reportEvent(
          userId: userId!, eventId: eventId, reason: reason);

      if (response.success && context.mounted) {
        // show success modal
         WayaNav.goBack();
       // Navigator.of(context).pop();

        if (context.mounted) {
          await WayaUtils.showNotice(
              context: context,
              title: "Thank you for reporting",
              onPress: () {
                WayaNav.replaceNamed(EventView.route);
              },
              icon: Image.asset(
                WayaAssets.images.eCheckEvent.path,
                scale: 1.5,
              ),
              message:
                  'Your report has been submitted. Our team will review the issue and take appropriate action.',
              buttonText: 'Go to Event Page');
        }
        print(response.data);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isReportingEvent: false);
    }
  }

  Future<PaginatedResult<Doc>?> getAttendees({required int page}) async {
    try {
      state = state.copyWith(isLoadingAttendees: true);
      final userId = await _secureDataSource.getUserId();
      state = state.copyWith(userId: userId);
      final response = await _eventRepository.joinedUsers(
          id: state.singleEvent!.id, page: page);
      List<Doc> attendees = [];
      bool hasNextPage = false;
      if (response.success) {
        AttendeeResponse attendeeResponse =
            AttendeeResponse.fromJson(response.data);

        attendees = attendeeResponse.data.docs;
        hasNextPage = attendeeResponse.data.hasNextPage;
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: attendees);
    } catch (error) {
      print(error);
      return null;
    } finally {
      state = state.copyWith(isLoadingAttendees: false);
    }
  }

  Future<void> fetchSingleEvent(String id) async {
    try {
      state = state.copyWith(isLoadingSingleEvent: true);
      final response = await _eventRepository.getSingleEvent(id);

      if (response.success) {
        SingleEventResponse singlEventResponse =
            SingleEventResponse.fromJson(response.data);

        state = state.copyWith(singleEvent: singlEventResponse.data);
        //print(response.data);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isLoadingSingleEvent: false);
    }
  }

  Future<void> follow(String userId) async {
    try {
      final response = await _eventRepository.follow(userId);

      if (response.success) {
        print(response.data);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> unfollow(String userId) async {
    try {
      final response = await _eventRepository.unfollow(userId);

      if (response.success) {
        print(response.data);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<FollowStatus?> getFollow(String userId) async {
    try {
      final response = await _eventRepository.getFollow(userId);
      FollowStatus? followStatus;
      if (response.success) {
        FollowStatusResponse followStatusResponse =
            FollowStatusResponse.fromJson(response.data);
        followStatus = followStatusResponse.data;
      }

      return followStatus;
    } catch (error) {
      print(error);
      return null;
    }
  }

  void shareEvent(
      {required BuildContext context, required String shareUrl}) async {
    if (context.mounted) {
      await WayaUtils.showModalSheet(context,
          child: ShareSheet(shareUrl: shareUrl));
    }
  }
}

final eventVmProvider = StateNotifierProvider<EventVm, EventState>((ref) {
  return EventVm(WayaSecureDataSource(), EventRepository(), ref);
});
