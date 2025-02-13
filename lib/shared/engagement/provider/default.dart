import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/shared/engagement/model/default.dart';

class EngagementNotifier
    extends StateNotifier<Map<ServiceType, EngagementData>> {
  EngagementNotifier()
      : super({
          for (var service in ServiceType.values) service: EngagementData()
        });

  void startTracking(ServiceType service) {
    final engagementData = state[service]!;
    engagementData.addTime(0);
    state = {...state};
  }

  void stopTracking(ServiceType service) {
    final engagementData = state[service]!;
    engagementData.addTime(0);
    state = {...state};
  }

  void monitorProductCategory(
      ServiceType service, String category, int points) {
    final engagementData = state[service]!;
    engagementData.addProductCategory(category, points);
    state = {...state};
  }

  void monitorEventLocation(ServiceType service, String loc, int points) {
    final engagementData = state[service]!;
    engagementData.addEventLocation(loc, points);
    state = {...state};
  }

  void monitorEventType(ServiceType service, String type, int points) {
    final engagementData = state[service]!;
    engagementData.addEventType(type, points);
    state = {...state};
  }

  Future<void> sendData() async {
    final engagementData = state;

    print("Engagement data sent to backend: $engagementData");
  }
}

final engagementNotifierProvider =
    StateNotifierProvider<EngagementNotifier, Map<ServiceType, EngagementData>>(
  (ref) => EngagementNotifier(),
);
