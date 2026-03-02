import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'frame_elevate_camera_logic.dart';
class FrameElevateCameraView extends GetView<FrameElevateCameraLogic> {
  const FrameElevateCameraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, color: Colors.white, size: 20.w),
          ),
        ),
        title: Text(
          'Scan & Frame',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() => GestureDetector(
                onTap: controller.onFlashToggle,
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    controller.flashIcon,
                    color: controller.flashMode.value == 0
                        ? Colors.white
                        : const Color(0xFFC9A96E),
                    size: 20.w,
                  ),
                ),
              )),
        ],
      ),
      body: Obx(() {
        if (!controller.isCameraInitialized.value &&
            !controller.hasPhoto.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC9A96E)),
            ),
          );
        }
        return controller.hasPhoto.value
            ? _buildConfirmState()
            : _buildCaptureState();
      }),
    );
  }
  Widget _buildCaptureState() {
    return Column(
      children: [
        Expanded(child: _buildViewfinder()),
        _buildBottomControls(),
      ],
    );
  }
  Widget _buildViewfinder() {
    if (controller.cameraController == null ||
        !controller.cameraController!.value.isInitialized) {
      return Container(
        color: const Color(0xFF1A1A1A),
        child: Icon(Icons.camera_alt_outlined,
            size: 60.w, color: const Color(0xFF333333)),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller.cameraController!),
        Center(
          child: SizedBox(
            width: 70.w,
            height: 70.w,
            child: CustomPaint(painter: _FocusReticlePainter()),
          ),
        ),
        Positioned(
          bottom: 16.h,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Text(
                'Tap anywhere to focus',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildBottomControls() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 36.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: controller.onAlbumTap,
            child: Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10.w),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), width: 2),
              ),
              child: Icon(Icons.photo_library_outlined,
                  size: 22.w, color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          GestureDetector(
            onTap: controller.onCaptureTap,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8), width: 4),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 52.w, height: 52.w),
        ],
      ),
    );
  }
  Widget _buildConfirmState() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: controller.capturedImage != null
                ? Image.file(
                    File(controller.capturedImage!.path),
                    fit: BoxFit.contain,
                  )
                : Container(
                    color: const Color(0xFF1A1A1A),
                    child: Icon(Icons.image_outlined,
                        size: 80.w, color: const Color(0xFF333333)),
                  ),
          ),
        ),
        Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 30.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: controller.onRetakeTap,
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(14.w),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                  child: Text(
                    'Retake',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              GestureDetector(
                onTap: controller.onUsePhotoTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A96E),
                    borderRadius: BorderRadius.circular(14.w),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC9A96E).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                  child: Text(
                    'Use Photo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class _FocusReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC9A96E).withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const cornerLen = 12.0;
    final w = size.width;
    final h = size.height;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
    final thickPaint = Paint()
      ..color = const Color(0xFFC9A96E)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, cornerLen), const Offset(0, 0), thickPaint);
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLen, 0), thickPaint);
    canvas.drawLine(Offset(w - cornerLen, 0), Offset(w, 0), thickPaint);
    canvas.drawLine(Offset(w, 0), Offset(w, cornerLen), thickPaint);
    canvas.drawLine(Offset(0, h - cornerLen), Offset(0, h), thickPaint);
    canvas.drawLine(Offset(0, h), Offset(cornerLen, h), thickPaint);
    canvas.drawLine(Offset(w - cornerLen, h), Offset(w, h), thickPaint);
    canvas.drawLine(Offset(w, h - cornerLen), Offset(w, h), thickPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
