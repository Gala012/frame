# 脚本工具说明

## 📋 可用脚本

### 1. `download_template_resources.py` - 模板资源下载脚本

**功能：**
- 为模板功能生成资源下载清单
- 自动创建文件夹结构
- 生成详细的下载指南文档

**使用方法：**

```bash
# 基本用法（生成下载清单和文件夹）
python3 scripts/download_template_resources.py

# 查看生成的下载指南
open assets/templates/DOWNLOAD_GUIDE.md
```

**输出：**
- ✅ 创建 6 个类别文件夹（traditional, western, photography, modern, warm, exhibition）
- ✅ 生成完整的下载指南 `assets/templates/DOWNLOAD_GUIDE.md`
- ✅ 提供 30 个模板的下载链接和搜索词

**下载资源：**

根据生成的 `DOWNLOAD_GUIDE.md` 文档，从以下免费网站下载图片：
- Unsplash: https://unsplash.com （推荐）
- Pexels: https://www.pexels.com
- Pixabay: https://pixabay.com

所有网站均提供免费商用许可，无需署名。

---

## 🚀 未来扩展

### 自动下载功能（待实现）

如果您有 Unsplash 或 Pexels 的 API Key，可以实现自动下载：

```bash
python3 scripts/download_template_resources.py --auto-download
```

**获取 API Key：**
- Unsplash API: https://unsplash.com/developers
- Pexels API: https://www.pexels.com/api/

---

## 📁 项目结构

```
frame_elevate/
├── scripts/
│   ├── README.md                          # 本文档
│   └── download_template_resources.py     # 模板资源下载脚本
├── assets/
│   └── templates/
│       ├── templates.json                 # 模板配置文件
│       ├── DOWNLOAD_GUIDE.md              # 自动生成的下载指南
│       ├── traditional/                   # 传统风格模板
│       ├── western/                       # 西方艺术模板
│       ├── photography/                   # 摄影风格模板
│       ├── modern/                        # 现代风格模板
│       ├── warm/                          # 温暖风格模板
│       └── exhibition/                    # 展览风格模板
```

---

## 💡 提示

1. **优先使用免费资源**：所有推荐网站均提供 CC0/公共领域许可
2. **图片质量要求**：建议下载至少 1200×800px 的图片
3. **文件命名规范**：严格按照 `{template_id}_preview.jpg` 格式命名
4. **压缩图片**：使用 TinyJPG 或 ImageOptim 压缩图片至 < 500KB

---

**Created:** 2026-02-28
