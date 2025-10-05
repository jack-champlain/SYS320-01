.(Join-Path $PSScriptRoot deliv1.ps1)

$table = gatherClasses

$FullTable = daysTranslator $table

$FullTable | select "Class Code", Instructor, Location, Days, "Time Start", "Time End" | 
             where {$_.Instructor -ilike "Furkan Paligu"}

$FullTable | Where-Object { ($_.Location -ilike "JOYC 310") -and ($_.Days -contains "Monday")} |
             Sort-Object "Time Start" | 
             Select-Object "Time Start", "Time End", "Class Code"

$ITSInstructors = $FullTable | Where-Object {($_."Class Code" -ilike "SYS*") -or `
                                             ($_."Class Code" -ilike "NET*") -or `
                                             ($_."Class Code" -ilike "SEC*") -or `
                                             ($_."Class Code" -ilike "FOR*") -or `
                                             ($_."Class Code" -ilike "CSI*") -or `
                                             ($_."Class Code" -ilike "DAT*")} `
                             | Sort-Object "Instructor" | Select-Object "Instructor" -Unique

$FullTable | where{$_.Instructor -in $ITSInstructors.Instructor} `
           | Group-Object "Instructor" | Select-Object Count, Name | Sort-Object Count -Descending
