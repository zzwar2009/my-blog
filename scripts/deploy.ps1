# Manual deploy script (backup - GitHub Actions handles auto-deploy)
# Run from project root: npm run deploy
# Note: Push to GitHub master triggers automatic deploy via Actions

$ErrorActionPreference = "Stop"

Write-Host "===== 1. Install dependencies =====" -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) { throw "npm install failed" }

Write-Host "===== 2. Build =====" -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) { throw "Build failed" }

Write-Host "===== 3. Deploy to gh-pages =====" -ForegroundColor Cyan
$distDir = "docs\.vitepress\dist"
$tmpDir = ".pages-tmp"

Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
Copy-Item -Recurse $distDir $tmpDir

$currentBranch = git rev-parse --abbrev-ref HEAD

# Switch to or create gh-pages branch
$pagesExists = git show-ref --verify --quiet refs/heads/gh-pages 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Creating gh-pages branch..." -ForegroundColor Yellow
    git checkout --orphan gh-pages
} else {
    git checkout gh-pages
}
git rm -rf --cached --quiet .

Get-ChildItem -Force -ErrorAction SilentlyContinue | Where-Object { 
    $_.Name -notin @('.git', 'node_modules', '.pages-tmp')
} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Copy-Item -Recurse "$tmpDir\*" . -Force
New-Item -ItemType File -Name ".nojekyll" -Force | Out-Null

Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .pages-tmp -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force scripts -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force docs -ErrorAction SilentlyContinue
Remove-Item -Force .gitignore -ErrorAction SilentlyContinue
Remove-Item -Force package.json -ErrorAction SilentlyContinue
Remove-Item -Force package-lock.json -ErrorAction SilentlyContinue
Remove-Item -Force README.md -ErrorAction SilentlyContinue

git add -A
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Deploy: $timestamp" --allow-empty

# Push to GitHub gh-pages
git push https://github.com/zzwar2009/my-blog.git gh-pages --force

Write-Host "===== 4. Cleanup =====" -ForegroundColor Cyan
Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
git checkout $currentBranch

Write-Host ""
Write-Host "===================================" -ForegroundColor Green
Write-Host "  Deploy done!" -ForegroundColor Green
Write-Host "  Live at: https://zzwar2009.github.io/my-blog" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Green
