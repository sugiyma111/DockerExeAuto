#!/bin/bash

pattern="ghcr"

selogger=$1
output=$2

# Dockerイメージリストを取得
docker images --format "{{.Repository}}:{{.Tag}}" | grep $pattern > images.txt

while IFS= read -r line; do
    dir=${line#*:}
    docker run -v $selogger:/selogger.jar -v $output:/selogger-docker-test $line mvn clean test -DargLine="-javaagent:/selogger.jar=output=/tmp/selogger-docker-test/$dir,weave=EXEC+CALL,format=omni" -B
done < "images.txt"