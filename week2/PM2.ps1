Get-WmiObject Win32_Process | Where-Object {$_.ExecutablePath -notmatch "system32" }
Select-Object ProcessId, Name, ExecutablePath
