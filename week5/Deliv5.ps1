$divs1=$scraped_page.ParsedHtml.body.getElementsByTagName("div") | where {
$_.getAttributeNode("class").Value -ilike "*div-1" } | select innerText

$divs1
