#!/bin/bash

# Script to get nautobot_config.py and jobs from container if they don't exist locally

CONFIG_DIR="./config"
CONFIG_FILE="$CONFIG_DIR/nautobot_config.py"
JOBS_DIR="./jobs"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Check if config file exists locally
if [ ! -f "$CONFIG_FILE" ]; then
    echo "nautobot_config.py not found locally. Attempting to copy from container..."
    
    # Check if nautobot container is running
    if docker ps --format "table {{.Names}}" | grep -q "nautobot"; then
        echo "Copying nautobot_config.py from running container..."
        docker cp nautobot:/opt/nautobot/nautobot_config.py "$CONFIG_FILE"
        echo "Successfully copied nautobot_config.py to $CONFIG_FILE"
    else
        echo "Error: nautobot container is not running."
        echo "Please start the container first with: docker-compose up -d"
        exit 1
    fi
else
    echo "nautobot_config.py already exists locally at $CONFIG_FILE"
fi

# Create jobs directory if it doesn't exist
mkdir -p "$JOBS_DIR"

# Check if jobs directory is empty
if [ -z "$(ls -A $JOBS_DIR 2>/dev/null)" ]; then
    echo "Jobs directory is empty. Attempting to copy from container..."
    
    # Check if nautobot container is running
    if docker ps --format "table {{.Names}}" | grep -q "nautobot"; then
        echo "Copying jobs directory from running container..."
        docker cp nautobot:/opt/nautobot/jobs/ "$JOBS_DIR/"
        echo "Successfully copied jobs directory to $JOBS_DIR"
    else
        echo "Error: nautobot container is not running."
        echo "Please start the container first with: docker-compose up -d"
        exit 1
    fi
else
    echo "Jobs directory already exists locally at $JOBS_DIR"
fi

echo "Configuration and jobs are ready!"
