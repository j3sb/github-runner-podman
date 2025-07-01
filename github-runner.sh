#!/bin/bash

DOCKER_USERNAME=$DOCKER_USERNAME
DOCKER_TOKEN=$DOCKER_TOKEN
URL=$URL
REG_TOKEN=$REG_TOKEN

cd /home/dock/actions-runner

./config.sh --unattended --url $URL --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM


docker login -u ${DOCKER_USERNAME} -p ${DOCKER_TOKEN}

./run.sh & wait $!
