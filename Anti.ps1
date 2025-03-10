# Define paths and settings
$defenderScriptPath = "C:\Scripts\DisableDefender.ps1"
$antivirusScriptPath = "C:\Scripts\DisableAntivirus.ps1"
$taskNameDefender = "Disable Windows Defender"
$taskNameAntivirus = "Disable Third-Party Antivirus"

# 1. Disable Windows Defender Real-time Protection
Write-Host "Disabling Windows Defender real-time protection..."
Set-MpPreference -DisableRealtimeMonitoring $true

# 2. Create the Disable Windows Defender Script (if needed)
if (-not (Test-Path $defenderScriptPath)) {
    Write-Host "Creating DisableDefender.ps1 script..."
    $disableDefenderScript = @"
# Disable Windows Defender Real-time Protection
Set-MpPreference -DisableRealtimeMonitoring $true
"@
    $disableDefenderScript | Set-Content -Path $defenderScriptPath
    Write-Host "DisableDefender.ps1 script created at $defenderScriptPath"
}

# 3. Create Scheduled Task to Disable Windows Defender on Startup
Write-Host "Creating Scheduled Task to disable Windows Defender on startup..."
$actionDefender = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File $defenderScriptPath"
$triggerDefender = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName $taskNameDefender -Trigger $triggerDefender -Action $actionDefender -RunLevel Highest -User "SYSTEM" -Force
Write-Host "Scheduled Task created: $taskNameDefender"

# 4. Create the Disable Third-Party Antivirus Script (if needed)
if (-not (Test-Path $antivirusScriptPath)) {
    Write-Host "Creating DisableAntivirus.ps1 script..."
    $disableAntivirusScript = @"
# Example for disabling third-party antivirus (replace with your antivirus command)
Start-Process "C:\Program Files\AntivirusSoftware\Antivirus.exe" -ArgumentList "/disable"
"@
    $disableAntivirusScript | Set-Content -Path $antivirusScriptPath
    Write-Host "DisableAntivirus.ps1 script created at $antivirusScriptPath"
}

# 5. Create Scheduled Task to Disable Third-Party Antivirus on Startup
Write-Host "Creating Scheduled Task to disable third-party antivirus on startup..."
$actionAntivirus = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File $antivirusScriptPath"
$triggerAntivirus = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName $taskNameAntivirus -Trigger $triggerAntivirus -Action $actionAntivirus -RunLevel Highest -User "SYSTEM" -Force
Write-Host "Scheduled Task created: $taskNameAntivirus"

# 6. Optional: Permanently Disable Windows Defender via Registry (use with caution)
Write-Host "Disabling Windows Defender permanently via Registry..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
Write-Host "Windows Defender permanently disabled."

Write-Host "All tasks have been completed. The scripts will now run on startup and disable antivirus software."
