import 'package:get/get.dart';
class FrameElevateHomeLogic extends GetxController {
  void onSingleFrameTap() => Get.toNamed('/single-frame/pick');
  void onBatchFrameTap() => Get.toNamed('/batch-frame/pick');
  void onComboFrameTap() => Get.toNamed('/combo-frame/pick');
  void onScanFrameTap() => Get.toNamed('//photo-frame/camera');
}
