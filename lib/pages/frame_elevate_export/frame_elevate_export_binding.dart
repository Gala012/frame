import 'package:get/get.dart';

import 'frame_elevate_export_logic.dart';

class FrameElevateExportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      FrameElevateExportLogic(),
      permanent: true,
    );
  }
}
