import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/home_controller.dart';
import '../data/providers/api.dart';
import '../repository/user_repo.dart';

class WayagramBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthControllerWayagram>(() => AuthControllerWayagram(UserRepository(Api())));
    Get.lazyPut<HomeControllerWayagram>(() => HomeControllerWayagram(UserRepository(Api())));
    Get.lazyPut<ChatControllerWayagram>(() => ChatControllerWayagram(UserRepository(Api())));
  }
}
