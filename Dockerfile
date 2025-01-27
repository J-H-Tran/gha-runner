# This file contains the instructions on how to build the Docker image
FROM ubuntu:20.04

ENV RUNNER_VERSION=2.311.0
ENV RUNNER_ARCH=x64
ENV RUNNER_PLATFORM=linux

# Install necessary packages as root user
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    build-essential \
    clang \
    gcc-multilib \
    g++-multilib \
    libicu66 \
    libssl-dev \
    libkrb5-dev \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Create the /actions-runner directory and download the GitHub runner as root
RUN mkdir -p /actions-runner \
    && cd /actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${RUNNER_PLATFORM}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-${RUNNER_PLATFORM}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && rm actions-runner-${RUNNER_PLATFORM}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz

# Create a non-root user
RUN useradd -m runner

# Change ownership of the /actions-runner directory to the non-root user
RUN chown -R runner:runner /actions-runner

# Copy start.sh and change its permissions as root
COPY start.sh /actions-runner/start.sh
RUN chmod +x /actions-runner/start.sh

# Switch to the non-root user
USER runner

WORKDIR /actions-runner

ENTRYPOINT ["./start.sh"]