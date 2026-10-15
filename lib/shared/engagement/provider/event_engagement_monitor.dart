import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
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
  }

  Map<String, int> getAllEventLocation() {
    return _engagementNotifier.state[ServiceType.events]!.getAllEventLocation();
  }

  void addEventType(String type, int points) {
    _engagementNotifier.monitorEventType(ServiceType.events, type, points);
  }

  Map<String, int> getAllEventType() {
    return _engagementNotifier.state[ServiceType.events]!.getAllEventType();
  }
}

final eventEngagementProvider =
    StateNotifierProvider<EventEngagementMonitor, void>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return EventEngagementMonitor(
      EngagementNotifier(WayaLocalDataSource(), authRepository));
});
