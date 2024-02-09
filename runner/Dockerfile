# Adapted from https://github.com/beikeni/github-runner-dockerfile

# Use Ubuntu Linux as base image
# Must specify platform to build image on M1
FROM --platform=linux/amd64 ubuntu:20.04

# Prevents installdependencies.sh from prompting the user and blocking the image creation
ARG DEBIAN_FRONTEND=noninteractive

# Update package repositories and install/update packages
# jq is a command-line JSON processor
# apt-get update" updates the package index files, whereas "apt-get upgrade" upgrades the actual packages installed on your system
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
    jq \
    curl \
    bash

# Install .NET Core 6.0 dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
    libc6 \
    libgcc1 \
    libgssapi-krb5-2 \
    libicu66 \
    libssl1.1 \
    libstdc++6 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Set up a non-root user named "GHA"
# -m creates a home directory for "GHA"
RUN useradd -m GHA

# Download and unzip the latest GitHub actions 
# runner linux release into the GHA home folder
RUN cd /home/GHA && mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-2.312.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.312.0/actions-runner-linux-x64-2.312.0.tar.gz \
    && tar xzf ./actions-runner-linux-x64-2.312.0.tar.gz

# Copy the shell script into Docker image
COPY config-and-run.sh config-and-run.sh

# Copy env file
COPY .env .env

# Make sure that the GHA user owns the runner script and that it is executable
# -R performs the operation recursively
RUN chown -R GHA:GHA /home/GHA
RUN chown GHA:GHA config-and-run.sh
RUN chmod +x config-and-run.sh

# Set the docker image to run as the GHA user
USER GHA

ENTRYPOINT [ "./config-and-run.sh" ]



