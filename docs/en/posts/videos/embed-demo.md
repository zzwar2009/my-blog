---
title: Video Embed Demo
description: How to embed videos in VitePress
---

# 🎬 Video Embed Demo

This post shows how to embed videos in VitePress using the `VideoEmbed` component.

## Bilibili

<VideoEmbed src="https://www.bilibili.com/video/BV1xx411c7mD" type="bilibili" />

## YouTube

<VideoEmbed src="https://www.youtube.com/embed/dQw4w9WgXcQ" type="youtube" />

## Local Video

Put your video in `docs/public/videos/` and embed it:

```md
<VideoEmbed src="/videos/demo.mp4" type="local" />
```

---

> 📝 **Note:** Remember to upload the actual video file to `docs/public/videos/`.
