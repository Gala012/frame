import 'package:get/get.dart';
import 'frame_elevate_camera_logic.dart';
class FrameElevateCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateCameraLogic());
  }
}
