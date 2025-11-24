#!/bin/bash

URL="http://10.0.17.47/Assignment.html"

curl -s "$URL" | grep -oP '(?<=<td>)[^<]+(?=</td>)' | awk '
BEGIN { 
    count = 0 
}
{
    cells[count++] = $0
}
END {
    for (i = 0; i < 10; i += 2) {
        temp_val = cells[i]
        temp_time = cells[i+1]
        temps[temp_time] = temp_val
        times[i/2] = temp_time
    }
    
    for (i = 10; i < 20; i += 2) {
        pressure_val = cells[i]
        pressure_time = cells[i+1]
        pressures[pressure_time] = pressure_val
    }
    
    for (i = 0; i < 5; i++) {
        datetime = times[i]
        print pressures[datetime], temps[datetime], datetime
    }
}
'
