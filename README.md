# Dev Notes

个人技术博客，基于 VitePress 构建。

## 技术栈

- **框架**: VitePress 1.x
- **内容**: TypeScript / JavaScript / React / Python
- **视频**: 支持 B站 / YouTube / 本地视频嵌入

## 本地开发

```bash
npm install
npm run dev      # 启动开发服务器 http://localhost:5173
npm run build    # 构建静态站点
npm run preview  # 预览构建产物
```

## 部署到 Gitee Pages

### 首次部署

```bash
# 1. 推送 master 分支到 Gitee
git push -u origin master

# 2. 执行部署
npm run deploy
```

### 每次更新

写完新文章后，跑一行命令即可：

```bash
npm run deploy
```

### 在 Gitee 后台触发

部署脚本会自动把构建产物推到 `pages` 分支。然后去这里手动点「更新」：

👉 **https://gitee.com/zzwar/my-blog/pages**

点完「更新」后，博客就上线了：

🌐 **https://zzwar.gitee.io/my-blog**

### 部署原理

```
你写文章 → npm run deploy → 构建 → 推到 pages 分支 → Gitee Pages 手动更新
```

## 目录结构

```
my-blog/
├── docs/
│   ├── .vitepress/
│   │   ├── config.mjs          # 站点配置
│   │   └── theme/              # 自定义主题
│   ├── posts/
│   │   ├── typescript/         # TS 文章
│   │   ├── javascript/         # JS 文章
│   │   ├── react/              # React 文章
│   │   ├── python/             # Python 文章
│   │   └── videos/             # 视频笔记
│   ├── public/                 # 静态资源
│   └── index.md                # 首页
├── scripts/
│   └── deploy.ps1              # 部署脚本
└── package.json
```
