#!/bin/bash

link="http://10.0.17.47/Courses.html"

echo "=== Fetching and formatting page ==="
fullPage=$(curl -sL "$link")
formatted=$(echo "$fullPage" | xmlstarlet format --html --recover --nonet 2>/dev/null)

echo "Formatted HTML size: ${#formatted} bytes"
echo ""

# Save the formatted HTML to examine structure
echo "$formatted" > /tmp/formatted.html
echo "Saved formatted HTML to /tmp/formatted.html"
echo ""

echo "=== Looking at the structure around 'table' ==="
echo "$formatted" | grep -i "table" | head -5
echo ""

echo "=== Testing MANY different XPath patterns ==="
echo ""

# List of XPath patterns to try
xpaths=(
    "//table//tr"
    "//TABLE//TR"
    "/html/body/table/tr"
    "/html/body//table//tr"
    "//table/tr"
    "//table/tbody/tr"
    "//body//table/tr"
    "//body/table//tr"
    "//*[local-name()='table']//*[local-name()='tr']"
    "//tr"
    "/html//tr"
    "//body//tr"
)

for xpath in "${xpaths[@]}"; do
    result=$(echo "$formatted" | xmlstarlet select --template --copy-of "$xpath" 2>/dev/null)
    size=${#result}
    
    echo -n "Testing: $xpath"
    if [ $size -gt 100 ]; then
        echo " ... ✓ WORKS! ($size bytes)"
    elif [ $size -gt 0 ]; then
        echo " ... ⚠ Got $size bytes (might work)"
    else
        echo " ... ✗ Failed (0 bytes)"
    fi
done

echo ""
echo "=== Finding which XPath returns the most data ==="

best_xpath=""
best_size=0

for xpath in "${xpaths[@]}"; do
    result=$(echo "$formatted" | xmlstarlet select --template --copy-of "$xpath" 2>/dev/null)
    size=${#result}
    
    if [ $size -gt $best_size ]; then
        best_size=$size
        best_xpath="$xpath"
    fi
done

echo "Best XPath: $best_xpath"
echo "Size: $best_size bytes"
echo ""

if [ $best_size -gt 100 ]; then
    echo "=== Testing the best XPath with full processing ==="
    result=$(echo "$formatted" | xmlstarlet select --template --copy-of "$best_xpath" 2>/dev/null)
    
    output=$(echo "$result" | sed 's/<\/tr>/\n/g' | \
                     sed -e 's/&amp;//g' | \
                     sed -e 's/<tr>//g' | \
                     sed -e 's/<td[^>]*>//g' | \
                     sed -e 's/<\/td>/;/g' | \
                     sed -e 's/<[/\]\{0,1\}a[^>]*>//g' | \
                     sed -e 's/<[/\]\{0,1\}nobr>//g')
    
    echo "First 3 lines of output:"
    echo "$output" | head -3
    echo ""
    echo "✓ Use this XPath in Courses.bash: $best_xpath"
else
    echo "❌ None of the XPaths worked well. Examining structure..."
    echo ""
    echo "First 50 lines of formatted HTML:"
    echo "$formatted" | head -50
fi
