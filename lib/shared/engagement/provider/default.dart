import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/shared/engagement/model/default.dart';

class EngagementNotifier
    extends StateNotifier<Map<ServiceType, EngagementData>> {
  final WayaLocalDataSource localDataSource;

  EngagementNotifier(this.localDataSource)
      : super({
          for (var service in ServiceType.values) service: EngagementData()
        }) {
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final storedData = await localDataSource.getEngagementData();
    state = storedData;
  }

  Future<void> saveData() async {
    await localDataSource.saveEngagementData(state);
  }

  Future<void> sendPostCategoryData() async {
    try {
      final postCategoryData = state[ServiceType.posts]!
          .postCategory
          .entries
          .map((entry) => {"category": entry.key, "score": entry.value})
          .toList();

      await AuthRepository().selectInterest(postCategoryData);
    } catch (error) {
      debugPrint("Error sending data: $error");
    }
  }

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
    saveData();
  }

  void monitorEventLocation(ServiceType service, String loc, int points) {
    final engagementData = state[service]!;
    engagementData.addEventLocation(loc, points);
    state = {...state};
    saveData();
  }

  void monitorEventType(ServiceType service, String type, int points) {
    final engagementData = state[service]!;
    engagementData.addEventType(type, points);
    state = {...state};
    saveData();
  }

  void monitorPostHashTag(ServiceType service, String tag, int points) {
    final engagementData = state[service]!;
    engagementData.addHashtag(tag, points);
    state = {...state};
    saveData();
  }

  void monitorPostCategory(ServiceType service, String cat, int points) {
    final engagementData = state[service]!;
    engagementData.addEventType(cat, points);
    state = {...state};
    sendPostCategoryData();
  }

  // Future<void> sendData() async {
  //   final engagementData = state;

  //   debugPrint("Engagement data sent to backend: $engagementData");
  // }
}

final engagementNotifierProvider =
    StateNotifierProvider<EngagementNotifier, Map<ServiceType, EngagementData>>(
  (ref) => EngagementNotifier(WayaLocalDataSource()),
);
