# THE HORNETS Website - Quick Update Script
# 
# Use this script to push updates to your live website
# Right-click this file and select "Run with PowerShell"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  THE HORNETS - Update Website" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Refresh environment variables to use Git
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Navigate to website directory
Set-Location $PSScriptRoot

# Check if bluewi.html was modified and update index.html
Write-Host "Checking for changes in bluewi.html..." -ForegroundColor Cyan
$bluewiModified = git status --porcelain | Select-String "bluewi.html"

if ($bluewiModified) {
    Write-Host "bluewi.html was modified. Copying to index.html..." -ForegroundColor Yellow
    Copy-Item "bluewi.html" "index.html" -Force
    Write-Host "✓ index.html updated!" -ForegroundColor Green
}

# Show status
Write-Host ""
Write-Host "Current changes:" -ForegroundColor Cyan
git status --short

# Ask for commit message
Write-Host ""
Write-Host "Enter a description of your changes (or press Enter for default message):" -ForegroundColor Yellow
$commitMessage = Read-Host

if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Update website - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

# Add all changes
Write-Host ""
Write-Host "Adding changes..." -ForegroundColor Cyan
git add .

# Commit changes
Write-Host "Committing changes..." -ForegroundColor Cyan
git commit -m "$commitMessage"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "No changes to commit." -ForegroundColor Yellow
    Write-Host "Your website is already up to date!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Green
    Write-Host "  ✓ UPDATE SUCCESSFUL! ✓" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your website will be updated in 1-2 minutes!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "✗ Push failed. Please check your connection and try again." -ForegroundColor Red
    Write-Host ""
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
