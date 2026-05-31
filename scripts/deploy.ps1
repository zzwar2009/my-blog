# ==========================================
# Gitee Pages 部署脚本
# 用法：在项目根目录运行 .\scripts\deploy.ps1
# ==========================================

$ErrorActionPreference = "Stop"

Write-Host "===== 1. 构建站点 =====" -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) { throw "构建失败" }

Write-Host "===== 2. 准备 pages 分支 =====" -ForegroundColor Cyan
$distDir = "docs\.vitepress\dist"
$tmpDir = ".pages-tmp"

# 暂存 dist 内容到临时目录
Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
Copy-Item -Recurse $distDir $tmpDir

# 记下当前分支
$currentBranch = git rev-parse --abbrev-ref HEAD

# 切换到 pages 分支（不存在则创建）
$pagesExists = git show-ref --verify --quiet refs/heads/pages
if ($LASTEXITCODE -ne 0) {
    Write-Host "  创建 pages 分支..." -ForegroundColor Yellow
    git checkout --orphan pages
    git rm -rf --quiet .
} else {
    git checkout pages
}

Write-Host "===== 3. 覆盖部署文件 =====" -ForegroundColor Cyan
# 清空当前 pages 分支内容（保留 .git）
Get-ChildItem -Force | Where-Object { $_.Name -ne '.git' } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# 复制构建产物
Copy-Item -Recurse "$tmpDir\*" . -Force

# 禁用 Jekyll 处理（安全起见）
New-Item -ItemType File -Name ".nojekyll" -Force | Out-Null

Write-Host "===== 4. 推送 =====" -ForegroundColor Cyan
git add -A
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Deploy: $timestamp" --allow-empty
git push origin pages --force

Write-Host "===== 5. 清理 =====" -ForegroundColor Cyan
Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
git checkout $currentBranch

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  推送完成！" -ForegroundColor Green
Write-Host "  去这里手动点「更新」: https://gitee.com/zzwar/my-blog/pages" -ForegroundColor Yellow
Write-Host "  线上地址: https://zzwar.gitee.io/my-blog" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Green
