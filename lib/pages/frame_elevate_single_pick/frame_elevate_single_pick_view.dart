import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_elevate_single_pick_logic.dart';
class FrameElevateSinglePickView extends GetView<FrameElevateSinglePickLogic> {
  const FrameElevateSinglePickView({super.key});
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
                  'Select Photo',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Obx(() => Text(
                      '${controller.photos.length} photos',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF888888),
                      ),
                    )),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: const Color(0xFFE8E4DE), height: 1),
            ),
          ),
          body: _buildPhotoGrid(),
        ),
        Obx(() => AnimatedOpacity(
              opacity: controller.isLoadingImage.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: IgnorePointer(
                ignoring: !controller.isLoadingImage.value,
                child: Material(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFC9A96E)),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Processing...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
                'No photos found in your gallery',
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
    return GestureDetector(
      onTap: () => controller.onPhotoTap(index),
      behavior: HitTestBehavior.opaque,
      child: FutureBuilder<Uint8List?>(
        future: controller.loadThumbnail(index),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
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
    );
  }
}
