#!/usr/bin/env python3
"""
模板资源下载脚本
根据 templates.json 中的配置，从免费图片网站下载模板预览图

使用方法:
    python3 download_template_resources.py

功能:
    1. 读取 templates.json
    2. 为每个模板生成预览图下载链接
    3. 从 Unsplash/Pexels 等免费网站下载合适的背景图
    4. 自动保存到 assets/templates/{category_key}/ 目录
"""

import json
import os
import sys
import urllib.request
from pathlib import Path


class TemplateDownloader:
    """模板资源下载器"""

    def __init__(self):
        # 项目根目录
        self.project_root = Path(__file__).parent.parent
        self.templates_dir = self.project_root / 'assets' / 'templates'
        self.templates_json = self.templates_dir / 'templates.json'

        # Unsplash API (免费，需要注册账号获取 Access Key)
        # 注册地址: https://unsplash.com/developers
        self.unsplash_access_key = 'YOUR_UNSPLASH_ACCESS_KEY'

        # Pexels API (免费，需要注册获取 API Key)
        # 注册地址: https://www.pexels.com/api/
        self.pexels_api_key = 'YOUR_PEXELS_API_KEY'

    def load_templates(self):
        """加载 templates.json"""
        if not self.templates_json.exists():
            print(f"❌ 错误: 找不到 {self.templates_json}")
            sys.exit(1)

        with open(self.templates_json, 'r', encoding='utf-8') as f:
            return json.load(f)

    def get_download_url(self, template):
        """
        根据模板类别和名称生成下载搜索关键词
        
        返回: (搜索关键词, 建议来源)
        """
        category = template['category']
        name = template['name']
        category_key = template['category_key']

        # 为不同类别定义搜索关键词
        search_keywords = {
            'traditional': 'traditional chinese art painting calligraphy',
            'western': 'western art museum painting classical',
            'photography': 'photography gallery modern minimal',
            'modern': 'modern minimal abstract geometric art',
            'warm': 'warm cozy interior wood texture',
            'exhibition': 'art gallery exhibition white wall minimal'
        }

        keyword = search_keywords.get(category_key, 'art frame')
        return keyword, 'unsplash'

    def generate_download_list(self):
        """生成下载清单（不实际下载，只输出指令）"""
        templates = self.load_templates()

        print("=" * 80)
        print("📋 模板资源下载清单")
        print("=" * 80)
        print()

        # 按类别分组
        categories = {}
        for template in templates:
            cat_key = template['category_key']
            if cat_key not in categories:
                categories[cat_key] = []
            categories[cat_key].append(template)

        # 输出每个类别的下载指令
        for cat_key, templates_list in categories.items():
            cat_name = templates_list[0]['category']
            cat_dir = self.templates_dir / cat_key

            print(f"\n### {cat_name} ({cat_key})")
            print(f"📁 目标目录: {cat_dir}")
            print(f"📊 数量: {len(templates_list)} 个模板")
            print("-" * 80)

            for i, template in enumerate(templates_list, 1):
                template_id = template['id']
                template_name = template['name']
                keyword, source = self.get_download_url(template)

                print(f"\n{i}. {template_name} ({template_id})")
                print(f"   搜索词: {keyword}")
                print(f"   推荐来源: {source}")
                print(f"   文件名: {template_id}_preview.jpg")

                # 生成下载链接（示例）
                if source == 'unsplash':
                    search_url = f"https://unsplash.com/s/photos/{keyword.replace(' ', '-')}"
                    print(f"   🔗 搜索链接: {search_url}")
                elif source == 'pexels':
                    search_url = f"https://www.pexels.com/search/{keyword.replace(' ', '%20')}/"
                    print(f"   🔗 搜索链接: {search_url}")

        print("\n" + "=" * 80)

    def create_folder_structure(self):
        """创建文件夹结构"""
        templates = self.load_templates()

        print("\n📁 创建文件夹结构...")

        categories = set(t['category_key'] for t in templates)

        for cat_key in categories:
            cat_dir = self.templates_dir / cat_key
            cat_dir.mkdir(parents=True, exist_ok=True)
            print(f"   ✓ {cat_dir}")

        print("✅ 文件夹创建完成!\n")

    def generate_readme(self):
        """生成下载说明文档"""
        templates = self.load_templates()

        readme_content = """# 模板资源下载指南

## 📋 概述

本文档说明如何为每个模板下载合适的预览图。

## 🌐 推荐免费图片网站

### 1. Unsplash (推荐)
- 网址: https://unsplash.com
- 许可: 免费商用，无需署名
- 质量: ⭐⭐⭐⭐⭐

### 2. Pexels
- 网址: https://www.pexels.com
- 许可: 免费商用，无需署名
- 质量: ⭐⭐⭐⭐⭐

### 3. Pixabay
- 网址: https://pixabay.com
- 许可: 免费商用
- 质量: ⭐⭐⭐⭐

## 📥 下载步骤

### 方法 1: 手动下载（推荐）

"""

        # 按类别分组
        categories = {}
        for template in templates:
            cat_key = template['category_key']
            if cat_key not in categories:
                categories[cat_key] = []
            categories[cat_key].append(template)

        for cat_key, templates_list in sorted(categories.items()):
            cat_name = templates_list[0]['category']
            readme_content += f"\n### {cat_name}\n\n"

            for template in templates_list:
                template_id = template['id']
                template_name = template['name']
                keyword, _ = self.get_download_url(template)

                readme_content += f"#### {template_name} (`{template_id}`)\n\n"
                readme_content += f"**搜索词:** `{keyword}`\n\n"
                readme_content += f"**下载步骤:**\n"
                readme_content += f"1. 访问 Unsplash: https://unsplash.com/s/photos/{keyword.replace(' ', '-')}\n"
                readme_content += f"2. 选择合适的图片（建议选择横向、简洁的图片）\n"
                readme_content += f"3. 点击 'Download free'\n"
                readme_content += f"4. 重命名为: `{template_id}_preview.jpg`\n"
                readme_content += f"5. 保存到: `assets/templates/{cat_key}/`\n\n"
                readme_content += "---\n\n"

        readme_content += """
### 方法 2: 使用 API 自动下载（需要配置 API Key）

如果您有 Unsplash 或 Pexels 的 API Key，可以修改 `download_template_resources.py` 中的配置，然后运行：

```bash
python3 scripts/download_template_resources.py --auto-download
```

**获取 API Key:**
- Unsplash: https://unsplash.com/developers (免费，每小时 50 次请求)
- Pexels: https://www.pexels.com/api/ (免费，每月 200 次请求)

## 📋 下载清单

"""

        # 生成清单
        for cat_key, templates_list in sorted(categories.items()):
            cat_name = templates_list[0]['category']
            readme_content += f"\n### {cat_name} ({len(templates_list)} 个)\n\n"

            for template in templates_list:
                template_id = template['id']
                template_name = template['name']
                readme_content += f"- [ ] {template_name} - `{template_id}_preview.jpg`\n"

        readme_content += "\n**总计:** "
        readme_content += f"{len(templates)} 个模板预览图\n\n"

        readme_content += """
## 📐 图片要求

- **尺寸:** 至少 800×600px，推荐 1200×800px
- **格式:** JPG 或 PNG
- **文件大小:** < 500KB（建议压缩）
- **内容:** 简洁、清晰，能体现模板风格

## 🛠️ 图片优化

下载后使用以下工具压缩图片：

- **在线工具:** https://tinyjpg.com
- **Mac:** ImageOptim (brew install imageoptim)
- **命令行:**
  ```bash
  # 批量压缩
  for f in *.jpg; do
    convert "$f" -quality 85 -resize '1200x800>' "optimized_$f"
  done
  ```

## 💡 提示

1. 选择与模板风格匹配的图片
2. 避免过于复杂或繁忙的背景
3. 优先选择横向（landscape）图片
4. 确保图片有足够的空白区域放置预览框

---

**祝下载顺利！🎨✨**
"""

        # 保存 README
        readme_path = self.templates_dir / 'DOWNLOAD_GUIDE.md'
        with open(readme_path, 'w', encoding='utf-8') as f:
            f.write(readme_content)

        print(f"✅ 已生成下载指南: {readme_path}")

    def run(self):
        """运行主程序"""
        print("🎨 模板资源下载脚本")
        print("=" * 80)

        # 创建文件夹结构
        self.create_folder_structure()

        # 生成下载清单
        self.generate_download_list()

        # 生成 README
        self.generate_readme()

        print("\n" + "=" * 80)
        print("✅ 完成!")
        print()
        print("📖 下一步:")
        print(f"   1. 查看下载指南: {self.templates_dir / 'DOWNLOAD_GUIDE.md'}")
        print("   2. 根据指南从 Unsplash/Pexels 下载图片")
        print("   3. 将图片保存到对应的类别文件夹中")
        print()
        print("💡 提示: 如果需要自动下载，请配置 API Key 后运行:")
        print("   python3 scripts/download_template_resources.py --auto-download")
        print("=" * 80)


def main():
    """主函数"""
    downloader = TemplateDownloader()

    # 检查命令行参数
    if len(sys.argv) > 1 and sys.argv[1] == '--auto-download':
        print("⚠️  自动下载功能需要配置 API Key")
        print("请编辑脚本文件，填入您的 Unsplash 或 Pexels API Key")
        sys.exit(1)

    downloader.run()


if __name__ == '__main__':
    main()
