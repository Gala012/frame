import 'package:get/get.dart';
import '../frame_elevate_gallery/frame_elevate_gallery_logic.dart';
import '../frame_elevate_settings/frame_elevate_settings_logic.dart';
class FrameElevateTabLogic extends GetxController {
  final currentIndex = 0.obs;
  void onTabChange(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    if (index == 1) {
      try {
        final galleryLogic = Get.find<FrameElevateGalleryLogic>();
        galleryLogic.loadArtworks();
      } catch (e) {
      }
    }
    if (index == 2) {
      try {
        final settingsLogic = Get.find<FrameElevateSettingsLogic>();
        settingsLogic.loadStorageInfo();
      } catch (e) {
      }
    }
  }
}
