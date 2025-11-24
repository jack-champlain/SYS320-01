#!/bin/bash

URL="http://10.0.17.47/Assignment.html"

curl -s "$URL" | grep -oP '(?<=<td>)[^<]+(?=</td>)' | awk '
BEGIN {
    temp_count = 0
    pressure_count = 0
    reading_temps = 1
    skip_count = 0
}
{
    if ($0 == "Temprature" || $0 == "Date-Time" || $0 == "Pressure") {
        skip_count++
        if (skip_count == 4) {
            reading_temps = 0
        }
        next
    }
    
    if (reading_temps) {
        if (temp_count % 2 == 0) {
            temp_val = $0
        } else {
            temps[$0] = temp_val
            temp_times[temp_count/2] = $0
        }
        temp_count++
    }
    else {
        if (pressure_count % 2 == 0) {
            pressure_val = $0
        } else {
            pressures[$0] = pressure_val
        }
        pressure_count++
    }
}
END {
    for (i = 0; i < (temp_count/2); i++) {
        datetime = temp_times[i]
        if (datetime in pressures) {
            print pressures[datetime], temps[datetime], datetime
        }
    }
}
'
