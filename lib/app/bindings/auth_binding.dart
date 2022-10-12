import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../data/providers/api.dart';
import '../repository/user_repo.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(UserRepository(Api())),
    );
  }
}
