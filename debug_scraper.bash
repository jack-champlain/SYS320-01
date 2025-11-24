#!/bin/bash

URL="http://10.0.17.47/Assignment.html"

echo "=== Step 1: Fetching URL ==="
HTML=$(curl -s "$URL")
echo "HTML length: ${#HTML} characters"
echo ""

echo "=== Step 2: Extracting table cells ==="
echo "$HTML" | grep -oP '(?<=<td>)[^<]+(?=</td>)' | tee /tmp/cells_debug.txt
echo ""

echo "=== Step 3: Cell count ==="
wc -l /tmp/cells_debug.txt
echo ""

echo "=== Step 4: First 15 cells ==="
head -15 /tmp/cells_debug.txt
