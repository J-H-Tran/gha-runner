#!/bin/bash

# Check if .env file exists one level up in root directory
if [ ! -f ../.env ]; then
  echo ".env file not found!"
  exit 1
fi

# Read .env file and encode values base64
while IFS='=' read -r key value; do
  if [ -n "$key" ] && [ -n "$value" ]; then
    encoded_value=$(echo -n "$value" | base64)
    echo "$key: $encoded_value"
  fi
done < <(grep -v '^#' ../.env | sed '/^\s*$/d')