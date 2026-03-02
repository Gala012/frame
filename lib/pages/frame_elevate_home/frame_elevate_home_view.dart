import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_elevate_home_logic.dart';
class FrameElevateHomeView extends GetView<FrameElevateHomeLogic> {
  const FrameElevateHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F2ED),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              _buildBrandArea(context),
              _buildFunctionCards(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildBrandArea(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF2D2520)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          24.w, 20.h + MediaQuery.of(context).padding.top, 24.w, 28.h),
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC9A96E), Color(0xFF8B6914)],
              ),
              borderRadius: BorderRadius.circular(20.w),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC9A96E).withValues(alpha: 0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.image_outlined,
              size: 32.w,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'FrameElevate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Frame your art, elevate your world',
            style: TextStyle(
              color: const Color(0xFFAAAAAA),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFunctionCards() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 14.h),
            child: Text(
              'CHOOSE A FRAMING MODE',
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          _buildFeatureCard(
            icon: Icons.image_outlined,
            iconBg: const Color(0xFFC9A96E),
            accentColor: const Color(0xFFC9A96E),
            title: 'Single Frame',
            subtitle:
                'Pick one photo from your gallery and add a beautiful frame',
            onTap: controller.onSingleFrameTap,
          ),
          SizedBox(height: 12.h),
          _buildFeatureCard(
            icon: Icons.photo_library_outlined,
            iconBg: const Color(0xFF8B6914),
            accentColor: const Color(0xFF8B6914),
            title: 'Batch Frame',
            subtitle: 'Apply the same frame style to multiple photos at once',
            onTap: controller.onBatchFrameTap,
          ),
          SizedBox(height: 12.h),
          _buildFeatureCard(
            icon: Icons.grid_view_rounded,
            iconBg: const Color(0xFF4A7C59),
            accentColor: const Color(0xFF4A7C59),
            title: 'Combo Frame',
            subtitle: 'Combine multiple photos into one framed collage layout',
            onTap: controller.onComboFrameTap,
          ),
          SizedBox(height: 12.h),
          _buildFeatureCard(
            icon: Icons.camera_alt_outlined,
            iconBg: const Color(0xFF5A7BA6),
            accentColor: const Color(0xFF5A7BA6),
            title: 'Scan & Frame',
            subtitle:
                'Photograph your artwork with the camera and frame it instantly',
            onTap: controller.onScanFrameTap,
          ),
        ],
      ),
    );
  }
  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconBg,
    required Color accentColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          border: Border(
            left: BorderSide(color: accentColor, width: 4.w),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    iconBg.withValues(alpha: 0.13),
                    iconBg.withValues(alpha: 0.27),
                  ],
                ),
                borderRadius: BorderRadius.circular(14.w),
              ),
              child: Icon(icon, size: 22.w, color: iconBg),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF888888),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right,
              size: 18.w,
              color: const Color(0xFFAAAAAA),
            ),
          ],
        ),
      ),
    );
  }
}
