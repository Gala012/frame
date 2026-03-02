import 'package:get/get.dart';
import 'frame_elevate_gallery_preview_logic.dart';
class FrameElevateGalleryPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameElevateGalleryPreviewLogic());
  }
}
