import 'package:get/get.dart';

import '../controllers/see_more_controller.dart';

class SeeMoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeeMoreController>(
      () => SeeMoreController(),
    );
  }
}
