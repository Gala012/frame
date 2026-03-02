import 'package:get/get.dart';
import 'frame_elevate_gallery_logic.dart';
class FrameElevateGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateGalleryLogic());
  }
}
