# 🚀 Updated Website Updater - User Guide

## ✨ What's New in update-website.ps1

Your PowerShell update script has been **completely upgraded** with professional-grade features!

---

## 🎯 New Features

### 1. **Automatic Backups** 🛡️

- Every time you update, your HTML files are automatically backed up
- Backups saved to `backups/` folder with timestamp
- Keeps last 50 backups (automatically deletes older ones)
- Easy restoration if something goes wrong

### 2. **Pre-Deployment Checks** ✅

- Verifies Git is installed
- Confirms you're in a Git repository
- Checks GitHub connection
- Prevents errors before they happen

### 3. **Smart File Syncing** 🔄

- Automatically copies `bluewi.html` → `index.html` if changed
- Ensures your main page is always updated
- No manual copying needed

### 4. **Better Visual Feedback** 🎨

- Color-coded output (Green = success, Yellow = warning, Red = error)
- Step-by-step progress indicators
- Clear status messages
- Professional ASCII art headers

### 5. **Detailed Change Review** 📋

- Shows exactly which files changed
- Color-coded file status (Modified, Added, Deleted, New)
- Review changes before deployment

### 6. **Enhanced Error Handling** 🛠️

- Catches errors early
- Provides helpful error messages
- Suggests solutions for common problems
- Graceful failure with exit codes

### 7. **Deployment Verification** ✅

- Shows last commit information
- Displays your website URL
- Confirms successful deployment
- Provides next steps

### 8. **Automatic Cleanup** 🧹

- Removes old backups (keeps last 50)
- Adds `backups/` to `.gitignore`
- Keeps repository clean

---

## 📖 How to Use

### Simple Method (Recommended)

1. Make changes to your website files
2. **Right-click** `update-website.ps1`
3. Select **"Run with PowerShell"**
4. Follow the prompts
5. Done! ✅

### Command Line Method

```powershell
# Navigate to website folder
cd C:\Users\bluewi\Documents\website

# Run the script
.\update-website.ps1
```

---

## 🔄 What Happens When You Run It

### Step 1: Pre-Deployment Checks ✓

- Checks Git installation
- Verifies repository status
- Confirms GitHub connection

### Step 2: Create Backup 🛡️

- Backs up all HTML files
- Saves to `backups/` with timestamp
- Example: `backups/2025-12-26_03-30-00_bluewi.html`

### Step 3: Sync Files 🔄

- Checks if `bluewi.html` changed
- Auto-copies to `index.html`
- Ensures main page is updated

### Step 4: Review Changes 📋

- Shows all modified files
- Color-coded status display
- Lists what will be uploaded

### Step 5: Commit Message 💬

- Asks for description of changes
- Auto-generates if you press Enter
- Creates meaningful commit

### Step 6: Deploy to GitHub 🚀

- Stages all changes
- Commits with your message
- Pushes to GitHub
- Shows progress

### Step 7: Verification ✅

- Confirms successful upload
- Shows website URL
- Displays timing information
- Provides next steps

---

## 📊 Output Example

```
╔════════════════════════════════════════════════╗
║                                                ║
║        THE HORNETS - Website Updater           ║
║              BLUEWI © 2025                     ║
║                                                ║
╚════════════════════════════════════════════════╝

[INFO] Working directory: C:\Users\bluewi\Documents\website

═══ STEP 1: Pre-Deployment Checks ═══

[CHECK] Verifying Git installation...
  ✓ Git found: git version 2.43.0
[CHECK] Verifying Git repository...
  ✓ Git repository detected
[CHECK] Checking GitHub connection...
  ✓ Connected to: https://github.com/bleuwi-0wi/thehornet-website.git

═══ STEP 2: Creating Backup ═══

  ✓ Backed up 7 files to: backups/

═══ STEP 3: Syncing Files ═══

[SYNC] Checking bluewi.html...
  ✓ bluewi.html unchanged, no sync needed

═══ STEP 4: Review Changes ═══

Files to be updated:

  Modified:  products.html
  New:       images/new_product.jpg

Enter a description of your changes:
(Press Enter to use automatic message)

Message: Added new product page

═══ STEP 6: Deploy to GitHub ═══

[DEPLOY] Adding changes...
  ✓ Changes staged
[DEPLOY] Committing changes...
  ✓ Changes committed
[DEPLOY] Pushing to GitHub...
  (This may take a few seconds...)

  ✓ Successfully pushed to GitHub!

═══ STEP 7: Deployment Verification ═══

[INFO] Last commit: a05220b - Added new product page (2 seconds ago)
[INFO] Repository: https://github.com/bleuwi-0wi/thehornet-website.git
[INFO] Website URL: https://bleuwi-0wi.github.io/thehornet-website/

╔════════════════════════════════════════════════╗
║                                                ║
║          ✓ DEPLOYMENT SUCCESSFUL! ✓            ║
║                                                ║
╚════════════════════════════════════════════════╝

Your website will be updated in 2-3 minutes!

Next steps:
  1. Wait 2-3 minutes for GitHub Pages to rebuild
  2. Visit your website to see the changes
  3. Hard refresh if needed: Ctrl + Shift + R

Backup saved to: backups\2025-12-26_03-30-00_*.html
```

