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
gatherTable