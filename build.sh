#!/bin/bash

set +e

if [ ! -f "Dockerfile" ]; then
    echo "Dockerfile is missing!"
    exit 1
fi

docker build -t zhangyr/ubuntu:16.04 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` -f Dockerfile .
