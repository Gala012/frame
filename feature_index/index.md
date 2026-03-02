# FrameElevate Feature Index

## 工具方法

### 类名：`successToast` / `errorToast`
**路径：** `lib/utils/index.dart`  
**功能：** 底部 Toast 提示

**方法：**
- `successToast(String msg)`：绿色成功提示
- `errorToast(String msg)`：红色错误提示

---

### 类名：`TemplateLoader`
**路径：** `lib/utils/template_loader.dart`  
**功能：** 模板数据加载和管理

**方法：**
- `loadTemplates()`：加载所有模板数据（带缓存）
- `getTemplatesByCategory(templates, categoryKey)`：按分类获取模板
- `getTemplateById(templates, id)`：根据 ID 获取模板
- `clearCache()`：清除缓存

---

## 数据模型

### 类名：`TemplateData`
**路径：** `lib/models/template_data.dart`  
**功能：** 模板数据模型，包含 frame、mat、background 配置

**属性：**
- `id`：模板 ID
- `name`：模板名称
- `category`：分类显示名
- `categoryKey`：分类键（traditional/western/photography/modern/warm/exhibition）
- `frame`：画框 ID（可选）
- `mat`：Mat 配置（MatConfig）
- `background`：背景配置（BackgroundConfig）
- `previewPath`：预览图路径

**子类：**
- `MatConfig`：Mat 配置（size, color, texture）
- `BackgroundConfig`：背景配置（type, color/texture）

---

## 通用组件

### 类名：`FrameElevateTabView`
**路径：** `lib/pages/frame_elevate_tab/frame_elevate_tab_view.dart`  
**功能：** 底部导航 Tab 容器（Home / Gallery / Settings）

---

## 路由常量

### 类名：`FrameElevateNames`
**路径：** `lib/router/frame_elevate_names.dart`  
**功能：** 所有路由字符串常量

**常量：**
- `tab` → `/tab`
- `home` → `/home`
- `gallery` → `/gallery`
- `galleryPreview` → `/gallery/preview`
- `settings` → `/settings`
- `singlePick` → `/single-frame/pick`
- `singleCrop` → `/single-frame/crop`
- `singleEditor` → `/single-frame/editor`
- `batchPick` → `/batch-frame/pick`
- `batchEditor` → `/batch-frame/editor`
- `comboPick` → `/combo-frame/pick`
- `comboEditor` → `/combo-frame/editor`
- `photoCamera` → `/photo-frame/camera`
- `photoCrop` → `/photo-frame/crop`
- `photoEditor` → `/photo-frame/editor`

---

## 页面列表

| 页面 | 路径 | 路由 | 说明 |
|------|------|------|------|
| Tab容器 | `pages/frame_elevate_tab/` | `/tab` | 底部导航容器 |
| Home | `pages/frame_elevate_home/` | `/home` | 首页 4 功能入口 |
| Gallery | `pages/frame_elevate_gallery/` | `/gallery` | 瀑布流画廊 |
| Gallery Preview | `pages/frame_elevate_gallery_preview/` | `/gallery/preview` | 全屏作品预览 |
| Settings | `pages/frame_elevate_settings/` | `/settings` | 设置页 |
| Single Pick | `pages/frame_elevate_single_pick/` | `/single-frame/pick` | 单张选图 |
| Crop | `pages/frame_elevate_crop/` | `/single-frame/crop`, `/photo-frame/crop` | 裁剪页（共用） |
| Editor | `pages/frame_elevate_editor/` | `/single-frame/editor`, `/photo-frame/editor`, `/combo-frame/editor` | 编辑页（共用，7 工具 Tab） |
| Batch Pick | `pages/frame_elevate_batch_pick/` | `/batch-frame/pick` | 批量选图 |
| Batch Editor | `pages/frame_elevate_batch_editor/` | `/batch-frame/editor` | 批量编辑（8 工具 Tab + 缩略图条） |
| Combo Pick | `pages/frame_elevate_combo_pick/` | `/combo-frame/pick` | 组合选图 + 布局选择 |
| Camera | `pages/frame_elevate_camera/` | `/photo-frame/camera` | 拍照页（拍摄/确认） |
