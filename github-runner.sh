#!/bin/bash

DOCKER_USERNAME=$DOCKER_USERNAME
DOCKER_TOKEN=$DOCKER_TOKEN
ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$ACCESS_TOKEN

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)

cd /home/podman/actions-runner

./config.sh --unattended --labels podman --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM


podman login -u ${DOCKER_USERNAME} -p ${DOCKER_TOKEN} docker.io

./run.sh & wait $!
