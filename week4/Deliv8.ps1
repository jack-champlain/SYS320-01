$notFounds = Get-Content C:\xampp\apache\logs\access.log | Select-String -Pattern ' 404 '

$regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

$ipsUnorganized = $regex.Matches($notFounds)

$ips = @()

for ($i=0; $i -lt $ipsUnorganized.Count; $i++){
    $ips += [pscustomobject]@{ "IP" = $ipsUnorganized[$i].Value; }
}


$ipsoften = $ips | Where-Object { $_.IP -ilike "10.*" }
$counts = $ipsoften | Group-Object IP
$counts | Select-Object Count, Name