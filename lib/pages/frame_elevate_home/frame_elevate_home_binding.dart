import 'package:get/get.dart';
import 'frame_elevate_home_logic.dart';
class FrameElevateHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateHomeLogic());
  }
}
