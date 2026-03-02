import 'package:get/get.dart';
import 'frame_elevate_crop_logic.dart';
class FrameElevateCropBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateCropLogic());
  }
}
