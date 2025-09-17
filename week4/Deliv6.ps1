clear
$A = Get-ChildItem C:\xampp\apache\logs\*.log | Select-String 'error'
$A[-5..-1]