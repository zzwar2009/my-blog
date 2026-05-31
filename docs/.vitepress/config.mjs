import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Dev Notes',
  description: '记录 TypeScript、JavaScript、React、Python 的学习与实践',
  lang: 'zh-CN',
  base: '/my-blog/',

  head: [
    ['link', { rel: 'icon', href: '/logo.svg' }],
    ['meta', { name: 'theme-color', content: '#5b7cf6' }],
  ],

  themeConfig: {
    logo: '/logo.svg',
    siteTitle: 'Dev Notes',

    nav: [
      { text: '首页', link: '/' },
      {
        text: '文章',
        items: [
          { text: 'TypeScript', link: '/posts/typescript/' },
          { text: 'JavaScript', link: '/posts/javascript/' },
          { text: 'React', link: '/posts/react/' },
          { text: 'Python', link: '/posts/python/' },
          { text: '视频笔记', link: '/posts/videos/' },
        ],
      },
      { text: '关于', link: '/about' },
    ],

    sidebar: {
      '/posts/typescript/': [
        {
          text: 'TypeScript',
          collapsed: false,
          items: [
            { text: '类型系统基础', link: '/posts/typescript/type-system' },
            { text: '泛型进阶', link: '/posts/typescript/generics' },
          ],
        },
      ],
      '/posts/javascript/': [
        {
          text: 'JavaScript',
          collapsed: false,
          items: [
            { text: '异步编程深入', link: '/posts/javascript/async' },
            { text: '闭包与作用域', link: '/posts/javascript/closures' },
          ],
        },
      ],
      '/posts/react/': [
        {
          text: 'React',
          collapsed: false,
          items: [
            { text: 'Hooks 实战', link: '/posts/react/hooks' },
            { text: '性能优化', link: '/posts/react/performance' },
          ],
        },
      ],
      '/posts/python/': [
        {
          text: 'Python',
          collapsed: false,
          items: [
            { text: '装饰器详解', link: '/posts/python/decorators' },
            { text: '异步 asyncio', link: '/posts/python/asyncio' },
          ],
        },
      ],
      '/posts/videos/': [
        {
          text: '视频笔记',
          collapsed: false,
          items: [
            { text: '视频嵌入示例', link: '/posts/videos/embed-demo' },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: { svg: '<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M11.984 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.016 0zm6.09 5.333c.328 0 .593.266.593.593v1.482a.594.594 0 0 1-.593.593H9.777c-.982 0-1.778.796-1.778 1.778v5.63c0 .327.266.592.593.592h5.63c.982 0 1.778-.796 1.778-1.778v-.296a.593.593 0 0 0-.593-.593h-4.15a.593.593 0 0 1-.592-.592v-1.482a.593.593 0 0 1 .593-.592h6.815c.327 0 .593.265.593.592v3.853a4.445 4.445 0 0 1-4.445 4.444H6.667a4.445 4.445 0 0 1-4.444-4.444V9.778a4.445 4.445 0 0 1 4.444-4.445h11.408z"/></svg>' }, link: 'https://gitee.com/zzwar/my-blog' },
    ],

    search: {
      provider: 'local',
    },

    footer: {
      message: '用 VitePress 构建',
      copyright: 'Copyright © 2026',
    },

    docFooter: {
      prev: '上一篇',
      next: '下一篇',
    },

    outline: {
      label: '本页目录',
      level: [2, 3],
    },

    returnToTopLabel: '回到顶部',
    sidebarMenuLabel: '菜单',
    darkModeSwitchLabel: '主题',
  },

  markdown: {
    lineNumbers: true,
  },
})
