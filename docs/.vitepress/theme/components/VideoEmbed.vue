<template>
  <!-- 通用视频嵌入组件 -->
  <!-- 用法：
    <VideoEmbed src="https://www.bilibili.com/video/BV..." type="bilibili" />
    <VideoEmbed src="https://www.youtube.com/embed/xxxx" type="youtube" />
    <VideoEmbed src="/videos/demo.mp4" type="local" />
  -->
  <div class="video-wrapper">
    <!-- B 站 -->
    <iframe
      v-if="type === 'bilibili'"
      :src="bilibiliSrc"
      scrolling="no"
      border="0"
      frameborder="no"
      framespacing="0"
      allowfullscreen="true"
    />
    <!-- YouTube -->
    <iframe
      v-else-if="type === 'youtube'"
      :src="src"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
      allowfullscreen
    />
    <!-- 本地 / 其他 iframe -->
    <iframe
      v-else-if="type === 'iframe'"
      :src="src"
      allowfullscreen
    />
    <!-- 本地 mp4 -->
    <video
      v-else
      :src="src"
      controls
      preload="metadata"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  src: string
  /** 'bilibili' | 'youtube' | 'local' | 'iframe' */
  type?: string
}>()

// 把 B 站普通链接自动转换成嵌入链接
const bilibiliSrc = computed(() => {
  const url = props.src
  // 已经是 player 链接就直接用
  if (url.includes('player.bilibili.com')) return url
  // 从 BV 号提取
  const bvMatch = url.match(/BV[\w]+/)
  if (bvMatch) {
    return `//player.bilibili.com/player.html?bvid=${bvMatch[0]}&page=1&high_quality=1&danmaku=0`
  }
  return url
})
</script>
