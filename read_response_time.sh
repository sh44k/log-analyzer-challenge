#!/bin/bash
input=$1

# latest_log=$(tail -n 10 $input)
IFS='\n'

# echo "before loop"
# for line in $(tail -f $input)
# do
#     echo "in loop"
#     response_time=$(echo $line | sed -E 's/.* \[.*\] \".*\" [0-9]+ [0-9]+ \".*\" ([0-9]+) .*/\1/g')
#     response_time_microsec=$(expr $response_time / 1000)
#     if [[ response_time_microsec -gt 1000 ]]; then
#         echo $line
#     fi
# done

tail -f -n 10 $input | while read -r line; do
    response_time=$(echo $line | sed -E 's/.* \[.*\] \".*\" [0-9]+ [0-9]+ \".*\" ([0-9]+) .*/\1/g')
    response_time_microsec=$(expr $response_time / 1000)
    if [[ response_time_microsec -gt 1000 ]]; then
        echo "Response time: $response_time_microsec"
        echo $line
    fi
done