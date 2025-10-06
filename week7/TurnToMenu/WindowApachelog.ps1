function ApacheLogs1(){
$logsNotFormatted = Get-Content C:\xampp\apache\logs\access.log | Select-Object -Last 10
$tableRecords = @()

for($i=0; $i -lt $logsNotFormatted.Count; $i++){
    $words = $logsNotFormatted[$i].Split(" ")

    $tableRecords += New-Object PSObject -Property @{
        "IP" = $words[0];
        "Time" = $words[3].Trim('[');
        "Method" = $words[3].Trim('[');
        "Page" = $words[6];
        "Protocol" = $words[7];
        "Response" = $words[8];
        "Referrer" = $words[10];
        "Client" = $words[7];
        }
    }

    return $tableRecords | Where-Object { $_.IP -like "10.*" }
}

$tableRecords = ApacheLogs1
$tableRecords | Format-Table -AutoSize -Wrap