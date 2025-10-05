$scraped_page = Invoke-WebRequest -Uri "http://10.0.17.40/tobescraped.html"

$scraped_page.Links.Count
