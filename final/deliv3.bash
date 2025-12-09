#!/bin/bash

echo "<html><body><h2>Access logs with IOC indicators:</h2><table border=\"1\">" > report.html

while read ip datetime page; do
	echo "<tr><td>$ip</td><td>$datetime</td><td>$page</td></td>" >> report.html
done < report.txt

echo "</table></body></html>" >> report.html

sudo mv report.html /var/www/html/
