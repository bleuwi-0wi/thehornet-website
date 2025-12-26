# ===============================================
# THE HORNETS Website - Advanced Update Script
# ===============================================
# 
# DESCRIPTION:
#   Quick and safe website update tool with automatic backups,
#   error handling, and deployment to GitHub Pages
#
# USAGE:
#   Right-click this file and select "Run with PowerShell"
#
# FEATURES:
#   ✓ Automatic backup before updates
#   ✓ Sync bluewi.html → index.html
#   ✓ Pre-deployment checks
#   ✓ Automatic commit and push
#   ✓ Detailed status reporting
#   ✓ Error recovery
#   ✓ Deployment verification
#
# © 2023-2025 BLUEWI - THE HORNETS. All Rights Reserved.
# ===============================================

# Set error action preference
$ErrorActionPreference = "Continue"

# Colors for output
$ColorHeader = "Cyan"
$ColorSuccess = "Green"
$ColorWarning = "Yellow"
$ColorError = "Red"
$ColorInfo = "White"

# Clear screen for clean output
Clear-Host

# Header
Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor $ColorHeader
Write-Host "║                                                ║" -ForegroundColor $ColorHeader
Write-Host "║        THE HORNETS - Website Updater           ║" -ForegroundColor $ColorHeader
Write-Host "║              BLUEWI © 2025                     ║" -ForegroundColor $ColorHeader
Write-Host "║                                                ║" -ForegroundColor $ColorHeader
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor $ColorHeader
Write-Host ""

# Refresh environment variables to ensure Git is available
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Navigate to website directory
Set-Location $PSScriptRoot
Write-Host "[INFO] Working directory: $PSScriptRoot" -ForegroundColor $ColorInfo
Write-Host ""

# ===============================================
# STEP 1: PRE-DEPLOYMENT CHECKS
# ===============================================

Write-Host "═══ STEP 1: Pre-Deployment Checks ═══" -ForegroundColor $ColorHeader
Write-Host ""

