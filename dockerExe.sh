#!/bin/bash

pattern=$1
selogger=$2
output=$3
logfile="$3/script.log"

# Dockerイメージリストを取得
docker images --format "{{.Repository}}:{{.Tag}}" | grep $pattern > images.txt

# イメージリストから一つずつdocker run
while IFS= read -r line; do
    date=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$date: start $line" >> "$logfile"
    echo $date
    echo start $line
    dir=${line#*:}
    docker run -v $selogger:/selogger.jar -v $output:/tmp/selogger-docker-test $line mvn clean test -DargLine="-javaagent:/selogger.jar=output=/tmp/selogger-docker-test/$dir,weave=EXEC+CALL,format=omni" -B
    date=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$date: completed $line" >> "$logfile"

done < "images.txt"