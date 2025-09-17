function Apache-Logs{
    clear
    $page = $args[0]
    $httpCode = $args[1]
    $browserName = $args[2]
    $notFounds =  Get-Content C:\xampp\apache\logs\access.log | Select-String "$page" |  Select-String $httpCode | Select-String $browserName

$regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

$ipsUnorganized = $regex.Matches($notFounds)

$ips = @()

for ($i=0; $i -lt $ipsUnorganized.Count; $i++){
    $ips += [pscustomobject]@{ "IP" = $ipsUnorganized[$i].Value; }
}


$ipsoften = $ips | Where-Object { $_.IP -ilike "10.*" }
$counts = $ipsoften | Group-Object IP
$counts | Select-Object Count, Name
}