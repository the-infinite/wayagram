import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/shared/engagement/model/default.dart';
import 'package:wayagram/shared/engagement/provider/default.dart';

enum ProductPoint {
  viewPoints(1),
  likePoints(3),
  searchPoint(1),
  sharePoints(5);

  final int value;
  const ProductPoint(this.value);
}

class ProductEngagementMonitor extends StateNotifier<void> {
  final EngagementNotifier _engagementNotifier;

  ProductEngagementMonitor(this._engagementNotifier) : super(null);

  void startViewingProduct() {
    _engagementNotifier.startTracking(ServiceType.product);
  }

  void stopViewingProduct() {
    _engagementNotifier.stopTracking(ServiceType.product);
  }

  void addCategory(String category, int points) {
    _engagementNotifier.monitorProductCategory(
        ServiceType.product, category, points);
  }

  Map<String, int> getAllProductCategories() {
    return _engagementNotifier.state[ServiceType.product]!
        .getAllProductCategories();
  }
}

final productEngagementProvider =
    StateNotifierProvider<ProductEngagementMonitor, void>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return ProductEngagementMonitor(
      EngagementNotifier(WayaLocalDataSource(), authRepository));
});