---

## 🛡️ Backup & Recovery

### Where Are Backups Stored?

```
C:\Users\bluewi\Documents\website\backups\
```

### Backup File Naming

```
YYYY-MM-DD_HH-mm-ss_filename.html

Example:
2025-12-26_15-30-45_bluewi.html
```

### How to Restore from Backup

If something goes wrong:

1. Go to `backups/` folder
2. Find the backup you want (sorted by date/time)
3. Copy it back to main folder:

   ```powershell
   Copy-Item backups\2025-12-26_15-30-45_bluewi.html bluewi.html
   ```

4. Run `update-website.ps1` again

### Backup Retention

- **Keeps**: Last 50 backup files
- **Deletes**: Older backups automatically
- **Storage**: Minimal (only HTML files)

---

## ⚠️ Troubleshooting

### "Git is not installed"

**Solution**: Install Git from <https://git-scm.com/download/win>

### "Not a Git repository"

**Solution**: Run `deploy-to-github.ps1` first to set up repository

### "No remote repository configured"

**Solution**: Run `deploy-to-github.ps1` to connect to GitHub

### "Push failed"

**Solutions**:

1. Check internet connection
2. Verify GitHub credentials
3. Generate new Personal Access Token
4. Try manually: `git push origin main`

### "No changes detected"

**Reason**: All files are already up to date
**Action**: No update needed, website is current

---

## 🎯 Best Practices

### ✅ DO

- Run this script every time you make changes
- Use descriptive commit messages
- Review the changes list before confirming
- Keep backups folder (automatic cleanup)
- Wait 2-3 minutes for changes to go live

### ❌ DON'T

- Delete the `backups/` folder manually
- Interrupt the script while pushing
- Modify multiple files without testing
- Push without reviewing changes

---

## 📝 Commit Message Examples

Good commit messages:

- ✅ "Added new product: Premium Editing Pack"
- ✅ "Fixed navigation menu on mobile"
- ✅ "Updated pricing information"
- ✅ "Improved dark mode styling"
- ✅ "Added inbox social media links"

Poor commit messages:

- ❌ "update"
- ❌ "changes"
- ❌ "asdf"
- ❌ "fix"

---

## 🚀 Quick Reference

### Update Website (Full Process)

```powershell
.\update-website.ps1
```

### Manual Git Commands (Advanced)

```powershell
# Check status
git status

# Add all changes
git add .

# Commit
git commit -m "Your message"

# Push to GitHub
git push origin main

# View commit history
git log --oneline -10
```

### View Backups

```powershell
# List all backups
dir backups\

# List recent backups (last 5)
dir backups\ | Sort-Object LastWriteTime -Descending | Select-Object -First 5
```

---

## 📊 Script Comparison

### Old Script

- ✅ Basic commit and push
- ✅ Sync bluewi.html to index.html
- ❌ No backups
- ❌ Minimal error checking
- ❌ Basic output

### New Script (Current)

- ✅ Advanced commit and push
- ✅ Smart file syncing
- ✅ **Automatic backups**
- ✅ **Comprehensive error checking**
- ✅ **Professional output with colors**
- ✅ **Pre-deployment validation**
- ✅ **Deployment verification**
- ✅ **Automatic cleanup**

---

## 🎓 Tips & Tricks

1. **Test Locally First**: Open `bluewi.html` in browser before deploying
2. **Small Commits**: Update frequently with small changes
3. **Descriptive Messages**: Help future you understand what changed
4. **Review Changes**: Always check the file list before confirming
5. **Keep Backups**: Don't delete the `backups/` folder
6. **Wait for Rebuild**: GitHub Pages takes 2-3 minutes to update

---

## 📞 Support

If you encounter issues:

- 📧 Email: <damimehdi20@gmail.com>
- 📱 Phone: +212 762635898
- 📚 Docs: DEPLOYMENT_INSTRUCTIONS.md
- 🔧 GitHub: <https://github.com/bleuwi-0wi/thehornet-website>

---

## 📅 Version History

- **v2.0** (2025-12-26): Complete rewrite with advanced features
  - Added automatic backups
  - Added pre-deployment checks
  - Enhanced error handling
  - Improved visual feedback
  - Added deployment verification
  - Automatic cleanup

- **v1.0** (2025-12-15): Initial version
  - Basic commit and push
  - bluewi.html syncing

---

**© 2023-2025 BLUEWI - THE HORNETS. All Rights Reserved.**

_Made with ❤️ for easy website updates_
