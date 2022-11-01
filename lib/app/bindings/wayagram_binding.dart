import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../data/providers/api.dart';
import '../repository/user_repo.dart';

class WayagramBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(UserRepository(Api())));
    Get.lazyPut<HomeController>(() => HomeController(UserRepository(Api())));
  }
}
