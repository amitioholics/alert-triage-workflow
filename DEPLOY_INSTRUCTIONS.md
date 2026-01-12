# Instructions to Deploy to GitHub

## Step 1: Create a GitHub Repository
1. Go to https://github.com/new
2. Enter a repository name (e.g., "alert-triage-workflow")
3. Choose public or private
4. **DO NOT** initialize with README, .gitignore, or license (we already have files)
5. Click "Create repository"

## Step 2: Connect and Push to GitHub

After creating the repository, run these commands (replace `YOUR_USERNAME` and `REPO_NAME` with your actual values):

```powershell
cd "C:\Users\Amit singh Rajput\OneDrive\Desktop\1"
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```

**Example:**
If your username is `johndoe` and repository name is `alert-triage-workflow`, the command would be:
```powershell
git remote add origin https://github.com/johndoe/alert-triage-workflow.git
git branch -M main
git push -u origin main
```

## Alternative: Using SSH (if you have SSH keys set up)
```powershell
git remote add origin git@github.com:YOUR_USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```

## What's Already Done
✅ Git repository initialized
✅ PDF file added and committed
✅ README.md created and committed

You just need to create the GitHub repository and push!
