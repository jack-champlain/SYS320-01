function ApacheLogs1(){
$logsNotFormatted = Get-Content C:\Users\champuser\SYS320-01\midterm\access.log
$tableRecords = @()

for($i=0; $i -lt $logsNotFormatted.Count; $i++){
    $words = $logsNotFormatted[$i].Split(" ")

    $tableRecords += New-Object PSObject -Property @{
        "IP" = $words[0];
        "Time" = $words[3].Trim('[');
        "Method" = $words[5].Trim('[');
        "Page" = $words[6];
        "Protocol" = $words[7];
        "Response" = $words[8];
        "Referrer" = $words[10];
        }
    }

    return $tableRecords
}

$tableRecords = ApacheLogs1
$tableRecords | Format-Table -AutoSize -Wrap