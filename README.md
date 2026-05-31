# Dev Notes

My personal tech blog built with [VitePress](https://vitepress.dev/).

 Topics: TypeScript · JavaScript · React · Python

## Quick Start

```bash
npm install
npm run dev
```

## Deploy

**Auto-deploy via GitHub Actions** — push to `master` branch triggers automatic deployment to GitHub Pages.

Live at: **https://zzwar2009.github.io/my-blog**

### Manual Deploy

```bash
npm run deploy
```

## Write New Posts

1. Add `.md` file under `docs/posts/<category>/`
2. Update sidebar in `docs/.vitepress/config.mjs`
3. Push to `master` → auto-deployed
