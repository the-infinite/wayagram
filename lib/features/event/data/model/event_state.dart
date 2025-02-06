import 'package:wayagram/features/event/data/model/event_response_model.dart';

class EventState {
  final bool isLoading;
  final bool isLoadingUserEvents;
  final bool isLoadingEventWithStatus;
  final List<EventDoc> events;
  final List<EventDoc> myEvents;
  final List<EventDoc> upcomingEvents;
  final List<EventDoc> pastEvents;
  final EventDoc? singleEvent;
  final bool isUserEvent;

  EventState(
      {this.isLoading = false,
      this.events = const [],
      this.myEvents = const [],
      this.pastEvents = const [],
      this.upcomingEvents = const [],
      this.isLoadingEventWithStatus = false,
      this.isUserEvent = false,
      this.singleEvent,
      this.isLoadingUserEvents = false});

  EventState copyWith(
      {bool? isLoading,
      List<EventDoc>? events,
      List<EventDoc>? myEvents,
      List<EventDoc>? upcomingEvents,
      List<EventDoc>? pastEvents,
      bool? isLoadingEventWithStatus,
      EventDoc? singleEvent,
      bool? isUserEvent,
      bool? isLoadingUserEvents}) {
    return EventState(
        isLoading: isLoading ?? this.isLoading,
        events: events ?? this.events,
        myEvents: myEvents ?? this.myEvents,
        upcomingEvents: upcomingEvents ?? this.upcomingEvents,
        pastEvents: pastEvents ?? this.pastEvents,
        singleEvent: singleEvent ?? this.singleEvent,
        isUserEvent:  isUserEvent ?? this.isUserEvent,
        isLoadingEventWithStatus:
            isLoadingEventWithStatus ?? this.isLoadingEventWithStatus,
        isLoadingUserEvents: isLoadingUserEvents ?? this.isLoadingUserEvents);
  }
}
