// variations
// - hastags
// - categories

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/shared/engagement/model/default.dart';
import 'package:wayagram/shared/engagement/provider/default.dart';

enum PostPoints {
  commentPoint(3),
  likedPoint(2),
  sharePoint(1),
  repostPoint(2),
  bookedPoint(1);

  final int value;
  const PostPoints(this.value);
}

class PostEngagementMonitor extends StateNotifier<void> {
  final EngagementNotifier _engagementNotifier;

  PostEngagementMonitor(this._engagementNotifier) : super(null);

  void addTag(String tag, int points) {
    _engagementNotifier.monitorPostHashTag(ServiceType.posts, tag, points);
  }

  Map<String, int> getAlltags() {
    return _engagementNotifier.state[ServiceType.posts]!.getAllPosttags();
  }

  void addCategory(String cat, int points) {
    _engagementNotifier.monitorPostCategory(ServiceType.posts, cat, points);
  }

  Map<String, int> getAllCategories() {
    return _engagementNotifier.state[ServiceType.posts]!.getAllPostCategories();
  }
}

final postEngagementProvider =
    StateNotifierProvider<PostEngagementMonitor, void>((ref) {
  return PostEngagementMonitor(EngagementNotifier());
});
