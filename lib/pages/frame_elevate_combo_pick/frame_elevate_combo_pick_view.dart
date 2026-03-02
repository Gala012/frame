import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_elevate_combo_pick_logic.dart';
class FrameElevateComboPickView extends GetView<FrameElevateComboPickLogic> {
  const FrameElevateComboPickView({super.key});
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
            title: _buildAlbumDropdown(),
            actions: [
              Obx(() {
                final canDone =
                    controller.selectedIndices.length == controller.maxCount;
                return GestureDetector(
                  onTap: canDone ? controller.onDoneTap : null,
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      color: canDone
                          ? const Color(0xFFC9A96E)
                          : const Color(0xFFCCCCCC),
                      borderRadius: BorderRadius.circular(10.w),
                      boxShadow: canDone
                          ? [
                              BoxShadow(
                                color: const Color(0xFFC9A96E)
                                    .withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              })
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: const Color(0xFFE8E4DE), height: 1),
            ),
          ),
          body: Column(
            children: [
              _buildSelectionHint(),
              Expanded(child: _buildPhotoGrid()),
              _buildLayoutPanel(),
            ],
          ),
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
  Widget _buildAlbumDropdown() {
    return Text(
      'Combo Frame',
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }
  Widget _buildSelectionHint() {
    return Obx(() {
      final selected = controller.selectedIndices.length;
      final max = controller.maxCount;
      final remaining = max - selected;
      String hint;
      Color hintColor;
      if (selected == 0) {
        hint = 'Select a layout below, then choose $max photos';
        hintColor = const Color(0xFF888888);
      } else if (selected < max) {
        hint =
            'Select $remaining more photo${remaining > 1 ? 's' : ''} ($selected/$max)';
        hintColor = const Color(0xFFC9A96E);
      } else {
        hint = 'All $max photos selected ✓';
        hintColor = const Color(0xFF4CAF50);
      }
      return Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint,
            style: TextStyle(
              fontSize: 12.sp,
              color: hintColor,
              fontWeight: selected == max ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      );
    });
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
      final selectedCount = controller.selectedIndices.length;
      return RefreshIndicator(
        onRefresh: controller.refreshPhotos,
        color: const Color(0xFFC9A96E),
        child: GridView.builder(
          key: ValueKey('grid_$selectedCount'),
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
      final isSelected = controller.selectedIndices.contains(index);
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
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFFC9A96E), width: 4),
                  ),
                ),
              ),
              Positioned(
                top: 6.w,
                right: 6.w,
                child: Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A96E),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.check,
                      color: Colors.white, size: 16.w, weight: 700),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
  Widget _buildLayoutPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E4DE))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Select Layout',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A)),
                    ),
                    SizedBox(width: 8.w),
                    Obx(() => Text(
                          '(${controller.selectedIndices.length}/${controller.maxCount})',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFFC9A96E),
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
                Obx(() => controller.selectedIndices.isEmpty
                    ? const SizedBox.shrink()
                    : GestureDetector(
                        onTap: controller.onClearTap,
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: const Color(0xFFC9A96E),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Obx(() => Row(
                  children: List.generate(6, (i) {
                    final isSelected = controller.selectedLayout.value == i;
                    return GestureDetector(
                      onTap: () => controller.onLayoutTap(i),
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Column(
                          children: [
                            Container(
                              width: 52.w,
                              height: 52.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFC9A96E)
                                      : const Color(0xFFDDDDDD),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8.w),
                                color: const Color(0xFFEEEEEE),
                              ),
                              child: _buildLayoutThumb(i),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              isSelected
                                  ? '${_layoutLabel(i)} ✓'
                                  : _layoutLabel(i),
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: isSelected
                                    ? const Color(0xFFC9A96E)
                                    : const Color(0xFF888888),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                )),
          ),
        ],
      ),
    );
  }
  String _layoutLabel(int index) {
    const labels = ['2 Grid', '3 Col', '4 Grid', 'L-Type', 'T-Type', '9 Grid'];
    return labels[index];
  }
  Widget _buildLayoutThumb(int index) {
    const c1 = Color(0xFFC8B89A);
    const c2 = Color(0xFFD4C5A9);
    const c3 = Color(0xFFB8A880);
    const c4 = Color(0xFF8B7355);
    switch (index) {
      case 0:
        return ClipRRect(
          borderRadius: BorderRadius.circular(7.w),
          child: Row(
            children: [
              Expanded(
                  child: Container(color: c1, margin: const EdgeInsets.all(1))),
              Expanded(
                  child: Container(color: c2, margin: const EdgeInsets.all(1))),
            ],
          ),
        );
      case 1:
        return ClipRRect(
          borderRadius: BorderRadius.circular(7.w),
          child: Row(
            children: [
              Expanded(
                  child: Container(color: c3, margin: const EdgeInsets.all(1))),
              Expanded(
                  child: Container(color: c1, margin: const EdgeInsets.all(1))),
              Expanded(
                  child: Container(color: c2, margin: const EdgeInsets.all(1))),
            ],
          ),
        );
      case 2:
        return ClipRRect(
          borderRadius: BorderRadius.circular(7.w),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: c4, margin: const EdgeInsets.all(1))),
                    Expanded(
                        child: Container(
                            color: c3, margin: const EdgeInsets.all(1))),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: c1, margin: const EdgeInsets.all(1))),
                    Expanded(
                        child: Container(
                            color: c2, margin: const EdgeInsets.all(1))),
                  ],
                ),
              ),
            ],
          ),
        );
      case 3:
        return ClipRRect(
          borderRadius: BorderRadius.circular(7.w),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(color: c4, margin: const EdgeInsets.all(1))),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                            color: c1, margin: const EdgeInsets.all(1))),
                    Expanded(
                        child: Container(
                            color: c2, margin: const EdgeInsets.all(1))),
                  ],
                ),
              ),
            ],
          ),
        );
      case 4:
        return ClipRRect(
          borderRadius: BorderRadius.circular(7.w),
          child: Column(
            children: [
              Expanded(
                  child: Container(color: c3, margin: const EdgeInsets.all(1))),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            color: c1, margin: const EdgeInsets.all(1))),
                    Expanded(
                        child: Container(
                            color: c2, margin: const EdgeInsets.all(1))),
                    Expanded(
                        child: Container(
                            color: c4, margin: const EdgeInsets.all(1))),
                  ],
                ),
              ),
            ],
          ),
        );
      case 5:
        return ClipRRect(
          borderRadius: BorderRadius.circular(7.w),
          child: Column(
            children: List.generate(3, (row) {
              final colors = [c4, c3, c1, c2, c1, c3, c1, c2, c4];
              return Expanded(
                child: Row(
                  children: List.generate(3, (col) {
                    return Expanded(
                      child: Container(
                        color: colors[row * 3 + col],
                        margin: const EdgeInsets.all(0.5),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
