import 'package:get/get.dart';
import 'frame_elevate_settings_logic.dart';
class FrameElevateSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateSettingsLogic());
  }
}
