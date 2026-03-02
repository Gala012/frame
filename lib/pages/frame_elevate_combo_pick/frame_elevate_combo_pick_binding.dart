import 'package:get/get.dart';
import 'frame_elevate_combo_pick_logic.dart';
class FrameElevateComboPickBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateComboPickLogic());
  }
}
