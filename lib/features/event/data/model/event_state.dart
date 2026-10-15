import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/model/event_attendee_response_model.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class EventState {
  final bool isLoading;
  final bool isLoadingUserEvents;
  final bool isLoadingEventWithStatus;
  final bool isLoadingAttendees;
  final bool isLoadingSingleEvent;
  final bool isJoiningEvent;
  final bool isReportingEvent;
  final List<EventDoc> events;
  final List<EventDoc> myEvents;
  final List<EventDoc> upcomingEvents;
  final List<EventDoc> pastEvents;
  final List<EventDoc> joinedEvents;
  final EventDoc? singleEvent;
  final bool isUserEvent;
  final List<Doc> attendees;
   final List<Doc> attendeesAwaitApproval;
  final String userId;
  final List<UserDetailsModel> invitees;

  EventState({
    this.isLoading = false,
    this.events = const [],
    this.myEvents = const [],
    this.pastEvents = const [],
    this.upcomingEvents = const [],
    this.isLoadingEventWithStatus = false,
    this.isUserEvent = false,
    this.singleEvent,
    this.isJoiningEvent = false,
    this.isLoadingAttendees = false,
    this.isLoadingSingleEvent = false,
    this.isReportingEvent = false,
    this.attendees = const [],
    this.attendeesAwaitApproval =  const [],
    this.joinedEvents = const [],
    this.userId = '',
    this.isLoadingUserEvents = false,
    this.invitees = const []
  });

  bool isAttending(String eventId) {
    return attendees.any((attendance) =>
        attendance.userId == ConversationState.self.id &&
        attendance.eventId == eventId);
  }

  EventState copyWith(
      {bool? isLoading,
      List<EventDoc>? events,
      List<EventDoc>? myEvents,
      List<EventDoc>? upcomingEvents,
      List<EventDoc>? pastEvents,
      List<EventDoc>? joinedEvents,
      String? userId,
      bool? isLoadingEventWithStatus,
      EventDoc? singleEvent,
      bool? isUserEvent,
      bool? isLoadingAttendees,
      bool? isLoadingSingleEvent,
      bool? isJoiningEvent,
      bool? isReportingEvent,
      List<Doc>? attendees,
      List<Doc>? attendeesAwaitApproval,
      List<UserDetailsModel>? invitees,
      bool? isLoadingUserEvents}) {
    return EventState(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      isLoadingSingleEvent: isLoadingSingleEvent ?? this.isLoadingSingleEvent,
      isLoadingAttendees: isLoadingAttendees ?? this.isLoadingAttendees,
      myEvents: myEvents ?? this.myEvents,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      pastEvents: pastEvents ?? this.pastEvents,
      singleEvent: singleEvent ?? this.singleEvent,
      isUserEvent: isUserEvent ?? this.isUserEvent,
      isJoiningEvent: isJoiningEvent ?? this.isJoiningEvent,
      attendeesAwaitApproval: attendeesAwaitApproval ?? this.attendeesAwaitApproval,
      attendees: attendees ?? this.attendees,
      userId: userId ?? this.userId,
      isReportingEvent: isReportingEvent ?? this.isReportingEvent,
      joinedEvents: joinedEvents ?? this.joinedEvents,
      isLoadingEventWithStatus:
          isLoadingEventWithStatus ?? this.isLoadingEventWithStatus,
      isLoadingUserEvents: isLoadingUserEvents ?? this.isLoadingUserEvents,
      invitees : invitees ?? this.invitees
    );
  }
}
