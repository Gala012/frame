import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_elevate_gallery_logic.dart';
class FrameElevateGalleryView extends GetView<FrameElevateGalleryLogic> {
  const FrameElevateGalleryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          'Gallery',
          style: TextStyle(
            color: const Color(0xFFC9A96E),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Obx(() => _buildAppBarActions()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFC9A96E),
            ),
          );
        }
        if (controller.artworks.isEmpty) {
          return _buildEmptyState();
        }
        return Column(
          children: [
            _buildStatsBar(),
            Expanded(child: _buildMasonryGrid()),
            if (controller.isSelectMode.value) _buildBottomActionBar(),
          ],
        );
      }),
    );
  }
  Widget _buildAppBarActions() {
    if (controller.isSelectMode.value) {
      return Row(
        children: [
          TextButton(
            onPressed: controller.onToggleSelectMode,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: const Color(0xFFC9A96E),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFC9A96E).withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: TextButton(
          onPressed: controller.onToggleSelectMode,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Select',
            style: TextStyle(
              color: const Color(0xFFC9A96E),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80.w,
            color: const Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16.h),
          Text(
            'No artworks yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF888888),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create your first artwork\nfrom the Home tab',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFFAAAAAA),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatsBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            if (controller.isSelectMode.value && controller.selectedIds.isNotEmpty) {
              return Text(
                '${controller.selectedIds.length} selected',
                style: TextStyle(
                  color: const Color(0xFFC9A96E),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              );
            }
            return Text(
              '${controller.artworks.length} artworks',
              style: TextStyle(
                color: const Color(0xFF888888),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            );
          }),
          Text(
            'Sort: Latest',
            style: TextStyle(
              color: const Color(0xFFC9A96E),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMasonryGrid() {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      color: const Color(0xFFC9A96E),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            sliver: SliverToBoxAdapter(
              child: _buildTwoColumnMasonry(),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }
  Widget _buildTwoColumnMasonry() {
    final leftItems = <int>[];
    final rightItems = <int>[];
    for (int i = 0; i < controller.artworks.length; i++) {
      if (i % 2 == 0) {
        leftItems.add(i);
      } else {
        rightItems.add(i);
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildColumn(leftItems)),
        SizedBox(width: 10.w),
        Expanded(child: _buildColumn(rightItems)),
      ],
    );
  }
  Widget _buildColumn(List<int> indices) {
    return Column(
      children: indices.map((i) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _buildArtworkCard(i),
        );
      }).toList(),
    );
  }
  Widget _buildArtworkCard(int index) {
    final artwork = controller.artworks[index];
    final label = controller.getFeatureTypeLabel(artwork.featureType);
    return GestureDetector(
      onTap: () => controller.onPreviewTap(index),
      child: Obx(() {
        final isSelected = controller.selectedIds.contains(artwork.id);
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.w),
                border: isSelected
                    ? Border.all(color: const Color(0xFFC9A96E), width: 3)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: _buildThumbnail(artwork.thumbnailPath),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    color: Colors.white,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isSelectMode.value)
              Positioned(
                top: 8.w,
                right: 8.w,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFC9A96E)
                        : Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFC9A96E)
                          : const Color(0xFF888888),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 16.w,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
          ],
        );
      }),
    );
  }
  Widget _buildThumbnail(String path) {
    final file = File(path);
    return FutureBuilder<bool>(
      future: file.exists(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.file(
            file,
            fit: BoxFit.cover,
          );
        }
        return Container(
          color: const Color(0xFFE8E4DE),
          child: Icon(
            Icons.image_outlined,
            size: 32.w,
            color: const Color(0xFFCCCCCC),
          ),
        );
      },
    );
  }
  Widget _buildBottomActionBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: controller.onDeleteSelected,
              icon: Icon(Icons.delete_outline, size: 18.w),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE05555),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
