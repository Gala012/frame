import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_elevate_gallery_preview_logic.dart';
class FrameElevateGalleryPreviewView
    extends GetView<FrameElevateGalleryPreviewLogic> {
  const FrameElevateGalleryPreviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 18.w,
            ),
          ),
        ),
        title: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Artwork',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${controller.currentIndex.value + 1} / ${controller.total}',
                  style: TextStyle(
                    color: const Color(0xFF888888),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            )),
        actions: [
          GestureDetector(
            onTap: controller.onMoreTap,
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildArtworkArea()),
          _buildBottomBar(),
        ],
      ),
    );
  }
  Widget _buildArtworkArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Obx(() {
                final artwork = controller.currentArtwork;
                double displayWidth = 300.w;
                double displayHeight = 300.w;
                if (artwork != null &&
                    artwork.outputWidth != null &&
                    artwork.outputHeight != null &&
                    artwork.outputWidth! > 0 &&
                    artwork.outputHeight! > 0) {
                  final aspectRatio =
                      artwork.outputWidth! / artwork.outputHeight!;
                  final maxWidth = constraints.maxWidth * 0.85;
                  final maxHeight = constraints.maxHeight * 0.75;
                  displayWidth = maxWidth;
                  displayHeight = displayWidth / aspectRatio;
                  if (displayHeight > maxHeight) {
                    displayHeight = maxHeight;
                    displayWidth = displayHeight * aspectRatio;
                  }
                }
                return SizedBox(
                  width: displayWidth,
                  height: displayHeight,
                  child: _buildArtworkImage(),
                );
              }),
            ),
            Obx(() => controller.currentIndex.value > 0
                ? Positioned(
                    left: 16.w,
                    child: GestureDetector(
                      onTap: controller.onPrevious,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 18.w,
                        ),
                      ),
                    ),
                  )
                : const SizedBox()),
            Obx(() => controller.currentIndex.value < controller.total - 1
                ? Positioned(
                    right: 16.w,
                    child: GestureDetector(
                      onTap: controller.onNext,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 18.w,
                        ),
                      ),
                    ),
                  )
                : const SizedBox()),
            Obx(() {
              if (controller.total <= 1) return const SizedBox();
              return Positioned(
                bottom: 16.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    controller.total > 10 ? 10 : controller.total,
                    (i) {
                      final isActive = i == controller.currentIndex.value;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        width: isActive ? 18.w : 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFC9A96E)
                              : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
  Widget _buildBottomBar() {
    return Obx(() {
      final artwork = controller.currentArtwork;
      if (artwork == null) return const SizedBox();
      final label = _getFeatureTypeLabel(artwork.featureType);
      final dateTime = _formatDateTime(artwork.createdAt);
      return Container(
        color: const Color(0xFF111111),
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 32.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    dateTime,
                    style: TextStyle(
                      color: const Color(0xFF666666),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _buildActionBtn(
                  Icons.download_outlined,
                  'Save',
                  const Color(0xFFC9A96E),
                  controller.onSave,
                ),
                SizedBox(width: 10.w),
                _buildActionBtn(
                  Icons.delete_outline,
                  'Delete',
                  const Color(0xFFE05555),
                  controller.deleteArtwork,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
  Widget _buildActionBtn(
    IconData icon,
    String label,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 16.w),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFFAAAAAA),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildArtworkImage() {
    final artwork = controller.currentArtwork;
    if (artwork == null) {
      return Container(
        color: const Color(0xFFE8E4DE),
        child: Icon(
          Icons.image_outlined,
          size: 48.w,
          color: const Color(0xFFCCCCCC),
        ),
      );
    }
    final file = File(artwork.outputPath);
    return FutureBuilder<bool>(
      future: file.exists(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.file(
            file,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          );
        }
        return Container(
          color: const Color(0xFFE8E4DE),
          child: Icon(
            Icons.image_outlined,
            size: 48.w,
            color: const Color(0xFFCCCCCC),
          ),
        );
      },
    );
  }
  String _getFeatureTypeLabel(String featureType) {
    switch (featureType) {
      case 'single':
        return 'Single Frame';
      case 'batch':
        return 'Batch Frame';
      case 'combo':
        return 'Combo Frame';
      case 'photo':
        return 'Scan & Frame';
      default:
        return 'Single Frame';
    }
  }
  String _formatDateTime(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt);
      final monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final month = monthNames[dt.month - 1];
      final day = dt.day;
      final year = dt.year;
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return 'Saved $month $day, $year · $hour:$minute';
    } catch (e) {
      return createdAt;
    }
  }
}
