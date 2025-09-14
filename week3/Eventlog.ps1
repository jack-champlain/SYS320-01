   clear

    # Logon events function
    function GetLogonEvents($DaysOld) { 
    # Get login and logoff records from windows-events for the last 14 days

    $loginlogouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$DaysOld)

    # Create an empty array
    $winlogonTable = @()

    # For as many login/logouts as there are:
    for($i=0; $i -lt $loginlogouts.Count; $i++){

    # Create event property value
    $event = ""
    if($loginlogouts[$i].InstanceId -eq "7001") {$event="Logon"}
    if($loginlogouts[$i].InstanceId -eq "7002") {$event="Logoff"}

    # Create User property value
    # Create the SID of the user
    $siduser = New-Object System.Security.Principal.SecurityIdentifier($loginlogouts[$i].ReplacementStrings[1])

    #Translate the SID to a username

        $user = $siduser.Translate([System.Security.Principal.NTAccount])

    # Create table of collected information
    $winlogonTable += [pscustomobject]@{"Time" = $loginlogouts[$i].TimeGenerated;
                                        "ID" = $loginlogouts[$i].InstanceId;
                                        "Event" = $event;
                                        "User" = $user;
                                        }
    }
    # Call the table
    $winlogonTable

    }









    # Start and shutdown times function


    # Logon events function
    function StartAndShutdown($DaysOld) { 
    # Get Start and shutdown records from windows-events for the last X days

    $PoweronPoweroff = Get-EventLog system -source EventLog -After (Get-Date).AddDays(-$DaysOld) | Where-Object { $_.EventID -eq 6005 -or $_.EventId -eq 6006}

    # Create an empty array
    $PowerTable = @()

    # For as many Startups/shutdowns as there are:
    for($i=0; $i -lt $PoweronPowerOff.Count; $i++){
    # If its event ID is equal to 6005 or 6006:

    # Create event property value
    $event = ""
    if($PoweronPoweroff[$i].EventID -eq 6006) {$event="Power On"}
    if($PoweronPoweroff[$i].EventID -eq 6005) {$event="Power Off"}

    # Create User property value
    $user = "SYSTEM"

    # Create table of collected information
    $PowerTable += [pscustomobject]@{"Time" = $PoweronPoweroff[$i].TimeGenerated;
                                    "ID" = $PoweronPoweroff[$i].EventId;
                                    "Event" = $event;
                                    "User" = $user;
                                    }
    }
    # Call the table
    $PowerTable

    }

    # Get Login and logouts from the last 15 days
    $winlogonTable = GetLogonEvents 15
    $winlogonTable
    # Get shutdowns from the last 15 days
    $PowerTable = StartAndShutdown 15
    $PowerTable 
    # Get Start ups from the last 15 days

