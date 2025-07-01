#!/bin/bash

dockerd &

#chown root:docker /var/run/docker.sock
GID=$(stat -c %g /var/run/docker.sock)
groupadd -g 964 docker2
usermod -a -G docker2 dock

su -c "exec ./github-runner.sh" dock
