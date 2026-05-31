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

# 暂存构建产物到临时目录
Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
Copy-Item -Recurse $distDir $tmpDir

# 记下当前分支
$currentBranch = git rev-parse --abbrev-ref HEAD

# 切换到 pages 分支（不存在则创建）
$pagesExists = git show-ref --verify --quiet refs/heads/pages 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  创建 pages 分支..." -ForegroundColor Yellow
    git checkout --orphan pages
} else {
    git checkout pages
}
# 清空索引（不碰工作区）
git rm -rf --cached --quiet .

Write-Host "===== 3. 覆盖部署文件 =====" -ForegroundColor Cyan
# 删除工作区旧文件（跳过 node_modules 避免 esbuild 锁）
Get-ChildItem -Force -ErrorAction SilentlyContinue | Where-Object { 
    $_.Name -notin @('.git', 'node_modules', '.pages-tmp')
} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# 复制构建产物到工作区根目录
Copy-Item -Recurse "$tmpDir\*" . -Force

# 禁用 Jekyll 处理
New-Item -ItemType File -Name ".nojekyll" -Force | Out-Null

Write-Host "===== 4. 提交并推送 =====" -ForegroundColor Cyan
git add -A
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Deploy: $timestamp" --allow-empty
git push "https://zzwar:7fa52340044419fd2dbabf8e841be729@gitee.com/zzwar/my-blog.git" pages --force

Write-Host "===== 5. 清理 =====" -ForegroundColor Cyan
Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
git checkout $currentBranch

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  部署完成！" -ForegroundColor Green
Write-Host "  去这里点「更新」: https://gitee.com/zzwar/my-blog/pages" -ForegroundColor Yellow
Write-Host "  线上地址: https://zzwar.gitee.io/my-blog" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Green
