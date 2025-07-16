# only works when using docker lol
FROM quay.io/podman/stable

ARG RUNNER_VERSION="2.325.0"

RUN useradd -m podude

#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#    podman ca-certificates uidmap slirp4netns curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip
RUN dnf install -y jq


RUN cd /home/podude && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz


# install some additional dependencies
RUN chown -R podude ~podude && /home/podude/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
#COPY start.sh start.sh
COPY github-runner.sh github-runner.sh

# make the script executable
#RUN chmod +x start.sh
RUN chmod +x github-runner.sh

#RUN groupadd -g 964 docker2
#RUN usermod -a -G docker dock
#RUN chown root:docker /var/run/docker.sock

# since the config and run script for actions are not allowed to be run by root,
# set the user to "dock" so all subsequent commands are run as the dock user
USER podude

# set the entrypoint to the start.sh script
ENTRYPOINT ["./github-runner.sh"]
