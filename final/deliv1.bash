#!/bin/bash

curl -sL "http://10.0.17.47/IOC.html" | \
grep -oP '(?<=<td>)[^<]+(?=</td)' | \
awk 'NR % 2 == 1' > ioc.txt

