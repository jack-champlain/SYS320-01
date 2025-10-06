﻿function Chrome(){
    $chromeProcess = Get-Process -Name *chrome*

    if ($chromeProcess -eq $null) {

    Start-Process "chrome" -ArgumentList "https://www.champlain.edu"
    Write-Host "There was no instance of Chrome running, starting Chrome"
    } 
    else {

    Stop-Process -Name *chrome*
    Write-Host "Closing Chrome, as it was running."
    }