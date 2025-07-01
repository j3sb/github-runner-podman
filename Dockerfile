FROM debian:latest

ARG RUNNER_VERSION="2.325.0"


# Install necessary packages for setting up the Docker repository
RUN apt update && \
    apt install --no-install-recommends -y ca-certificates curl gnupg dpkg lsb-release

# Add Docker’s official GPG key
RUN install -m 0755 -d /etc/apt/keyrings 
RUN curl -sS https://download.docker.com/linux/debian/gpg | gpg --dearmor > /usr/share/keyrings/docker-ce.gpg
RUN chmod a+r /usr/share/keyrings/docker-ce.gpg

# Set up the Docker repository
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-ce.gpg] https://download.docker.com/linux/debian $(lsb_release -sc) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, Docker CLI, and Docker Compose
RUN apt update && \
    apt install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN apt-get update -y && apt-get upgrade -y && useradd -m dock

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN cd /home/dock && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz


# install some additional dependencies
RUN chown -R dock ~dock && /home/dock/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

RUN groupadd -g 964 docker2
RUN usermod -a -G docker2 dock
#RUN chown root:docker /var/run/docker.sock

# since the config and run script for actions are not allowed to be run by root,
# set the user to "dock" so all subsequent commands are run as the dock user
USER dock

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
