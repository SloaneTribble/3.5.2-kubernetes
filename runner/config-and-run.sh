#!/bin/bash

# Source the .env file to load the secrets
if [ -f .env ]; then
  source .env
else
  echo "Error: The .env file is missing."
  exit 1
fi

# Set variables loaded from .env

echo $REPO
echo $TOKEN
REPOSITORY=$REPO
ACCESS_TOKEN=$TOKEN


# Use GitHub API to retrieve registration token for actions runner
REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq .token --raw-output)

cd /home/GHA/actions-runner

./config.sh --url https://github.com/${REPOSITORY} --token ${REG_TOKEN}

# Cleanup runner config when script exits
cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${REG_TOKEN}
}

# Call cleanup when SIGINT or SIGTERM is received (ctrl+C for Mac)
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Wait for last background process to finish before script exits
./run.sh & wait $!