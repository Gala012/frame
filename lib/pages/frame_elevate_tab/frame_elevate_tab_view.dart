import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../frame_elevate_home/frame_elevate_home_view.dart';
import '../frame_elevate_gallery/frame_elevate_gallery_view.dart';
import '../frame_elevate_settings/frame_elevate_settings_view.dart';
import 'frame_elevate_tab_logic.dart';
class FrameElevateTabView extends GetView<FrameElevateTabLogic> {
  const FrameElevateTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            FrameElevateHomeView(),
            FrameElevateGalleryView(),
            FrameElevateSettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => _buildBottomNav()),
    );
  }
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 18.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(Icons.home, 'Home', 0),
            _buildTabItem(Icons.grid_view_rounded, 'Gallery', 1),
            _buildTabItem(Icons.settings, 'Settings', 2),
          ],
        ),
      ),
    );
  }
  Widget _buildTabItem(IconData icon, String label, int index) {
    final isActive = controller.currentIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onTabChange(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22.w,
              color: isActive ? const Color(0xFFC9A96E) : const Color(0xFF666666),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? const Color(0xFFC9A96E) : const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