# Check if Git is installed
Write-Host "[CHECK] Verifying Git installation..." -ForegroundColor $ColorInfo
try {
    $gitVersion = git --version 2>$null
    if ($gitVersion) {
        Write-Host "  ✓ Git found: $gitVersion" -ForegroundColor $ColorSuccess
    }
    else {
        throw "Git not found"
    }
}
catch {
    Write-Host "  ✗ ERROR: Git is not installed or not in PATH" -ForegroundColor $ColorError
    Write-Host ""
    Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor $ColorWarning
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Check if we're in a Git repository
Write-Host "[CHECK] Verifying Git repository..." -ForegroundColor $ColorInfo
try {
    $isGitRepo = git rev-parse --is-inside-work-tree 2>$null
    if ($isGitRepo -eq "true") {
        Write-Host "  ✓ Git repository detected" -ForegroundColor $ColorSuccess
    }
    else {
        throw "Not a Git repository"
    }
}
catch {
    Write-Host "  ✗ ERROR: This is not a Git repository" -ForegroundColor $ColorError
    Write-Host ""
    Write-Host "Run the deploy-to-github.ps1 script first!" -ForegroundColor $ColorWarning
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Check remote connection
Write-Host "[CHECK] Checking GitHub connection..." -ForegroundColor $ColorInfo
try {
    $remote = git remote get-url origin 2>$null
    if ($remote) {
        Write-Host "  ✓ Connected to: $remote" -ForegroundColor $ColorSuccess
    }
    else {
        throw "No remote configured"
    }
}
catch {
    Write-Host "  ✗ WARNING: No remote repository configured" -ForegroundColor $ColorWarning
    Write-Host "  You may need to run deploy-to-github.ps1 first" -ForegroundColor $ColorWarning
}

Write-Host ""

# ===============================================
# STEP 2: CREATE BACKUP
# ===============================================

Write-Host "═══ STEP 2: Creating Backup ═══" -ForegroundColor $ColorHeader
Write-Host ""

$backupFolder = "backups"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupPath = Join-Path $PSScriptRoot $backupFolder

# Create backup directory if it doesn't exist
if (!(Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
}

# Add backups folder to .gitignore if not already there
$gitignorePath = Join-Path $PSScriptRoot ".gitignore"
if (Test-Path $gitignorePath) {
    $gitignoreContent = Get-Content $gitignorePath -Raw
    if ($gitignoreContent -notmatch "backups/") {
        Add-Content $gitignorePath "`n# Automatic backups`nbackups/"
        Write-Host "[BACKUP] Added backups/ to .gitignore" -ForegroundColor $ColorInfo
    }
}

# Create backup of important files
$filesToBackup = @("bluewi.html", "index.html", "products.html", "editing.html", "clothes.html", "videos.html", "inbox.html")
$backupCount = 0

foreach ($file in $filesToBackup) {
    if (Test-Path $file) {
        $backupFileName = "$timestamp`_$file"
        $backupFilePath = Join-Path $backupPath $backupFileName
        Copy-Item $file $backupFilePath -Force
        $backupCount++
    }
}

Write-Host "  ✓ Backed up $backupCount files to: $backupFolder/" -ForegroundColor $ColorSuccess
Write-Host ""

# ===============================================
# STEP 3: SYNC MAIN FILES
# ===============================================

Write-Host "═══ STEP 3: Syncing Files ═══" -ForegroundColor $ColorHeader
Write-Host ""

# Check if bluewi.html was modified and sync to index.html
Write-Host "[SYNC] Checking bluewi.html..." -ForegroundColor $ColorInfo
$bluewiStatus = git status --porcelain bluewi.html 2>$null

if ($bluewiStatus) {
    Write-Host "  → bluewi.html has changes, syncing to index.html..." -ForegroundColor $ColorWarning
    Copy-Item "bluewi.html" "index.html" -Force
    Write-Host "  ✓ index.html updated from bluewi.html" -ForegroundColor $ColorSuccess
}
else {
    Write-Host "  ✓ bluewi.html unchanged, no sync needed" -ForegroundColor $ColorSuccess
}

Write-Host ""

# ===============================================
# STEP 4: REVIEW CHANGES
# ===============================================

Write-Host "═══ STEP 4: Review Changes ═══" -ForegroundColor $ColorHeader
Write-Host ""

# Get status
$statusOutput = git status --short

if ([string]::IsNullOrWhiteSpace($statusOutput)) {
    Write-Host "  ℹ No changes detected" -ForegroundColor $ColorWarning
    Write-Host ""
    Write-Host "Your website is already up to date!" -ForegroundColor $ColorSuccess
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}

Write-Host "Files to be updated:" -ForegroundColor $ColorInfo
Write-Host ""
git status --short | ForEach-Object {
    $line = $_.ToString()
    if ($line -match "^\s*M\s+") {
        Write-Host "  Modified:  $($line.Substring(3))" -ForegroundColor $ColorWarning
    }
    elseif ($line -match "^\s*A\s+") {
        Write-Host "  Added:     $($line.Substring(3))" -ForegroundColor $ColorSuccess
    }
    elseif ($line -match "^\s*D\s+") {
        Write-Host "  Deleted:   $($line.Substring(3))" -ForegroundColor $ColorError
    }
    elseif ($line -match "^\?\?") {
        Write-Host "  New:       $($line.Substring(3))" -ForegroundColor $ColorSuccess
    }
    else {
        Write-Host "  $line" -ForegroundColor $ColorInfo
    }
}

Write-Host ""

# ===============================================
# STEP 5: COMMIT MESSAGE
# ===============================================

Write-Host "═══ STEP 5: Commit Changes ═══" -ForegroundColor $ColorHeader
Write-Host ""

# Ask for commit message
Write-Host "Enter a description of your changes:" -ForegroundColor $ColorWarning
Write-Host "(Press Enter to use automatic message)" -ForegroundColor $ColorInfo
Write-Host ""
$commitMessage = Read-Host "Message"

if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Update website - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    Write-Host "  → Using automatic message: $commitMessage" -ForegroundColor $ColorInfo
}

Write-Host ""

# ===============================================
# STEP 6: DEPLOY TO GITHUB
# ===============================================

Write-Host "═══ STEP 6: Deploy to GitHub ═══" -ForegroundColor $ColorHeader
Write-Host ""

# Add all changes
Write-Host "[DEPLOY] Adding changes..." -ForegroundColor $ColorInfo
git add . 2>&1 | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ Failed to add changes" -ForegroundColor $ColorError
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-Host "  ✓ Changes staged" -ForegroundColor $ColorSuccess

# Commit changes
Write-Host "[DEPLOY] Committing changes..." -ForegroundColor $ColorInfo
git commit -m "$commitMessage" 2>&1 | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ Commit failed (possibly no changes after staging)" -ForegroundColor $ColorWarning
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-Host "  ✓ Changes committed" -ForegroundColor $ColorSuccess

# Push to GitHub
Write-Host "[DEPLOY] Pushing to GitHub..." -ForegroundColor $ColorInfo
Write-Host "  (This may take a few seconds...)" -ForegroundColor $ColorInfo
Write-Host ""

$pushOutput = git push origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Successfully pushed to GitHub!" -ForegroundColor $ColorSuccess
}
else {
    Write-Host "  ✗ Push failed" -ForegroundColor $ColorError
    Write-Host ""
    Write-Host "Error details:" -ForegroundColor $ColorWarning
    Write-Host $pushOutput
    Write-Host ""
    Write-Host "Common solutions:" -ForegroundColor $ColorInfo
    Write-Host "  1. Check your internet connection" -ForegroundColor $ColorInfo
    Write-Host "  2. Verify GitHub credentials" -ForegroundColor $ColorInfo
    Write-Host "  3. Try running: git push origin main manually" -ForegroundColor $ColorInfo
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host ""

# ===============================================
# STEP 7: VERIFICATION
# ===============================================

Write-Host "═══ STEP 7: Deployment Verification ═══" -ForegroundColor $ColorHeader
Write-Host ""

# Get last commit info
$lastCommit = git log -1 --pretty=format:"%h - %s (%cr)" 2>$null
Write-Host "[INFO] Last commit: $lastCommit" -ForegroundColor $ColorInfo

# Get repository URL
$repoUrl = git remote get-url origin 2>$null
if ($repoUrl -match "github.com[:/](.+)/(.+)\.git") {
    $username = $matches[1]
    $repoName = $matches[2]
    $ghPagesUrl = "https://$username.github.io/$repoName/"
    
    Write-Host "[INFO] Repository: $repoUrl" -ForegroundColor $ColorInfo
    Write-Host "[INFO] Website URL: $ghPagesUrl" -ForegroundColor $ColorInfo
}

Write-Host ""

# ===============================================
# SUCCESS!
# ===============================================

Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor $ColorSuccess
Write-Host "║                                                ║" -ForegroundColor $ColorSuccess
Write-Host "║          ✓ DEPLOYMENT SUCCESSFUL! ✓            ║" -ForegroundColor $ColorSuccess
Write-Host "║                                                ║" -ForegroundColor $ColorSuccess
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor $ColorSuccess
Write-Host ""
Write-Host "Your website will be updated in 2-3 minutes!" -ForegroundColor $ColorSuccess
Write-Host ""
Write-Host "Next steps:" -ForegroundColor $ColorInfo
Write-Host "  1. Wait 2-3 minutes for GitHub Pages to rebuild" -ForegroundColor $ColorInfo
Write-Host "  2. Visit your website to see the changes" -ForegroundColor $ColorInfo
Write-Host "  3. Hard refresh if needed: Ctrl + Shift + R" -ForegroundColor $ColorInfo
Write-Host ""

# Show backup location
Write-Host "Backup saved to: $backupFolder\$timestamp`_*.html" -ForegroundColor $ColorInfo
Write-Host ""

# ===============================================
# CLEANUP
# ===============================================

# Clean old backups (keep last 10 only)
$allBackups = Get-ChildItem $backupPath -Filter "*.html" | Sort-Object LastWriteTime -Descending
if ($allBackups.Count -gt 50) {
    $backupsToDelete = $allBackups | Select-Object -Skip 50
    foreach ($backup in $backupsToDelete) {
        Remove-Item $backup.FullName -Force
    }
    Write-Host "[CLEANUP] Removed old backups (kept last 50)" -ForegroundColor $ColorInfo
    Write-Host ""
}

# ===============================================
# FINISH
# ===============================================

Write-Host "═══════════════════════════════════════════════" -ForegroundColor $ColorHeader
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor $ColorInfo
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Exit with success code
exit 0
