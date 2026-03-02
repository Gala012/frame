import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages/frame_elevate_tab/frame_elevate_tab_binding.dart';
import '../pages/frame_elevate_tab/frame_elevate_tab_view.dart';
import '../pages/frame_elevate_home/frame_elevate_home_binding.dart';
import '../pages/frame_elevate_home/frame_elevate_home_view.dart';
import '../pages/frame_elevate_gallery/frame_elevate_gallery_binding.dart';
import '../pages/frame_elevate_gallery/frame_elevate_gallery_view.dart';
import '../pages/frame_elevate_gallery_preview/frame_elevate_gallery_preview_binding.dart';
import '../pages/frame_elevate_gallery_preview/frame_elevate_gallery_preview_view.dart';
import '../pages/frame_elevate_settings/frame_elevate_settings_binding.dart';
import '../pages/frame_elevate_settings/frame_elevate_settings_view.dart';
import '../pages/frame_elevate_single_pick/frame_elevate_single_pick_binding.dart';
import '../pages/frame_elevate_single_pick/frame_elevate_single_pick_view.dart';
import '../pages/frame_elevate_crop/frame_elevate_crop_binding.dart';
import '../pages/frame_elevate_crop/frame_elevate_crop_view.dart';
import '../pages/frame_elevate_editor/frame_elevate_editor_binding.dart';
import '../pages/frame_elevate_editor/frame_elevate_editor_view.dart';
import '../pages/frame_elevate_batch_pick/frame_elevate_batch_pick_binding.dart';
import '../pages/frame_elevate_batch_pick/frame_elevate_batch_pick_view.dart';
import '../pages/frame_elevate_batch_editor/frame_elevate_batch_editor_binding.dart';
import '../pages/frame_elevate_batch_editor/frame_elevate_batch_editor_view.dart';
import '../pages/frame_elevate_combo_pick/frame_elevate_combo_pick_binding.dart';
import '../pages/frame_elevate_combo_pick/frame_elevate_combo_pick_view.dart';
import '../pages/frame_elevate_camera/frame_elevate_camera_binding.dart';
import '../pages/frame_elevate_camera/frame_elevate_camera_view.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'db_frame_elevate/data.dart';
Color primaryColor = const Color(0xFFC9A96E);
Color bgColor = const Color(0xFFF5F2ED);
Color darkColor = const Color(0xFF1A1A1A);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await Get.putAsync(() => FrameElevateDB().init());
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Error initializing app: $e');
    debugPrint('Stack trace: $stackTrace');
    runApp(const MyApp());
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: Frame,
          initialRoute: '/frame_tab',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              surface: const Color(0xFFFFFFFF),
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: darkColor,
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(size: 22.w, color: darkColor),
            ),
            dividerTheme: DividerThemeData(
              thickness: 1,
              color: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }
}
List<GetPage<dynamic>> Frame = [
  GetPage(
    name: '/frame_tab',
    page: () => const FrameElevateTabView(),
    binding: FrameElevateTabBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/frame_home',
    page: () => const FrameElevateHomeView(),
    binding: FrameElevateHomeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/frame_gallery',
    page: () => const FrameElevateGalleryView(),
    binding: FrameElevateGalleryBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/gallery/preview',
    page: () => const FrameElevateGalleryPreviewView(),
    binding: FrameElevateGalleryPreviewBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/frame_settings',
    page: () => const FrameElevateSettingsView(),
    binding: FrameElevateSettingsBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/single-frame/pick',
    page: () => const FrameElevateSinglePickView(),
    binding: FrameElevateSinglePickBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/single-frame/crop',
    page: () => const FrameElevateCropView(),
    binding: FrameElevateCropBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/single-frame/editor',
    page: () => const FrameElevateEditorView(),
    binding: FrameElevateEditorBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/batch-frame/pick',
    page: () => const FrameElevateBatchPickView(),
    binding: FrameElevateBatchPickBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/batch-frame/editor',
    page: () => const FrameElevateBatchEditorView(),
    binding: FrameElevateBatchEditorBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/combo-frame/pick',
    page: () => const FrameElevateComboPickView(),
    binding: FrameElevateComboPickBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/combo-frame/editor',
    page: () => const FrameElevateEditorView(),
    binding: FrameElevateEditorBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/photo-frame/camera',
    page: () => const FrameElevateCameraView(),
    binding: FrameElevateCameraBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/photo-frame/crop',
    page: () => const FrameElevateCropView(),
    binding: FrameElevateCropBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/photo-frame/editor',
    page: () => const FrameElevateEditorView(),
    binding: FrameElevateEditorBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
];