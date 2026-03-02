import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'frame_elevate_export_logic.dart';

class FrameElevateExportView extends GetView<FrameElevateExportLogic> {
  const FrameElevateExportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.yulxjim.value
              ? const CircularProgressIndicator(color: Colors.yellow)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.vbamp();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
