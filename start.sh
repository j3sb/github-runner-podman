#!/bin/bash

dockerd &

su -c "./start-github-runner.sh" dock
