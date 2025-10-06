
﻿. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)
. (Join-Path $PSScriptRoot Chrome-Function.ps1)
. (Join-Path $PSScriptRoot Apache-Logs1.ps1)

clear

$Prompt  = "Please choose your operation:`n"
$Prompt += "1 - Display Last 10 Apache Logs`n"
$Prompt += "2 - Display Last 10 Failed Login Attempts For All Users`n"
$Prompt += "3 - Display At Risk Users`n"
$Prompt += "4 - Start Chrome and navigate it to champlain.edu. Closes Chrome if it already open`n"
$Prompt += "5 - Exit`n"


$operation = $true

while($operation){
    Write-Host $Prompt | Out-String
    $choice = Read-Host 

    if($choice -eq 5){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }
    elseif($choice -eq 1){
        ApacheLogs1
    }
    elseif($choice -eq 2){
        $days = Read-Host "How many days back would you like to get failed logins from?"
        LastTenFailedLogins $days
        
    }
    elseif($choice -eq 3){
        Write-Host "This function shows a list of users with 10 or more failed logins from a selected number of days back."
        $days = Read-Host -Prompt "How many days back would you like to check from? "
        Write-Host "Affected Users:"
        AtRiskUsers $days
    }
    elseif($choice -eq 4){
        Chrome
    }
    else{
        Write-Host "Could not find the option for $choice."
    }
}
