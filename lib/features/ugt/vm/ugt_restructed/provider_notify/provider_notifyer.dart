import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/category_model.dart';
import '../api_service/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// final userListProvider = FutureProvider<List<ContestCategory>>((ref) async {
//   return ref.watch(apiServiceProvider).fetchUser();
// });

/*final userProvider = StateNotifierProvider<UserNotifier, CreateUser?>((ref) {
  return UserNotifier(ref.read(apiServiceProvider));
});*/

/*
class UserNotifier extends StateNotifier<CreateUser?> {
  final ApiService apiService;

  UserNotifier(this.apiService) : super(null);

  Future<void> createUser(String name, String job) async {
    try {
      final user = await apiService.createUser(name, job);
      state = user;
    } catch (e) {
      state = null;
    }
  }
}*/
