# OneLaunch — iOS 个人启动器

## 安装到 iPhone 的完整步骤

### 第一步：准备工具（只需做一次）

**1. 注册 GitHub 账号（免费）**
- 打开 https://github.com → Sign up → 注册完成

**2. 安装 Sideloadly（Windows，免费）**
- 打开 https://sideloadly.io → 下载 Windows 版 → 安装
- 用于把 IPA 文件签名并装到 iPhone

**3. 安装 Apple iTunes（用于 USB 驱动）**
- 如果还没装，从 Apple 官网下载 iTunes for Windows

---

### 第二步：上传代码到 GitHub（只需做一次）

1. 登录 GitHub → 点右上角 **+** → **New repository**
2. 名称填 `OneLaunch`，选 **Private**（私有），点 **Create repository**
3. 点 **uploading an existing file**
4. 把 `D:\AiSpace\Ai-OneLaunch` 里所有文件和文件夹都拖进去
5. 点 **Commit changes** → 上传完成

---

### 第三步：自动编译（每次更新后自动触发）

上传代码后 GitHub 会自动开始编译：

1. 在你的仓库页面点 **Actions** 标签
2. 看到 **Build IPA** 正在运行（约 5~8 分钟）
3. 运行完成后点进去 → 找到底部 **Artifacts** → 下载 **OneLaunch-IPA**
4. 解压得到 `OneLaunch-unsigned.ipa` 文件

---

### 第四步：安装到 iPhone

1. 用 USB 线把 iPhone 连接到电脑
2. 打开 **Sideloadly**
3. 把 `OneLaunch-unsigned.ipa` 拖进 Sideloadly 窗口
4. 输入你的 **Apple ID**（普通免费账号即可）
5. 点 **Start** → 等待约 1 分钟
6. 安装完成后，在 iPhone 上：
   - 打开 **设置 → 通用 → VPN 与设备管理**
   - 找到你的 Apple ID → 点 **信任**
7. 回到桌面，打开 OneLaunch ✓

---

### 证书有效期说明

| 账号类型 | 有效期 | 重签方式 |
|--------|--------|--------|
| 免费 Apple ID | 7 天 | 每 7 天用 Sideloadly 重签一次（重复第四步） |
| Apple 开发者账号（$99/年） | 1 年 | 每年重签一次 |

---

## 应用功能

- **启动器**：展示手机上所有已安装应用，点击即启动
- **搜索**：顶部搜索栏快速过滤应用
- **分组**：点右上角文件夹图标创建分组；长按应用图标加入分组
- **排序**：长按图标拖动调整顺序
- **设置**：管理和删除分组

## 注意事项

- 此应用使用 iOS 私有 API（`LSApplicationWorkspace`）枚举已安装应用
- **不能上架 App Store**，仅限个人使用侧载安装
- 需要 iOS 17 或更高版本
- 私有 API 在每次 iOS 大版本更新后可能需要验证是否仍可用

## 技术栈

- Swift 5.9 + SwiftUI + UIKit
- iOS 17+，MVVM 架构
- SwiftData 持久化分组数据
- 私有 API：`LSApplicationWorkspace`（Bridging Header）
- 自动构建：GitHub Actions (macos-15 + Xcode 16)
- 安装：Sideloadly（Windows）
