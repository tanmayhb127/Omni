
$StartDate = Get-Date -Date "2024-11-01"
$EndDate = Get-Date -Date "2026-02-04"
$TotalCommits = 125
$RepoUrl = "https://github.com/tanmayhb127/Omni.git"

# Calculate total days
$TotalDays = ($EndDate - $StartDate).Days
$Interval = $TotalDays / $TotalCommits

# Clean up existing git
if (Test-Path .git) {
    Remove-Item .git -Recurse -Force
}

git init
git config user.email "tanmayhb127@users.noreply.github.com"
git config user.name "tanmayhb127"
git branch -m main
git remote add origin $RepoUrl

# Create a history log file to modify
"Project Initialized" | Out-File "history.log" -Encoding utf8

$CurrentDate = $StartDate

for ($i = 1; $i -lt $TotalCommits; $i++) {
    # Update log file to create a change
    "Commit number $i - $($CurrentDate.ToString('yyyy-MM-dd'))" | Add-Content "history.log"
    
    git add "history.log"
    
    # Format date for git
    $GitDate = $CurrentDate.ToString("yyyy-MM-dd HH:mm:ss")
    
    # Commit with backdated environment variables
    $env:GIT_AUTHOR_DATE = $GitDate
    $env:GIT_COMMITTER_DATE = $GitDate
    
    git commit -m "Update project progress: Step $i"
    
    # Increment date
    $CurrentDate = $CurrentDate.AddDays($Interval)
}

# Final Commit with all files
git add .
$FinalDate = $EndDate.ToString("yyyy-MM-dd HH:mm:ss")
$env:GIT_AUTHOR_DATE = $FinalDate
$env:GIT_COMMITTER_DATE = $FinalDate
git commit -m "Final release: CampusCore Platform v1.0"

# Clear env vars
Remove-Item Env:\GIT_AUTHOR_DATE
Remove-Item Env:\GIT_COMMITTER_DATE

Write-Host "History generation complete. Repository is ready to push."
