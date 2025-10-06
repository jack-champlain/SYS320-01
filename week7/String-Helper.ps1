
function getLines($contents, $lookline){

$lines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
 
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }

}

return $lines
}


$specialCharacters = 
function checkPassword($password){
    $validPassword = $True
    if($password.Length -lt 6){
        write-host "Password is under six characters."
        $validPassword = $False
    }
    if($password -inotlike "*[`?`/`!`@`#`$`%`^`&`*`(`)`]*"){
        write-host "Password does not contain a special character."
        $validPassword = $False
    }
    if($password -inotlike "*[0123456789]*"){
        write-host "Password does not contain a number."
        $validPassword = $False
    }
    if($password -inotlike "*[qwertyuiopasdfghjklzxcvbnm]*"){
    write-host "Password does not contain a letter."
    $validPassword = $False
    }
    return $validPassword
}

$password = "abcde123!"