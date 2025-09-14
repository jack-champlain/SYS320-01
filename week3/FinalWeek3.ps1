   clear

  
    function GetLogonEvents($DaysOld) { 

    $loginlogouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$DaysOld)

   
    $winlogonTable = @()

    
    for($i=0; $i -lt $loginlogouts.Count; $i++){

    $event = ""
    if($loginlogouts[$i].InstanceId -eq "7001") {$event="Logon"}
    if($loginlogouts[$i].InstanceId -eq "7002") {$event="Logoff"}

    $siduser = New-Object System.Security.Principal.SecurityIdentifier($loginlogouts[$i].ReplacementStrings[1])


        $user = $siduser.Translate([System.Security.Principal.NTAccount])

    $winlogonTable += [pscustomobject]@{"Time" = $loginlogouts[$i].TimeGenerated;
                                        "ID" = $loginlogouts[$i].InstanceId;
                                        "Event" = $event;
                                        "User" = $user;
                                        }
    }
    $winlogonTable
  }


    function StartAndShutdown($DaysOld) { 
   

    $PoweronPoweroff = Get-EventLog system -source EventLog -After (Get-Date).AddDays(-$DaysOld) | Where-Object { $_.EventID -eq 6005 -or $_.EventId -eq 6006}


    $PowerTable = @()

    
    for($i=0; $i -lt $PoweronPowerOff.Count; $i++){
  

    
    $event = ""
    if($PoweronPoweroff[$i].EventID -eq 6006) {$event="Power On"}
    if($PoweronPoweroff[$i].EventID -eq 6005) {$event="Power Off"}


    $user = "SYSTEM"

    $PowerTable += [pscustomobject]@{"Time" = $PoweronPoweroff[$i].TimeGenerated;
                                    "ID" = $PoweronPoweroff[$i].EventId;
                                    "Event" = $event;
                                    "User" = $user;
                                    }
    }

    $PowerTable

    }

 
    $winlogonTable = GetLogonEvents 15
    $winlogonTable
    $PowerTable = StartAndShutdown 15
    $PowerTable 
 

