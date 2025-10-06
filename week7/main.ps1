﻿. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt  = "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Get At-Risk users`n"
$Prompt += "10 - Exit`n"

$operation = $true

while($operation){
    Write-Host $Prompt | Out-String
    $choice = Read-Host 

    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }
    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }
    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }
    elseif($choice -eq 3){ 
        $name = Read-Host -Prompt "Please enter the username for the new user"
        if (checkUser $name -eq $true){
            write-host "User already exists!"
        }
        else{
            $password = Read-Host -Prompt "Please enter the password for the new user"
            if (checkPassword $password -eq $true){
                $hashedPassword = ConvertTo-SecureString $password -AsPlainText -Force
                createAUser $name $hashedPassword
                write-host "Account for $name has been created"
            }
            else{
                write-host "Invalid password"
            }
        }
    }
    elseif($choice -eq 4){
        $name = Read-Host -Prompt "Please enter the username for the user to be removed"
        if(checkUser $name){
            removeAUser $name
            Write-Host "User: $name Removed." | Out-String
        }
        else{
            Write-Host "Could not find the user $name."
        }
    }
    elseif($choice -eq 5){
        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"
        if(checkUser $name){
            enableAUser $name
            Write-Host "User: $name Enabled." | Out-String
         }
         else{
            write-Host "Could not find the user $name."
         }
    }
    elseif($choice -eq 6){
        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"
        if(checkUser $name){
            disableAUser $name
            Write-Host "User: $name Disabled." | Out-String
        }
        else{
            Write-Host "Could not find the user $name."
        }
    }
    elseif($choice -eq 7){
        $name = Read-Host -Prompt "Please enter the username for the user logs"
        if(checkUser $name){
            $days = Read-Host "How many days back would you like to get logs from?"
            $userLogins = getLogInAndOffs $days
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
        else{
            Write-Host "Could not find the user $name."
        }
    }
    elseif($choice -eq 8){
        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
        if(checkUser $name){
            $days = Read-Host "How many days back would you like to get failed logins from?"
            $userLogins = getFailedLogins $days
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
        else{
            Write-Host "Could not find the user $name."
        }
    }
    elseif($choice -eq 9){
        $days = Read-Host -Prompt "This function shows a list of users with 10 or more failed logins from a selected number of days back. How many days back would you like to check from? "
        Write-Host "Affected Users:"
        Write-Host (getFailedLogins $days | Group-Object -Property User | Where-Object {$_.Count -ge 10} | Select Name, Count | Out-String)
    }
    else{
        Write-Host "Could not find the option for $choice."
    }
}