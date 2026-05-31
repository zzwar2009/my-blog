import { defineConfig } from "vitepress";

export default defineConfig({
  title: "Dev Notes",
  description: "记录 TypeScript、JavaScript、React、Python 的学习与实践",
  base: "/my-blog/",

  head: [
    ["link", { rel: "icon", href: "/logo.svg" }],
    ["meta", { name: "theme-color", content: "#5b7cf6" }],
  ],

  locales: {
    root: {
      label: "简体中文",
      lang: "zh-CN",
      link: "/",
      themeConfig: {
        siteTitle: "Dev Notes",
        nav: [
          { text: "首页", link: "/" },
          {
            text: "文章",
            items: [
              { text: "TypeScript", link: "/posts/typescript/" },
              { text: "JavaScript", link: "/posts/javascript/" },
              { text: "React", link: "/posts/react/" },
              { text: "Python", link: "/posts/python/" },
              { text: "视频笔记", link: "/posts/videos/" },
            ],
          },
          { text: "关于", link: "/about" },
        ],
        sidebar: {
          "/posts/typescript/": [
            {
              text: "TypeScript",
              collapsed: false,
              items: [
                { text: "类型系统基础", link: "/posts/typescript/type-system" },
                { text: "泛型进阶", link: "/posts/typescript/generics" },
              ],
            },
          ],
          "/posts/javascript/": [
            {
              text: "JavaScript",
              collapsed: false,
              items: [
                { text: "异步编程深入", link: "/posts/javascript/async" },
                { text: "闭包与作用域", link: "/posts/javascript/closures" },
              ],
            },
          ],
          "/posts/react/": [
            {
              text: "React",
              collapsed: false,
              items: [
                { text: "Hooks 实战", link: "/posts/react/hooks" },
                { text: "性能优化", link: "/posts/react/performance" },
              ],
            },
          ],
          "/posts/python/": [
            {
              text: "Python",
              collapsed: false,
              items: [
                { text: "装饰器详解", link: "/posts/python/decorators" },
                { text: "异步 asyncio", link: "/posts/python/asyncio" },
              ],
            },
          ],
          "/posts/videos/": [
            {
              text: "视频笔记",
              collapsed: false,
              items: [
                { text: "视频嵌入示例", link: "/posts/videos/embed-demo" },
              ],
            },
          ],
        },
        docFooter: { prev: "上一篇", next: "下一篇" },
        outline: { label: "本页目录", level: [2, 3] },
        returnToTopLabel: "回到顶部",
        sidebarMenuLabel: "菜单",
        darkModeSwitchLabel: "主题",
      },
    },

    en: {
      label: "English",
      lang: "en",
      link: "/en/",
      themeConfig: {
        siteTitle: "Dev Notes",
        nav: [
          { text: "Home", link: "/en/" },
          {
            text: "Posts",
            items: [
              { text: "TypeScript", link: "/en/posts/typescript/" },
              { text: "JavaScript", link: "/en/posts/javascript/" },
              { text: "React", link: "/en/posts/react/" },
              { text: "Python", link: "/en/posts/python/" },
              { text: "Videos", link: "/en/posts/videos/" },
            ],
          },
          { text: "About", link: "/en/about" },
        ],
        sidebar: {
          "/en/posts/typescript/": [
            {
              text: "TypeScript",
              collapsed: false,
              items: [
                {
                  text: "Type System Basics",
                  link: "/en/posts/typescript/type-system",
                },
                {
                  text: "Advanced Generics",
                  link: "/en/posts/typescript/generics",
                },
              ],
            },
          ],
          "/en/posts/javascript/": [
            {
              text: "JavaScript",
              collapsed: false,
              items: [
                {
                  text: "Async Programming",
                  link: "/en/posts/javascript/async",
                },
                {
                  text: "Closures & Scope",
                  link: "/en/posts/javascript/closures",
                },
              ],
            },
          ],
          "/en/posts/react/": [
            {
              text: "React",
              collapsed: false,
              items: [
                { text: "Hooks in Action", link: "/en/posts/react/hooks" },
                { text: "Performance", link: "/en/posts/react/performance" },
              ],
            },
          ],
          "/en/posts/python/": [
            {
              text: "Python",
              collapsed: false,
              items: [
                {
                  text: "Decorators Deep Dive",
                  link: "/en/posts/python/decorators",
                },
                { text: "Asyncio", link: "/en/posts/python/asyncio" },
              ],
            },
          ],
          "/en/posts/videos/": [
            {
              text: "Videos",
              collapsed: false,
              items: [
                {
                  text: "Video Embed Demo",
                  link: "/en/posts/videos/embed-demo",
                },
              ],
            },
          ],
        },
        docFooter: { prev: "Previous", next: "Next" },
        outline: { label: "On this page", level: [2, 3] },
        returnToTopLabel: "Return to top",
        sidebarMenuLabel: "Menu",
        darkModeSwitchLabel: "Theme",
      },
    },
  },

  themeConfig: {
    logo: "/logo.svg",
    socialLinks: [
      { icon: "github", link: "https://github.com/zzwar2009/my-blog" },
    ],
    search: { provider: "local" },
    footer: {
      message: "Built with VitePress",
      copyright: "Copyright &copy; 2026",
    },
  },

  markdown: { lineNumbers: true },
});
