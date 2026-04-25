# OneLaunch — 项目执行规范

## GitHub 部署信息

- **用户名**：gaohaosu526
- **仓库**：gaohaosu526/OneLaunch
- **Token**：从用户处获取（Personal Access Token，repo 权限）
- **本地路径映射**：`D:\AiSpace\Ai-OneLaunch\` → 仓库中的 `Ai-OneLaunch/` 子目录

## 强制规则：代码变更必须自动上传 GitHub

每次修改任何文件后，**必须立即通过 GitHub API 上传**，不得要求用户手动操作。

上传流程：
1. GET 文件当前 SHA：`GET /repos/gaohaosu526/OneLaunch/contents/Ai-OneLaunch/{相对路径}`
2. base64 编码本地文件内容
3. PUT 更新：`PUT /repos/gaohaosu526/OneLaunch/contents/Ai-OneLaunch/{相对路径}`
4. 所有文件上传完成后告知用户构建已触发

示例 curl 命令：
```bash
TOKEN="<Personal Access Token>"
REPO="gaohaosu526/OneLaunch"
CONTENT=$(base64 -w 0 "/d/AiSpace/Ai-OneLaunch/OneLaunch/Services/AppCatalogService.swift")
SHA="<从GET接口获取>"
curl -s -X PUT \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/repos/$REPO/contents/Ai-OneLaunch/OneLaunch/Services/AppCatalogService.swift" \
  -d "{\"message\":\"fix: ...\",\"content\":\"$CONTENT\",\"sha\":\"$SHA\"}"
```

## 项目结构

```
D:\AiSpace\Ai-OneLaunch\          ← 本地根目录（对应仓库 Ai-OneLaunch/）
├── project.yml                    ← XcodeGen 配置
├── OneLaunch/
│   ├── BridgingHeader.h           ← 私有 API 声明
│   ├── Info.plist
│   ├── OneLaunchApp.swift
│   ├── ContentView.swift
│   ├── Models/
│   ├── Services/
│   │   ├── AppCatalogService.swift
│   │   └── AppLaunchService.swift
│   ├── ViewModels/
│   │   └── HomeViewModel.swift
│   └── Views/
│       ├── HomeView.swift
│       ├── AppIconView.swift
│       ├── GroupView.swift
│       └── SettingsView.swift
└── CLAUDE.md                      ← 本文件
```

仓库根目录（非 Ai-OneLaunch 子目录）额外包含：
```
.github/workflows/build.yml        ← GitHub Actions 构建流程
```

## 技术栈

- Swift 5.9 + SwiftUI + UIKit，iOS 17+，MVVM
- SwiftData 持久化分组
- 私有 API：`LSApplicationWorkspace`（Bridging Header + `-undefined dynamic_lookup`）
- 构建：GitHub Actions (macos-15 + Xcode 16) → 无签名 IPA
- 安装：Sideloadly（Windows）
