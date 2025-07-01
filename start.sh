#!/bin/bash

dockerd &

chown root:docker /var/run/docker.sock

su -c "./start-github-runner.sh" dock
