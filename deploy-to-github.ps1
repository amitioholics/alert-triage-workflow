# PowerShell script to deploy to GitHub
# This script will help you deploy your PDF to GitHub

param(
    [Parameter(Mandatory=$false)]
    [string]$GitHubUsername = "",
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "alert-triage-workflow",
    
    [Parameter(Mandatory=$false)]
    [string]$GitHubToken = ""
)

Write-Host "🚀 Deploying to GitHub..." -ForegroundColor Green

# Get current directory
$currentDir = Get-Location
Write-Host "Current directory: $currentDir" -ForegroundColor Cyan

# Check if git is initialized
if (-not (Test-Path ".git")) {
    Write-Host "❌ Git repository not initialized!" -ForegroundColor Red
    exit 1
}

# If username not provided, try to infer from email
if ([string]::IsNullOrEmpty($GitHubUsername)) {
    $email = git config --global user.email
    if ($email -match "([^@]+)@") {
        $GitHubUsername = $matches[1]
        Write-Host "📧 Inferred GitHub username from email: $GitHubUsername" -ForegroundColor Yellow
        Write-Host "   If this is incorrect, please provide your GitHub username" -ForegroundColor Yellow
    }
}

# If still no username, prompt for it
if ([string]::IsNullOrEmpty($GitHubUsername)) {
    $GitHubUsername = Read-Host "Enter your GitHub username"
}

# Create repository using GitHub API if token is provided
if (-not [string]::IsNullOrEmpty($GitHubToken)) {
    Write-Host "📦 Creating GitHub repository using API..." -ForegroundColor Cyan
    
    $body = @{
        name = $RepoName
        description = "Alert Triage Workflow Documentation"
        private = $false
    } | ConvertTo-Json
    
    $headers = @{
        "Authorization" = "token $GitHubToken"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
        Write-Host "✅ Repository created successfully!" -ForegroundColor Green
        Write-Host "   Repository URL: $($response.html_url)" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ Failed to create repository: $_" -ForegroundColor Red
        Write-Host "   You may need to create it manually at https://github.com/new" -ForegroundColor Yellow
    }
} else {
    Write-Host "📝 GitHub token not provided. You'll need to create the repository manually." -ForegroundColor Yellow
    Write-Host "   Go to: https://github.com/new" -ForegroundColor Cyan
    Write-Host "   Repository name: $RepoName" -ForegroundColor Cyan
    Write-Host ""
    $continue = Read-Host "Have you created the repository? (y/n)"
    if ($continue -ne "y") {
        Write-Host "Please create the repository first, then run this script again." -ForegroundColor Yellow
        exit 0
    }
}

# Set up remote and push
Write-Host ""
Write-Host "🔗 Setting up remote and pushing..." -ForegroundColor Cyan

# Remove existing remote if any
git remote remove origin 2>$null

# Add remote
$remoteUrl = "https://github.com/$GitHubUsername/$RepoName.git"
git remote add origin $remoteUrl

# Rename branch to main if needed
$currentBranch = git branch --show-current
if ($currentBranch -ne "main") {
    git branch -M main
}

# Push to GitHub
Write-Host "📤 Pushing to GitHub..." -ForegroundColor Cyan
try {
    git push -u origin main
    Write-Host ""
    Write-Host "✅ Successfully deployed to GitHub!" -ForegroundColor Green
    Write-Host "   Repository URL: https://github.com/$GitHubUsername/$RepoName" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Failed to push. You may need to authenticate." -ForegroundColor Red
    Write-Host "   Try: git push -u origin main" -ForegroundColor Yellow
    Write-Host "   Or set up a personal access token: https://github.com/settings/tokens" -ForegroundColor Yellow
}
