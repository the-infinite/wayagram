import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/bottom_sheets/share/social_share.dart';
import 'package:wayagram/features/event/data/model/event_state.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/event/data/model/event_attendee_response_model.dart';
import 'package:wayagram/features/event/data/model/single_event_response_model.dart';
import 'package:wayagram/shared/components/pin_entry_bottom_sheet.dart';
import 'package:wayagram/shared/engagement/provider/event_engagement_monitor.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

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
        debugPrint(response.data.toString());
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
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
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<PaginatedResult<EventDoc>?> getEventWithStatus(
      {required int page, int limit = 10}) async {
    try {
      state = state.copyWith(isLoadingEventWithStatus: true);
      final response = await _eventRepository.getEventWithStatus(
          status: "upcoming", page: page, limit: limit);

      List<EventDoc> upcoming = [];
      bool hasNextPage = false;
      if (response.success) {
        // final now = DateTime.now();
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
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
      return null;
    } finally {
      state = state.copyWith(isLoadingEventWithStatus: false);
    }
  }

  void clearSelectedInvitee() {
    state = state.copyWith(invitees: []);
  }

  void updateSelectedInvitee({required UserDetailsModel invitee}) {
    List<UserDetailsModel> users = List.from(state.invitees);

    final selectedIndex = users.indexWhere((i) => i.id == invitee.id);

    if (selectedIndex != -1) {
      users.removeAt(selectedIndex);
    } else {
      users.add(invitee);
    }
    state = state.copyWith(invitees: users);
  }

  Future<EventDoc?> getSingleEvent(String id) async {
    final event = await fetchSingleEvent(id);

    //? If this is fine.
    state =
        state.copyWith(isUserEvent: event?.userId == ConversationState.self.id);

    //? Return this.
    return event;
  }

  void clearSingle() {
    state = state.copyWith(
      singleEvent: null,
      isUserEvent: null,
      attendees: [],
    );
  }

  Future<PaginatedResult<EventDoc>?> getUserEvents({required int page}) async {
    try {
      state = state.copyWith(isLoadingUserEvents: true);

      final userId = await _secureDataSource.getUserId();
      final response =
          await _eventRepository.getUserEvents(userId: userId!, page: page);
      List<EventDoc> myEvents = [];
      bool hasNextPage = false;
      final now = DateTime.now();
      if (response.success) {
        EventResponse eventResponse = EventResponse.fromJson(response.data);
        myEvents = [
          ...eventResponse.data.docs
              .where((event) => !event.endDate.isBefore(now))
        ];
        hasNextPage = eventResponse.data.hasNextPage;
        state = state.copyWith(myEvents: myEvents);
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: myEvents);
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
      return null;
    } finally {
      state = state.copyWith(isLoadingUserEvents: false);
    }
  }

  Future<PaginatedResult<EventDoc>?> getJoinedEvents(
      {required int page}) async {
    try {
      // state = state.copyWith(isLoadingUserEvents: true);
      print("fewfewfwef b4");
      final response = await _eventRepository.eventsJoined(
          userId: ConversationState.self.id, page: page);
      List<EventDoc> myEvents = [];
      bool hasNextPage = false;
      print("fewfewfwef after b4 success");
      if (response.success) {
        // print("fewfewfwef after success ${response.data["data"]['docs']}");
        //  final data = response.data["data"]['docs'];

        //    print("vergergesdfsdfsfsdfsfd ${((response.data["data"]['docs'] as List).map((d) => d['eventDetails']).toList())}" );

        // JoinedEventResponse eventResponse =
        //     JoinedEventResponse.fromJson(response.data);
//
        final doeecs = (response.data["data"]['docs'] as List)
            .map((d) => EventDoc.fromJson(d['eventDetails']))
            .toList();
        print("dddd $doeecs");
        //     .map((doc) => EventDoc.fromJson(doc));

        // final docs =
        //     eventResponse.data.docs.map((c) => c.eventDetails).toList();

        // print("dddd $docs");
        myEvents = doeecs;

        hasNextPage = response.data["data"]['hasNextPage'];
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: myEvents);
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
      return null;
    } finally {
      // state = state.copyWith(isLoadingUserEvents: false);
    }
  }

  Future<void> joinEvent(
      {required String eventId,
      required BuildContext context,
      required EventDoc event}) async {
    try {
      state = state.copyWith(isJoiningEvent: true);
      final userId = await _secureDataSource.getUserId();

      //package:wayagram/shared/components/pin_entry_bottom_sheet.dart
      //
      if (context.mounted) {
        final result = await WayaUtils.showModalSheet(context,
            child: PinEntryBottomSheet());

        if (result == true && context.mounted) {
          final response = await _eventRepository.joinEvent(
              userId: userId!, eventId: eventId);

          final provider = ref.read(eventEngagementProvider.notifier);

          if (response.success && context.mounted) {
            provider.addLocation(event.location, EventPoint.joinEvent.value);
            provider.addEventType(event.eventType, EventPoint.joinEvent.value);
            await getAttendees(page: 1);
            WayaNav.goBack();

            if (context.mounted) {
              WayaUtils.showNotice(
                context: context,
                secondButtonText: 'Explore more events',
                icon: Image.asset(
                  WayaAssets.images.createEventSuccess.path,
                  scale: 1.5,
                ),
                onPress: () => WayaNav.goBack(),
                buttonText: 'View Event Details',
                title: "You've successfully joined the event",
                message:
                    'Your spot is confirmed. Stay tuned for updates and get ready for an amazing experience',
                onCancel: () => WayaNav.toNamed(EventView.route),
              );
            }
          } else {
            WayaNav.goBack();
            String? message = response.data['message'];
            WayaSnackBar.showToast(
                message ?? 'Something is wrong. Try again later');
          }
        } else {
          return;
        }
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
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
        // WayaNav.goBack();

        if (context.mounted) {
          await WayaUtils.showNotice(
              context: context,
              title: "Thank you for reporting",
              onPress: () => WayaNav.replaceNamed(EventView.route),
              icon: Image.asset(WayaAssets.images.eCheckEvent.path, scale: 1.5),
              message:
                  'Your report has been submitted. Our team will review the issue and take appropriate action.',
              buttonText: 'Go to Event Page');
        }
        debugPrint(response.data.toString());
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isReportingEvent: false);
    }
  }

  Future<PaginatedResult<Doc>?> getAttendees(
      {required int page, String? id}) async {
    try {
      state = state.copyWith(isLoadingAttendees: true);
      final userId = await _secureDataSource.getUserId();
      state = state.copyWith(userId: userId);
      final response = await _eventRepository.joinedUsers(
          id: id ?? state.singleEvent!.id, page: page);
      List<Doc> attendees = [];
      bool hasNextPage = false;

      //? This is fine.
      if (response.success) {
        AttendeeResponse attendeeResponse =
            AttendeeResponse.fromJson(response.data);
        attendees = attendeeResponse.data.docs;
        hasNextPage = attendeeResponse.data.hasNextPage;
        state = state.copyWith(attendees: attendees, isLoadingAttendees: false);
      }

      //? This is fine.
      return PaginatedResult(
        hasNextPage: hasNextPage,
        items: attendees,
      );
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
      return null;
    } finally {
      state = state.copyWith(isLoadingAttendees: false);
    }
  }

  Future<EventDoc?> fetchSingleEvent(String id) async {
    try {
      state = state.copyWith(isLoadingSingleEvent: true);
      final response = await _eventRepository.getSingleEvent(id);

      if (response.success) {
        SingleEventResponse eventResponse =
            SingleEventResponse.fromJson(response.data);
        state = state.copyWith(singleEvent: eventResponse.data);
        return eventResponse.data;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoadingSingleEvent: false);
    }

    return null;
  }

  Future<void> shareEvent(
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
