import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_elevate_batch_pick_logic.dart';
class FrameElevateBatchPickView extends GetView<FrameElevateBatchPickLogic> {
  const FrameElevateBatchPickView({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF5F2ED),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.close, color: Color(0xFF1A1A1A)),
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Batch Frame',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(() => Text(
                      '${controller.photos.length} photos · Select 2–${FrameElevateBatchPickLogic.maxSelect}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF888888),
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ],
            ),
            centerTitle: true,
            actions: [
              Obx(() {
                final count = controller.selectedIndices.length;
                final canDone = count >= 2;
                return GestureDetector(
                  onTap: canDone ? controller.onDoneTap : null,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: canDone
                              ? const Color(0xFFC9A96E)
                              : const Color(0xFFE8E4DE),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: canDone
                                ? Colors.white
                                : const Color(0xFF999999),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
          body: Column(
            children: [
              Expanded(child: _buildPhotoGrid()),
              _buildBottomBar(),
            ],
          ),
        ),
        Obx(() => AnimatedOpacity(
              opacity: controller.isProcessing.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: IgnorePointer(
                ignoring: !controller.isProcessing.value,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFC9A96E)),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Processing photos...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
  Widget _buildPhotoGrid() {
    return Obx(() {
      if (controller.isLoading.value && controller.photos.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC9A96E)),
          ),
        );
      }
      if (controller.photos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_library_outlined,
                  size: 48.w, color: const Color(0xFFCCCCCC)),
              SizedBox(height: 12.h),
              Text(
                'No photos found in this album',
                style:
                    TextStyle(fontSize: 14.sp, color: const Color(0xFF888888)),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.refreshPhotos,
        color: const Color(0xFFC9A96E),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: controller.photos.length,
          itemBuilder: (context, index) {
            return _buildPhotoCell(index);
          },
        ),
      );
    });
  }
  Widget _buildPhotoCell(int index) {
    return Obx(() {
      final isSelected = controller.isSelected(index);
      final selectionOrder =
          isSelected ? controller.selectedIndices.indexOf(index) + 1 : -1;
      return GestureDetector(
        onTap: () => controller.onPhotoTap(index),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<Uint8List?>(
              future: controller.loadThumbnail(index),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE8E4DE),
                        child: Icon(Icons.broken_image,
                            size: 24.w, color: const Color(0xFFBBB0A0)),
                      );
                    },
                  );
                }
                return Container(
                  color: const Color(0xFFE8E4DE),
                  child: Center(
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Color(0xFFC9A96E)),
                            ),
                          )
                        : Icon(
                            Icons.image_outlined,
                            size: 24.w,
                            color: const Color(0xFFBBB0A0),
                          ),
                  ),
                );
              },
            ),
            if (isSelected) ...[
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A96E).withValues(alpha: 0.2),
                    border:
                        Border.all(color: const Color(0xFFC9A96E), width: 3),
                  ),
                ),
              ),
              Positioned(
                bottom: 5.w,
                right: 5.w,
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC9A96E),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$selectionOrder',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E4DE))),
      ),
      child: Obx(() {
        final count = controller.selectedIndices.length;
        final hasSelection = count > 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selected ($count/${FrameElevateBatchPickLogic.maxSelect})',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A)),
                ),
                SizedBox(height: 2.h),
                Text(
                  count < 2
                      ? 'Select at least 2 photos'
                      : '$count photos selected',
                  style: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFF888888)),
                ),
              ],
            ),
            GestureDetector(
              onTap: hasSelection ? controller.onClearTap : null,
              child: Container(
                decoration: BoxDecoration(
                  color: hasSelection
                      ? const Color(0xFFC9A96E)
                      : const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: hasSelection
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFFC9A96E).withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                child: Text(
                  'Clear',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
