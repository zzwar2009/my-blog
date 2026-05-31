---
title: 视频嵌入示例
date: 2026-05-31
tags: [视频, B站, YouTube]
---

# 视频嵌入示例

VitePress 支持直接在 Markdown 中使用 Vue 组件，因此我们可以用 `<VideoEmbed>` 组件嵌入各种来源的视频。

## B 站视频

传入 B 站视频的 BV 号链接，组件会自动转换为嵌入地址：

```md
<VideoEmbed
  src="https://www.bilibili.com/video/BV1GJ411x7h7"
  type="bilibili"
/>
```

<VideoEmbed
  src="https://www.bilibili.com/video/BV1GJ411x7h7"
  type="bilibili"
/>

> 替换上面的 BV 号即可嵌入任意 B 站视频。

---

## YouTube 视频

YouTube 需要使用 `/embed/` 格式的链接：

```md
<VideoEmbed
  src="https://www.youtube.com/embed/dQw4w9WgXcQ"
  type="youtube"
/>
```

<VideoEmbed
  src="https://www.youtube.com/embed/dQw4w9WgXcQ"
  type="youtube"
/>

---

## 本地视频文件

把视频文件放到 `docs/public/videos/` 目录下，然后用相对路径引用：

```md
<VideoEmbed src="/videos/demo.mp4" type="local" />
```

::: tip 本地视频建议
- 格式：MP4（H.264 编码），兼容性最好
- 分辨率：1080p 或 720p，文件不要太大
- 放置路径：`docs/public/videos/` → 访问路径 `/videos/xxx.mp4`
:::

---

## 在笔记中搭配视频

下面是一个"视频 + 文字笔记"的组合示例：

<VideoEmbed
  src="https://www.bilibili.com/video/BV1GJ411x7h7"
  type="bilibili"
/>

### 视频要点笔记

**00:00 — 介绍**
- 内容概述...

**05:30 — 核心知识点**

```js
// 视频中的示例代码可以直接粘贴在这里
const example = 'hello world'
console.log(example)
```

**15:00 — 实战演练**
- 步骤 1：...
- 步骤 2：...

::: warning 注意
B 站视频在国内访问正常，YouTube 视频需要自行解决网络问题。
:::
