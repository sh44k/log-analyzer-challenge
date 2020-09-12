#!/bin/bash
input=$1

line_count=0
avg_time=0
slower_than_100=0
slower_than_500=0
slower_than_1000=0

latest_log=$(tail -n 10000 $input)
IFS=$'\n'

for line in $(less $input)
do
    line_count=$(expr $line_count + 1)
    response_time=$(echo $line | sed -E 's/.* \[.*\] \".*\" [0-9]+ [0-9]+ \".*\" ([0-9]+) .*/\1/g')
    response_time_microsec=$(expr $response_time / 1000)
    avg_time=$(expr $avg_time + $response_time_microsec)
    if [[ response_time_microsec -gt 1000 ]]; then
        slower_than_1000=$(expr $slower_than_1000 + 1)
    elif [[ response_time_microsec -gt 500 ]]; then
        slower_than_500=$(expr $slower_than_500 + 1)
    elif [[ response_time_microsec -gt 100 ]]; then 
        slower_than_100=$(expr $slower_than_100 + 1)
    fi
done

avg_time=$(expr $avg_time / $line_count)

echo "slower than 100ms responses: $slower_than_100"
echo "slower than 500ms responses: $slower_than_500"
echo "slower than 1000ms responses: $slower_than_1000"
echo "Avarage response time in milisecond: $avg_time"