FROM ubuntu

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    build-essential \
    clang \
    gcc-multilib \
    g++-multilib \
    libicu-dev \
    libssl-dev \
    libkrb5-dev \
    zlib1g \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Add a non-root user
RUN useradd -m runner && echo "runner:runner" | chpasswd && usermod -aG sudo runner

# Set up the runner
WORKDIR /home/runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-x64-2.308.0.tar.gz && \
    tar xzf actions-runner.tar.gz && \
    ./bin/installdependencies.sh && \
    rm actions-runner.tar.gz

# Copy entrypoint script (if you create one)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to the runner user
USER runner

# Default entrypoint
ENTRYPOINT ["/entrypoint.sh"]