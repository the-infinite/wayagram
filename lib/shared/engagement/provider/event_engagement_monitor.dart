// variations
// -- location type
// -- event type

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/shared/engagement/model/default.dart';
import 'package:wayagram/shared/engagement/provider/default.dart';

enum EventPoint {
  viewEvent(1),
  joinEvent(3);

  final int value;
  const EventPoint(this.value);
}

class EventEngagementMonitor extends StateNotifier<void> {
  final EngagementNotifier _engagementNotifier;

  EventEngagementMonitor(this._engagementNotifier) : super(null);

  void startViewingEvent() {
    _engagementNotifier.startTracking(ServiceType.events);
  }

  void stopViewingEvent() {
    _engagementNotifier.stopTracking(ServiceType.events);
  }

  void addLocation(String loc, int points) {
    _engagementNotifier.monitorEventLocation(ServiceType.events, loc, points);

    print(getAllEventLocation());
  }

  Map<String, int> getAllEventLocation() {
    return _engagementNotifier.state[ServiceType.events]!.getAllEventLocation();
  }

  void addEventType(String type, int points) {
    _engagementNotifier.monitorEventType(ServiceType.events, type, points);
  }

  Map<String, int> getAllEventType() {
    return _engagementNotifier.state[ServiceType.events]!.getAllEventTypee();
  }
}

final eventEngagementProvider =
    StateNotifierProvider<EventEngagementMonitor, void>((ref) {
  return EventEngagementMonitor(EngagementNotifier());
});
