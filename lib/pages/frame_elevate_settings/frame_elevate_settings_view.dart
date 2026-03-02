import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_elevate_settings_logic.dart';
class FrameElevateSettingsView extends GetView<FrameElevateSettingsLogic> {
  const FrameElevateSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          'Settings',
          style: TextStyle(
            color: const Color(0xFFC9A96E),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppInfoSection(),
            SizedBox(height: 8.h),
            _buildDataManagementSection(),
            SizedBox(height: 8.h),
            _buildFooter(),
          ],
        ),
      ),
    );
  }
  Widget _buildAppInfoSection() {
    return Container(
      color: const Color(0xFFEDE7E3),
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1A1A), Color(0xFF2D2520)],
              ),
              borderRadius: BorderRadius.circular(22.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.image_outlined,
              size: 34.w,
              color: const Color(0xFFC9A96E),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'FrameElevate',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Frame your art, elevate your world',
            style: TextStyle(
              color: const Color(0xFFAAAAAA),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E4DE),
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Text(
              'Version v1.0.0',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF666666),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDataManagementSection() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
            child: Text(
              'DATA MANAGEMENT',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFAAAAAA),
                letterSpacing: 1,
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.onClearData,
            child: _buildSettingRow(
              iconBg: const Color(0xFFFFE8E8),
              icon: Icons.delete_outline,
              iconColor: const Color(0xFFE05555),
              title: 'Clear Data',
              subtitle: 'Remove all history records & cache',
              borderBottom: true,
              trailing: Icon(
                Icons.chevron_right,
                color: const Color(0xFFAAAAAA),
                size: 16.w,
              ),
            ),
          ),
          _buildStorageRow(),
        ],
      ),
    );
  }
  Widget _buildSettingRow({
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool borderBottom = false,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: borderBottom
            ? const Border(
                bottom: BorderSide(color: Color(0xFFF0EDE8)),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Icon(icon, color: iconColor, size: 18.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
  Widget _buildStorageRow() {
    return Obx(() => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Icon(
                  Icons.storage_outlined,
                  color: const Color(0xFF5A7BA6),
                  size: 18.w,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storage Used',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${controller.artworkCount.value} artworks · ${controller.storageMB.value} MB',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.w),
                      child: LinearProgressIndicator(
                        value: controller.storagePercentage.value / 100,
                        backgroundColor: const Color(0xFFE8E4DE),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFFC9A96E),
                        ),
                        minHeight: 4.h,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${controller.storagePercentage.value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFFAAAAAA),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        '© 2026 FrameElevate\nAll rights reserved',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFFAAAAAA),
          height: 1.6,
        ),
      ),
    );
  }
}
