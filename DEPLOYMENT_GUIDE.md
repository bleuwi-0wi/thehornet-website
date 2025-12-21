# 🚀 GitHub Pages Deployment Guide for THE HORNETS Website

Your website is now ready to be deployed to GitHub Pages! Follow these steps to make it live 24/7.

## ✅ What's Already Done

- ✅ Git installed on your PC
- ✅ Git repository initialized
- ✅ All website files committed to Git
- ✅ `index.html` created (GitHub Pages main file)
- ✅ `.gitignore` created
- ✅ `README.md` created

## 📋 Next Steps: Deploy to GitHub Pages

### Step 1: Create a GitHub Account (if you don't have one)

1. Go to [github.com](https://github.com)
2. Click "Sign up"
3. Enter your email address
4. Create a strong password
5. Choose a username (e.g., `bluewi-official` or similar)
6. Verify your account via email

### Step 2: Create a New Repository on GitHub

1. Log in to GitHub
2. Click the **+** icon in the top right corner
3. Select **"New repository"**
4. Fill in the details:
   - **Repository name**: `thehornet-website` (or any name you prefer)
   - **Description**: "THE HORNETS - BLUEWI official website"
   - **Visibility**: Choose **Public** (required for free GitHub Pages)
   - **DO NOT** check "Initialize this repository with a README" (we already have one)
5. Click **"Create repository"**

### Step 3: Connect Your Local Repository to GitHub

After creating the repository, GitHub will show you some commands. We'll use the "push an existing repository" option.

**IMPORTANT**: Replace `YOUR-USERNAME` and `YOUR-REPOSITORY-NAME` with your actual GitHub username and repository name in the command below.

Open a **new PowerShell window** in `C:\Users\bluewi\Documents\website` and run these commands **ONE BY ONE**:

```powershell
# Add GitHub as remote origin (REPLACE with your actual GitHub username and repo name!)
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY-NAME.git

# Rename main branch to 'main' (GitHub's default)
git branch -M main

# Push your code to GitHub
git push -u origin main
```

**Example** (if your username is `bluewi-official` and repo is `thehornet-website`):

```powershell
git remote add origin https://github.com/bluewi-official/thehornet-website.git
git branch -M main
git push -u origin main
```

When you run `git push`, GitHub will ask you to authenticate. You have two options:

#### Option A: Personal Access Token (Recommended)

1. Go to GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Give it a name (e.g., "Website deployment")
4. Select scopes: Check **repo** (all sub-options)
5. Click "Generate token"
6. **COPY THE TOKEN** (you won't see it again!)
7. When pushing, use your GitHub username and **paste the token as password**

#### Option B: GitHub CLI or Desktop

- Install [GitHub Desktop](https://desktop.github.com/) for easier authentication

### Step 4: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click on **Settings** (top right of the repository page)
3. Scroll down to **Pages** section (left sidebar)
4. Under **Source**, select:
   - Branch: **main**
   - Folder: **/ (root)**
5. Click **Save**

### Step 5: Access Your Live Website! 🎉

GitHub will take 1-2 minutes to build and deploy your site. Once done:

**Your website URL will be:**

```
https://YOUR-USERNAME.github.io/YOUR-REPOSITORY-NAME/
```

For example: `https://bluewi-official.github.io/thehornet-website/`

You can find the exact URL in the **Pages** settings section.

## 🔄 Making Updates in the Future

Whenever you want to update your website:

1. Make changes to your files in `C:\Users\bluewi\Documents\website`
2. Open PowerShell in that folder
3. Run these commands:

```powershell
git add .
git commit -m "Description of your changes"
git push
```

GitHub Pages will automatically update your live website within 1-2 minutes!

## ⚠️ Important Notes

- **Nothing is deleted from your PC** - All files remain in `C:\Users\bluewi\Documents\website`
- Your website will be **public** (anyone can see it)
- Your website will be **online 24/7** for free!
- If you make changes to `bluewi.html`, also update `index.html` or just copy it:

  ```powershell
  Copy-Item bluewi.html index.html
  ```

## 🆘 Troubleshooting

### If "git: command not found" error appears

Open a **NEW** PowerShell window (to refresh environment variables).

### If you want to use a custom domain

1. Buy a domain name
2. In GitHub repository settings → Pages → Custom domain
3. Follow GitHub's instructions to configure DNS

### If images don't load

Make sure all image paths in your HTML are relative (e.g., `images/logo.png` not `/images/logo.png`)

## 📧 Need Help?

If you encounter any issues:

1. Check GitHub's [Pages documentation](https://docs.github.com/en/pages)
2. Make sure your repository is **public**
3. Verify the branch name is **main** in Pages settings

---

🎊 **Congratulations!** Your website will be live and accessible worldwide 24/7 once you complete these steps!
