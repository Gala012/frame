import 'package:get/get.dart';
import 'frame_elevate_single_pick_logic.dart';
class FrameElevateSinglePickBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateSinglePickLogic());
  }
}
