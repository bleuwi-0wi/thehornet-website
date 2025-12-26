# THE HORNETS Website - Quick GitHub Deployment Script
# 
# INSTRUCTIONS:
# 1. First, create a repository on GitHub.com
# 2. Edit the variables below with YOUR information
# 3. Right-click this file and select "Run with PowerShell"

# ========================================
# EDIT THESE VARIABLES WITH YOUR INFO
# ========================================

$GITHUB_USERNAME = "bleuwi-0wi"        # Your GitHub username
$REPOSITORY_NAME = "thehornet-website"       # Your repository name

# ========================================
# DO NOT EDIT BELOW THIS LINE
# ========================================

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  THE HORNETS - GitHub Deployment" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Refresh environment variables to use Git
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Navigate to website directory
Set-Location $PSScriptRoot

# Check if variables are set
if ($GITHUB_USERNAME -eq "YOUR-USERNAME-HERE" -or $REPOSITORY_NAME -eq "YOUR-REPO-NAME-HERE") {
    Write-Host "ERROR: Please edit this script and set your GitHub username and repository name!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Open this file in a text editor and change:" -ForegroundColor Yellow
    Write-Host "  - GITHUB_USERNAME to your actual GitHub username" -ForegroundColor Yellow
    Write-Host "  - REPOSITORY_NAME to your actual repository name" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-Host "GitHub Username: $GITHUB_USERNAME" -ForegroundColor Green
Write-Host "Repository Name: $REPOSITORY_NAME" -ForegroundColor Green
Write-Host ""

# Check if remote already exists
$remoteExists = git remote get-url origin 2>$null

if ($remoteExists) {
    Write-Host "Remote origin already exists. Removing it..." -ForegroundColor Yellow
    git remote remove origin
}

# Add GitHub remote
Write-Host "Adding GitHub remote..." -ForegroundColor Cyan
git remote add origin "https://github.com/$GITHUB_USERNAME/$REPOSITORY_NAME.git"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Remote added successfully!" -ForegroundColor Green
}
else {
    Write-Host "✗ Failed to add remote" -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Rename branch to main
Write-Host "Renaming branch to 'main'..." -ForegroundColor Cyan
git branch -M main

# Push to GitHub
Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
Write-Host "You may be asked to authenticate. Use your GitHub credentials." -ForegroundColor Yellow
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Green
    Write-Host "  ✓ DEPLOYMENT SUCCESSFUL! ✓" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your code is now on GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Go to: https://github.com/$GITHUB_USERNAME/$REPOSITORY_NAME" -ForegroundColor White
    Write-Host "2. Click 'Settings' → 'Pages'" -ForegroundColor White
    Write-Host "3. Under 'Source', select 'main' branch" -ForegroundColor White
    Write-Host "4. Click 'Save'" -ForegroundColor White
    Write-Host ""
    Write-Host "Your website will be live at:" -ForegroundColor Cyan
    Write-Host "https://$GITHUB_USERNAME.github.io/$REPOSITORY_NAME/" -ForegroundColor Yellow
    Write-Host ""
}
else {
    Write-Host ""
    Write-Host "✗ Push failed. Please check your credentials and try again." -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "- Make sure the repository exists on GitHub" -ForegroundColor White
    Write-Host "- Verify your GitHub username and password/token" -ForegroundColor White
    Write-Host "- Check your internet connection" -ForegroundColor White
    Write-Host ""
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
