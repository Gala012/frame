import 'package:get/get.dart';
import '../frame_elevate_home/frame_elevate_home_logic.dart';
import '../frame_elevate_gallery/frame_elevate_gallery_logic.dart';
import '../frame_elevate_settings/frame_elevate_settings_logic.dart';
import 'frame_elevate_tab_logic.dart';
class FrameElevateTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateTabLogic());
    Get.lazyPut(() => FrameElevateHomeLogic());
    Get.lazyPut(() => FrameElevateGalleryLogic());
    Get.lazyPut(() => FrameElevateSettingsLogic());
  }
}
