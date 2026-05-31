# Gitee Pages deploy script
# Run from project root: npm run deploy

$ErrorActionPreference = "Stop"

Write-Host "===== 1. Build =====" -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) { throw "Build failed" }

Write-Host "===== 2. Prepare pages branch =====" -ForegroundColor Cyan
$distDir = "docs\.vitepress\dist"
$tmpDir = ".pages-tmp"

Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
Copy-Item -Recurse $distDir $tmpDir

$currentBranch = git rev-parse --abbrev-ref HEAD

$pagesExists = git show-ref --verify --quiet refs/heads/pages 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Creating pages branch..." -ForegroundColor Yellow
    git checkout --orphan pages
} else {
    git checkout pages
}
git rm -rf --cached --quiet .

Write-Host "===== 3. Deploy files =====" -ForegroundColor Cyan
Get-ChildItem -Force -ErrorAction SilentlyContinue | Where-Object { 
    $_.Name -notin @('.git', 'node_modules', '.pages-tmp')
} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Copy-Item -Recurse "$tmpDir\*" . -Force
New-Item -ItemType File -Name ".nojekyll" -Force | Out-Null

Write-Host "===== 4. Commit and push =====" -ForegroundColor Cyan
git add -A
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Deploy: $timestamp" --allow-empty
$token = "7fa52340044419fd2dbabf8e841be729"
git push "https://zzwar:$token@gitee.com/zzwar/my-blog.git" pages --force

Write-Host "===== 5. Cleanup =====" -ForegroundColor Cyan
Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
git checkout $currentBranch

Write-Host ""
Write-Host "===================================" -ForegroundColor Green
Write-Host "  Deploy done!" -ForegroundColor Green
Write-Host "  Go to: https://gitee.com/zzwar/my-blog/pages" -ForegroundColor Yellow
Write-Host "  Live at: https://zzwar.gitee.io/my-blog" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Green
