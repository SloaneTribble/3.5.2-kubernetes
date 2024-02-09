# Use a base image
FROM --platform=linux/amd64 ubuntu:20.04

# Install wget (if not already installed)
RUN apt-get update \
    && apt-get install -y \
    wget \
    openjdk-8-jre \
    default-jdk \
    && rm -rf /var/lib/apt/lists/*
# Download the Nexus tarball and save it to a specific location
RUN wget https://download.sonatype.com/nexus/3/nexus-3.64.0-04-unix.tar.gz -O /tmp/nexus.tar.gz

# create non-root user "nexus-user"
RUN useradd -m nexus-user

# "For production it is not recommend that nexus be run from a user's home directory, a common practice is to use /opt."
RUN cd /opt/ \
    && tar xvzf /tmp/nexus.tar.gz

# Make sure that the nexus-user user owns the directory used to start Nexus
# -R performs the operation recursively
RUN chown -R nexus-user:nexus-user /opt/
USER nexus-user

# individual container worked without this, but adding for compose
EXPOSE 8081

ENTRYPOINT [ "./opt/nexus-3.64.0-04/bin/nexus", "run" ]

