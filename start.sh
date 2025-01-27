#!/bin/bash
./config.sh --url https://github.com/${GITHUB_REPO} --token ${GITHUB_RUNNER_TOKEN} --name ${RUNNER_NAME} --unattended
./run.sh

# Keep the container running
tail -f /dev/null