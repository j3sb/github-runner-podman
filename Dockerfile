# only works when using docker lol
FROM quay.io/podman/stable

ARG RUNNER_VERSION="2.325.0"

RUN dnf install -y jq

RUN cd /home/podman && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz


# install some additional dependencies
RUN chown -R podman ~podman && /home/podman/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY github-runner.sh github-runner.sh

# make the script executable
RUN chmod +x github-runner.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "podman" so all subsequent commands are run as the dock user
USER podman

# set the entrypoint to the start.sh script
ENTRYPOINT ["./github-runner.sh"]
