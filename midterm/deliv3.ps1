function gatherTable(){
    clear
    $page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.40/IOC.html

    $trs = $page.ParsedHtml.body.getElementsByTagName("tr")
    
    $FullTable = @()
    for($i=1; $i -lt $trs.length; $i++){ 
        $tds = $trs[$i].getElementsByTagName("td")

    $FullTable += [pscustomobject]@{
                                    "Pattern" = $tds[0].innerText;
                                    "Explanation" = $tds[1].innerText;
                                    }
    }
    return $FullTable

}

function ApacheLogs1(){
$logsNotFormatted = Get-Content C:\Users\champuser\Downloads/access.log
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

function SearchIndicators($logs, $indicators) {
    $matchedLogs = @()

    foreach ($log in $logs) {
        foreach ($indicator in $indicators) {
            if ($log.Page -match $indicator.Pattern) {
                $matchedLogs += $log
            }
        }
    }

    return $matchedLogs
}

$logs = ApacheLogs1
$indicators = gatherTable


SearchIndicators $logs $indicators | Format-Table