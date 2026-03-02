import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_elevate_batch_editor_logic.dart';
class FrameElevateBatchEditorView
    extends GetView<FrameElevateBatchEditorLogic> {
  const FrameElevateBatchEditorView({super.key});
  static const _tabs = [
    {'icon': Icons.border_all_rounded, 'label': 'Frame'},
    {'icon': Icons.crop_square_rounded, 'label': 'Mat'},
    {'icon': Icons.layers_rounded, 'label': 'Template'},
    {'icon': Icons.palette_outlined, 'label': 'Background'},
    {'icon': Icons.auto_fix_high_outlined, 'label': 'Filter'},
  ];
  static const _frameCategories = [
    'Fine Art',
    'Oil',
    'Modern',
    'Photography',
    'Calligraphy',
    'Scroll',
    'Chinese Painting',
  ];
  static const _filterNames = [
    'Original',
    'B&W',
    'Vintage',
    'Cool',
    'Warm',
    'Fade',
    'Vivid',
    'Ink'
  ];
  static const _matSizes = ['None', 'Thin', 'Medium', 'Wide', 'Extra Wide'];
  static const _matColors = [
    Color(0xFFFFFFFF),
    Color(0xFFF5F5F0),
    Color(0xFFFAF0E6),
    Color(0xFFF0EAD6),
    Color(0xFFE8E4D4),
    Color(0xFFD4C5A9),
    Color(0xFFC8B89A),
    Color(0xFFE0E0E0),
    Color(0xFFB0B0B0),
    Color(0xFF808080),
    Color(0xFF404040),
    Color(0xFF1A1A1A),
    Color(0xFF2C3E50),
    Color(0xFF3D2B1F),
    Color(0xFF5C4033),
    Color(0xFF8B7355),
  ];
  static const _bgColors = [
    Color(0xFFFFFFFF),
    Color(0xFFFFFFF0),
    Color(0xFFFFF8E7),
    Color(0xFFF0F0F0),
    Color(0xFFC0C0C0),
    Color(0xFF36454F),
    Color(0xFF0A0A0A),
    Color(0xFF1B2A4A),
    Color(0xFFE8DCC8),
    Color(0xFFC9B99A),
    Color(0xFF6B4226),
    Color(0xFF4A6C8C),
    Color(0xFF2D4A2D),
    Color(0xFFF7F5F2),
    Color(0xFF878787),
    Color(0xFF1A1A1A),
  ];
  static const _bgColorNames = [
    'Pure White',
    'Ivory',
    'Cream',
    'Light Gray',
    'Silver',
    'Charcoal',
    'Black',
    'Deep Navy',
    'Warm Beige',
    'Sand',
    'Warm Brown',
    'Slate Blue',
    'Forest',
    'Gallery White',
    'Museum Gray',
    'Loft Black',
  ];
  static const _templateCategories = [
    'Traditional',
    'Western',
    'Photography',
    'Modern',
    'Warm',
    'Exhibition'
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.onBackTap();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111111),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          leading: GestureDetector(
            onTap: controller.onBackTap,
            child: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 18.w),
            ),
          ),
          title: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.pageTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    controller.currentPhotoIndexText,
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Obx(() => GestureDetector(
                    onTap:
                        controller.isSaving.value ? null : controller.onSaveTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.isSaving.value
                            ? const Color(0xFF888888)
                            : const Color(0xFFC9A96E),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                      child: controller.isSaving.value
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  )),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: const Color(0xFF333333), height: 1),
          ),
        ),
        body: Column(
          children: [
            Expanded(child: _buildPreviewArea()),
            _buildPhotoThumbnailBar(),
            Obx(() => _buildToolPanel()),
            _buildToolTabBar(),
          ],
        ),
      ),
    );
  }
  Widget _buildPreviewArea() {
    return Obx(() {
      final bgColor = controller.currentBgColor;
      final matColor = controller.currentMatColor;
      final hasMat = controller.matSize.value > 0;
      final matPad = [0.0, 8.0, 16.0, 24.0, 36.0][controller.matSize.value];
      double previewWidth = 260.w;
      double previewHeight = 260.w;
      final frameMeta = controller.currentFrameMeta.value;
      double frameWidth = 0;
      double frameOuterEdge = 0;
      if (controller.selectedFrameIndex.value >= 0) {
        if (frameMeta != null && frameMeta.borderWidth > 0) {
          final widthMultipliers = [0.5, 0.8, 1.0];
          final multiplier = widthMultipliers[controller.frameWidthIndex.value];
          frameWidth = frameMeta.borderWidth.toDouble() * multiplier;
        } else {
          final frameWidthPercent =
              [0.06, 0.10, 0.15][controller.frameWidthIndex.value];
          frameWidth =
              (previewWidth < previewHeight ? previewWidth : previewHeight) *
                  frameWidthPercent;
        }
        final frameInnerBorder = frameWidth * 0.4;
        frameOuterEdge = frameWidth - frameInnerBorder;
      }
      return RepaintBoundary(
        key: controller.previewKey,
        child: Container(
          decoration: BoxDecoration(
            color: controller.bgScenePath.value != null
                ? Colors.transparent
                : bgColor,
            image: controller.bgScenePath.value != null
                ? DecorationImage(
                    image: AssetImage(controller.bgScenePath.value!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Center(
            child: SizedBox(
              width: previewWidth,
              height: previewHeight,
              child: Stack(
                children: [
                  if (hasMat)
                    Positioned(
                      left: frameOuterEdge,
                      top: frameOuterEdge,
                      right: frameOuterEdge,
                      bottom: frameOuterEdge,
                      child: Container(
                        decoration: BoxDecoration(
                          color: matColor,
                        ),
                        padding: EdgeInsets.all(matPad.w),
                      ),
                    ),
                  Positioned(
                    left: frameOuterEdge + (hasMat ? matPad.w : 0),
                    top: frameOuterEdge + (hasMat ? matPad.w : 0),
                    right: frameOuterEdge + (hasMat ? matPad.w : 0),
                    bottom: frameOuterEdge + (hasMat ? matPad.w : 0),
                    child: controller.photoFile.value != null
                        ? ColorFiltered(
                            colorFilter: _getFilterColorFilter(
                                controller.filterIndex.value,
                                controller.filterIntensity.value),
                            child: Image.file(
                              controller.photoFile.value!,
                              fit: BoxFit.contain,
                              key: ValueKey(controller.photoFile.value!.path),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFE8E4DE),
                            child: Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 48.w,
                                color: const Color(0xFFCCCCCC),
                              ),
                            ),
                          ),
                  ),
                  if (controller.selectedFrameIndex.value >= 0)
                    _build9PatchFrame(previewWidth, previewHeight, frameWidth),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
  Widget _buildFrameImage(String imagePath, {EdgeInsets? insets}) {
    final image = Image.asset(imagePath, fit: BoxFit.fill);
    if (insets == null) return image;
    return ClipRect(
      child: Padding(
        padding: insets,
        child: image,
      ),
    );
  }
  Widget _build9PatchFrame(double width, double height, double frameWidth) {
    final framePath = controller.selectedFramePath;
    if (framePath == null) return const SizedBox.shrink();
    final frameMeta = controller.currentFrameMeta.value;
    final frameInnerBorder = frameWidth * 0.4;
    final frameOuterEdge = frameWidth - frameInnerBorder;
    final topEdgeHeight = frameMeta?.edges?.top.toDouble() ?? frameOuterEdge;
    final bottomEdgeHeight =
        frameMeta?.edges?.bottom.toDouble() ?? frameOuterEdge;
    final leftEdgeWidth = frameMeta?.edges?.left.toDouble() ?? frameOuterEdge;
    final rightEdgeWidth = frameMeta?.edges?.right.toDouble() ?? frameOuterEdge;
    final maxEdgeSize = [
      topEdgeHeight,
      bottomEdgeHeight,
      leftEdgeWidth,
      rightEdgeWidth
    ].reduce((a, b) => a > b ? a : b);
    final cornerMultiplier = frameMeta?.cornerSizeMultiplier ?? 3.6;
    final cornerSize = maxEdgeSize * cornerMultiplier;
    final imageInsets = frameMeta?.imageInsets;
    return Stack(
      children: [
        Positioned(
          left: cornerSize,
          top: 0,
          right: cornerSize,
          height: topEdgeHeight,
          child: _buildFrameImage('$framePath/top.png', insets: imageInsets),
        ),
        Positioned(
          left: cornerSize,
          bottom: 0,
          right: cornerSize,
          height: bottomEdgeHeight,
          child: Transform.flip(
            flipY: true,
            child: _buildFrameImage('$framePath/top.png', insets: imageInsets),
          ),
        ),
        Positioned(
          left: 0,
          top: cornerSize,
          bottom: cornerSize,
          width: leftEdgeWidth,
          child: _buildFrameImage('$framePath/left.png', insets: imageInsets),
        ),
        Positioned(
          right: 0,
          top: cornerSize,
          bottom: cornerSize,
          width: rightEdgeWidth,
          child: Transform.flip(
            flipX: true,
            child: _buildFrameImage('$framePath/left.png', insets: imageInsets),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          width: cornerSize,
          height: cornerSize,
          child: _buildFrameImage('$framePath/tl.png', insets: imageInsets),
        ),
        Positioned(
          right: 0,
          top: 0,
          width: cornerSize,
          height: cornerSize,
          child: _buildFrameImage('$framePath/tr.png', insets: imageInsets),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          width: cornerSize,
          height: cornerSize,
          child: _buildFrameImage('$framePath/bl.png', insets: imageInsets),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          width: cornerSize,
          height: cornerSize,
          child: _buildFrameImage('$framePath/br.png', insets: imageInsets),
        ),
      ],
    );
  }
  Widget _buildToolTabBar() {
    return Obx(() => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            border: Border(top: BorderSide(color: Color(0xFF223333))),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(bottom: 24.h),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final isActive = controller.activeTab.value == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.onTabTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _tabs[i]['icon'] as IconData,
                        size: 16.w,
                        color: isActive
                            ? const Color(0xFFC9A96E)
                            : const Color(0xFF888888),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        _tabs[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? const Color(0xFFC9A96E)
                              : const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ));
  }
  Widget _buildToolPanel() {
    switch (controller.activeTab.value) {
      case 0:
        return _buildFramePanel();
      case 1:
        return _buildMatPanel();
      case 2:
        return _buildTemplatePanel();
      case 3:
        return _buildBackgroundPanel();
      case 4:
        return _buildFilterPanel();
      default:
        return const SizedBox.shrink();
    }
  }
  Widget _buildFramePanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: const Color(0xFF333333)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCategoryChips(_frameCategories,
                    controller.frameCategory, controller.onFrameCategoryTap),
              ),
              Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: Obx(() => controller.selectedFrameIndex.value >= 0
                    ? GestureDetector(
                        onTap: controller.onRemoveFrame,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2420),
                            borderRadius: BorderRadius.circular(6.w),
                            border: Border.all(color: const Color(0xFF444444)),
                          ),
                          child: Icon(
                            Icons.block,
                            size: 20.w,
                            color: const Color(0xFFFF6B6B),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildFrameThumbnails(),
          SizedBox(height: 10.h),
          _buildWidthSelector(),
        ],
      ),
    );
  }
  Widget _buildCategoryChips(
      List<String> categories, RxInt selected, void Function(int) onTap) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: List.generate(categories.length, (i) {
              final isSelected = selected.value == i;
              return GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFC9A96E)
                        : const Color(0xFF2A2420),
                    borderRadius: BorderRadius.circular(20.w),
                    border: isSelected
                        ? null
                        : Border.all(color: const Color(0xFF444444)),
                  ),
                  child: Text(
                    categories[i],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isSelected ? Colors.white : const Color(0xFFAAAAAA),
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }
  Widget _buildFrameThumbnails() {
    return Obx(() {
      final frames = controller.currentCategoryFrames;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: List.generate(frames.length, (i) {
            final isSelected = controller.selectedFrameIndex.value == i;
            final framePath = frames[i];
            return GestureDetector(
              onTap: () => controller.onFrameSelect(i),
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Column(
                  children: [
                    Container(
                      width: 62.w,
                      height: 62.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFC9A96E)
                              : const Color(0xFF444444),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10.w),
                        color: const Color(0xFF2A2420),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9.w),
                        child: Image.asset(
                          '$framePath/tl.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: const Color(0xFF2A2420),
                            child: Icon(
                              Icons.broken_image,
                              size: 24.w,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Frame ${i + 1}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isSelected
                            ? const Color(0xFFC9A96E)
                            : const Color(0xFF888888),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
  Widget _buildWidthSelector() {
    return Obx(() => Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Text('Width:',
                  style: TextStyle(
                      fontSize: 11.sp, color: const Color(0xFF888888))),
              SizedBox(width: 8.w),
              ...List.generate(['Medium', 'Bold', 'Extra'].length, (i) {
                final label = ['Medium', 'Bold', 'Extra'][i];
                final isActive = controller.frameWidthIndex.value == i;
                return GestureDetector(
                  onTap: () => controller.onFrameWidthTap(i),
                  child: Container(
                    margin: EdgeInsets.only(right: 6.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFC9A96E)
                          : const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color:
                            isActive ? Colors.white : const Color(0xFF888888),
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ));
  }
  Widget _buildMatPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Color(0xFF333333)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Obx(() => _buildSubTabs(
              ['Size', 'Color'], controller.matTab, controller.onMatTabTap)),
          SizedBox(height: 12.h),
          Obx(() {
            switch (controller.matTab.value) {
              case 0:
                return _buildMatSizePanel();
              case 1:
                return _buildMatColorPanel();
              default:
                return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
  Widget _buildSubTabs(
      List<String> labels, RxInt selected, void Function(int) onTap) {
    return Row(
      children: List.generate(labels.length, (i) {
        final isSelected = selected.value == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              padding: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? const Color(0xFFC9A96E)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFFC9A96E)
                      : const Color(0xFF888888),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
  Widget _buildMatSizePanel() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: List.generate(_matSizes.length, (i) {
              final isSelected = controller.matSize.value == i;
              return GestureDetector(
                onTap: () => controller.onMatSizeTap(i),
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Column(
                    children: [
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFC9A96E)
                                : const Color(0xFF444444),
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8.w),
                          color: const Color(0xFF2A2420),
                        ),
                        child: Center(
                          child: Container(
                            width: (32 - i * 5.0).clamp(12.0, 32.0).w,
                            height: (32 - i * 5.0).clamp(12.0, 32.0).w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFC9A96E)
                                    : const Color(0xFF888888),
                              ),
                              color: isSelected
                                  ? const Color(0xFFC9A96E)
                                      .withValues(alpha: 0.2)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _matSizes[i],
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isSelected
                              ? const Color(0xFFC9A96E)
                              : const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ));
  }
  Widget _buildMatColorPanel() {
    return SizedBox(
      height: 80.h,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.w,
          crossAxisSpacing: 8.h,
        ),
        itemCount: _matColors.length,
        itemBuilder: (context, i) {
          return Obx(() {
            final isSelected = controller.matColorIndex.value == i;
            return GestureDetector(
              onTap: () => controller.onMatColorTap(i),
              child: Container(
                decoration: BoxDecoration(
                  color: _matColors[i],
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFC9A96E)
                        : const Color(0xFF444444),
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Icon(Icons.check,
                            size: 14.w,
                            color: _matColors[i].computeLuminance() > 0.5
                                ? Colors.black54
                                : Colors.white70),
                      )
                    : null,
              ),
            );
          });
        },
      ),
    );
  }
  Widget _buildTemplatePanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Color(0xFF333333)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          _buildCategoryChips(_templateCategories, controller.templateCategory,
              controller.onTemplateCategoryTap),
          SizedBox(height: 12.h),
          Obx(() {
            final templates = controller.currentCategoryTemplates;
            if (templates.isEmpty) {
              return SizedBox(
                height: 100.h,
                child: Center(
                  child: Text(
                    'Loading templates...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF888888),
                    ),
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: List.generate(templates.length, (i) {
                  final template = templates[i];
                  final isSelected =
                      controller.selectedTemplateIndex.value == i;
                  return GestureDetector(
                    onTap: () => controller.onTemplateSelect(i),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Column(
                        children: [
                          Container(
                            width: 70.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFC9A96E)
                                    : const Color(0xFF444444),
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10.w),
                              color: const Color(0xFF2A2420),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9.w),
                              child: Image.asset(
                                template.previewPath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF2A2420),
                                          Color(0xFF1A1A1A)
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          color: const Color(0xFF666666),
                                          size: 24.w,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Preview\nMissing',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: const Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              template.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: isSelected
                                    ? const Color(0xFFC9A96E)
                                    : const Color(0xFF888888),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
  Widget _buildBackgroundPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Color(0xFF333333)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: _buildBgSolidPanel(),
    );
  }
  Widget _buildBgSolidPanel() {
    return SizedBox(
      height: 90.h,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 6.w,
          crossAxisSpacing: 6.h,
        ),
        itemCount: _bgColors.length,
        itemBuilder: (context, i) {
          return Obx(() {
            final isSelected = controller.bgColorIndex.value == i;
            return GestureDetector(
              onTap: () => controller.onBgColorTap(i),
              child: Tooltip(
                message: _bgColorNames[i],
                child: Container(
                  decoration: BoxDecoration(
                    color: _bgColors[i],
                    borderRadius: BorderRadius.circular(6.w),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFC9A96E)
                          : const Color(0xFF444444),
                      width: isSelected ? 2.5 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Icon(Icons.check,
                              size: 14.w,
                              color: _bgColors[i].computeLuminance() > 0.5
                                  ? Colors.black54
                                  : Colors.white70),
                        )
                      : null,
                ),
              ),
            );
          });
        },
      ),
    );
  }
  Widget _buildFilterPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Color(0xFF333333)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  children: List.generate(_filterNames.length, (i) {
                    final isSelected = controller.filterIndex.value == i;
                    return GestureDetector(
                      onTap: () => controller.onFilterTap(i),
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Column(
                          children: [
                            Container(
                              width: 58.w,
                              height: 58.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFC9A96E)
                                      : const Color(0xFF444444),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8.w),
                              ),
                              child: controller.photoFile.value != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(7.w),
                                      child: ColorFiltered(
                                        colorFilter:
                                            _getFilterColorFilter(i, 1.0),
                                        child: Image.file(
                                          controller.photoFile.value!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A2420),
                                        borderRadius:
                                            BorderRadius.circular(7.w),
                                      ),
                                      child: Icon(Icons.image_outlined,
                                          size: 22.w,
                                          color: Colors.white
                                              .withValues(alpha: 0.5)),
                                    ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _filterNames[i],
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: isSelected
                                    ? const Color(0xFFC9A96E)
                                    : const Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              )),
          SizedBox(height: 10.h),
          Obx(() => Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  children: [
                    Text('Intensity:',
                        style: TextStyle(
                            fontSize: 11.sp, color: const Color(0xFF888888))),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(Get.context!).copyWith(
                          activeTrackColor: const Color(0xFFC9A96E),
                          inactiveTrackColor: const Color(0xFF444444),
                          thumbColor: const Color(0xFFC9A96E),
                          overlayColor:
                              const Color(0xFFC9A96E).withValues(alpha: 0.2),
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: controller.filterIntensity.value,
                          onChanged: controller.onFilterIntensityChanged,
                        ),
                      ),
                    ),
                    Text(
                      '${(controller.filterIntensity.value * 100).round()}%',
                      style: TextStyle(
                          fontSize: 11.sp, color: const Color(0xFF888888)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
  ColorFilter _getFilterColorFilter(int filterIndex, double intensity) {
    switch (filterIndex) {
      case 0:
        return const ColorFilter.mode(Colors.transparent, BlendMode.dst);
      case 1:
        return ColorFilter.mode(
          Colors.grey.withValues(alpha: intensity),
          BlendMode.saturation,
        );
      case 2:
        return ColorFilter.mode(
          Color.lerp(Colors.transparent,
              const Color(0xFF8B6914).withValues(alpha: 0.4), intensity)!,
          BlendMode.overlay,
        );
      case 3:
        return ColorFilter.mode(
          Color.lerp(Colors.transparent,
              const Color(0xFF4A6C8C).withValues(alpha: 0.3), intensity)!,
          BlendMode.overlay,
        );
      case 4:
        return ColorFilter.mode(
          Color.lerp(Colors.transparent,
              const Color(0xFFC9A96E).withValues(alpha: 0.3), intensity)!,
          BlendMode.overlay,
        );
      case 5:
        return ColorFilter.mode(
          Color.lerp(Colors.transparent, Colors.white.withValues(alpha: 0.4),
              intensity)!,
          BlendMode.lighten,
        );
      case 6:
        return ColorFilter.mode(
          Color.lerp(
              Colors.transparent,
              const Color(0xFF00FF00).withValues(alpha: 0.15),
              intensity * 0.5)!,
          BlendMode.saturation,
        );
      case 7:
        return ColorFilter.mode(
          Color.lerp(Colors.transparent, Colors.black.withValues(alpha: 0.4),
              intensity)!,
          BlendMode.multiply,
        );
      default:
        return const ColorFilter.mode(Colors.transparent, BlendMode.dst);
    }
  }
  Widget _buildPhotoThumbnailBar() {
    return Container(
      height: 80.h,
      color: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          Container(
            height: 1,
            color: const Color(0xFF333333),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              itemCount: controller.photoFiles.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final isActive = controller.currentPhotoIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.onPhotoSwitch(index),
                    child: Container(
                      width: 64.w,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFFC9A96E)
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.w),
                        child: controller.photoFiles[index].existsSync()
                            ? Image.file(
                                controller.photoFiles[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFF333333),
                                    child: Icon(Icons.broken_image,
                                        size: 20.w,
                                        color: const Color(0xFF666666)),
                                  );
                                },
                              )
                            : Container(
                                color: const Color(0xFF333333),
                                child: Icon(Icons.image_outlined,
                                    size: 20.w,
                                    color: const Color(0xFF666666)),
                              ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
