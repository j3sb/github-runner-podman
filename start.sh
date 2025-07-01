#!/bin/bash

dockerd &

su -c "exec ./github-runner.sh" dock
