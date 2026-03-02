import 'package:get/get.dart';
import 'frame_elevate_batch_pick_logic.dart';
class FrameElevateBatchPickBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateBatchPickLogic());
  }
}
