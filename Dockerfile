FROM ubuntu:20.04

ENV RUNNER_VERSION=2.311.0
ENV RUNNER_ARCH=x64
ENV RUNNER_PLATFORM=osx

# Create a non-root user
RUN useradd -m runner

# Set the user
USER runner

RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install macOS cross-compilation tools
RUN apt-get update && apt-get install -y \
    clang \
    gcc-multilib \
    g++-multilib \
    && rm -rf /var/lib/apt/lists/*

# Download and install GitHub runner
RUN mkdir -p /actions-runner \
    && cd /actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${RUNNER_PLATFORM}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-${RUNNER_PLATFORM}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && rm actions-runner-${RUNNER_PLATFORM}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz

WORKDIR /actions-runner
COPY start.sh .
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]