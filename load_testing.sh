#!/bin/bash
numCompare() {
    num=$1
    maxNum=$2
    awk "BEGIN {printf ($num > $maxNum) ? 0 : 1}"
}

apache_server=$1

avarage_response_time=0
max_response_time=0

for i in {1..2}; do
    response_time=$(curl --output /dev/null --silent --write-out '%{time_total}' "$apache_server")
    avarage_response_time=$(echo | awk "{print $avarage_response_time + $response_time}")

    if [[ $(numCompare "$response_time" "$max_response_time") -eq 0 ]]; then
        max_response_time=$response_time
    fi

    #just to make sure 1 second per request
    sleep 1
done

avarage_response_time=$(echo | awk "{print $avarage_response_time / 100}")

echo "Avarage response time: $avarage_response_time""s"
echo "Maximum response time: $max_response_time""s"