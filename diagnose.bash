#!/bin/bash

echo "=== DIAGNOSTIC: Finding the problem ==="
echo ""

link="10.0.17.47/Courses.html"

echo "Step 1: Testing curl..."
fullPage=$(curl -sL "$link")
if [ -z "$fullPage" ]; then
    echo "❌ ERROR: curl returned nothing!"
    echo "   Trying with http:// prefix..."
    fullPage=$(curl -sL "http://$link")
fi

echo "   Page size: ${#fullPage} bytes"
if [ ${#fullPage} -lt 100 ]; then
    echo "   ⚠️  WARNING: Page seems too small"
    echo "   First 200 chars:"
    echo "$fullPage" | head -c 200
fi
echo ""

echo "Step 2: Testing xmlstarlet format..."
formatted=$(echo "$fullPage" | xmlstarlet format --html --recover --nonet 2>&1)
format_exit=$?
echo "   xmlstarlet exit code: $format_exit"
echo "   Formatted size: ${#formatted} bytes"
if [ ${#formatted} -lt 100 ]; then
    echo "   ⚠️  WARNING: Formatted output too small"
    echo "   xmlstarlet output:"
    echo "$formatted"
fi
echo ""

echo "Step 3: Testing xpath selector..."
toolOutput=$(echo "$fullPage" | \
    xmlstarlet format --html --recover --nonet 2>/dev/null | \
    xmlstarlet select --template --copy-of "//table//tr" 2>&1)
select_exit=$?
echo "   xmlstarlet select exit code: $select_exit"
echo "   Output size: ${#toolOutput} bytes"
if [ ${#toolOutput} -lt 100 ]; then
    echo "   ⚠️  WARNING: XPath returned nothing or too little"
    echo "   Output:"
    echo "$toolOutput"
fi
echo ""

echo "Step 4: Testing alternative approaches..."
echo ""

# Try without xmlstarlet - just use grep and sed
echo "Alternative 1: Using grep/sed only (no xmlstarlet)"
simple_output=$(curl -sL "http://$link" | grep -o '<tr[^>]*>.*</tr>' | head -3)
echo "   Output size: ${#simple_output} bytes"
if [ ${#simple_output} -gt 0 ]; then
    echo "   ✓ grep/sed approach works!"
    echo "   First line:"
    echo "$simple_output" | head -1 | cut -c1-100
fi
echo ""

# Try different URL formats
echo "Alternative 2: Testing different URL formats"
for url in "10.0.17.47/Courses.html" "http://10.0.17.47/Courses.html" "http://10.0.17.47:80/Courses.html"; do
    echo -n "   Testing: $url ... "
    result=$(curl -sL "$url" 2>&1 | head -c 100)
    if [ ${#result} -gt 50 ]; then
        echo "✓ Works!"
    else
        echo "✗ Failed or too small"
    fi
done
echo ""

echo "=== RECOMMENDATION ==="
echo ""
if [ ${#fullPage} -lt 100 ]; then
    echo "❌ PROBLEM: Cannot fetch the webpage"
    echo ""
    echo "Possible causes:"
    echo "1. Network connectivity issue to 10.0.17.47"
    echo "2. Web server not running"
    echo "3. Need to add 'http://' prefix"
    echo ""
    echo "Try this manually:"
    echo "   curl -v http://10.0.17.47/Courses.html"
else
    echo "✓ Webpage fetched successfully"
    echo ""
    echo "If xmlstarlet failed, try the grep/sed approach instead."
fi
