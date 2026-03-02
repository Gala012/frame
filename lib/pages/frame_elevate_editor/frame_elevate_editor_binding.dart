import 'package:get/get.dart';
import 'frame_elevate_editor_logic.dart';
class FrameElevateEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateEditorLogic());
  }
}
