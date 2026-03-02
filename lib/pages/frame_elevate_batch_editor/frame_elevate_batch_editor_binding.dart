import 'package:get/get.dart';
import 'frame_elevate_batch_editor_logic.dart';
class FrameElevateBatchEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateBatchEditorLogic());
  }
}
