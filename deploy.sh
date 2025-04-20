#!/bin/bash

# Simple Blue-Green Deployment Script
DEPLOY_DIR="$HOME/devops-demo-env"
APP_DIR="$DEPLOY_DIR/app"
BLUE_DIR="$DEPLOY_DIR/production-blue"
GREEN_DIR="$DEPLOY_DIR/production-green"
PROD_LINK="$DEPLOY_DIR/production"
LOG_DIR="$DEPLOY_DIR/logs"

# Determine current environment
if [ -L "$PROD_LINK" ]; then
    CURRENT=$(readlink "$PROD_LINK")
    if [ "$CURRENT" == "$BLUE_DIR" ]; then
        TARGET="$GREEN_DIR"
        echo "Current environment is BLUE, deploying to GREEN"
    else
        TARGET="$BLUE_DIR"
        echo "Current environment is GREEN, deploying to BLUE"
    fi
else
    TARGET="$BLUE_DIR"
    echo "No current environment, deploying to BLUE"
fi

# Copy application files to target environment
echo "Copying files to $TARGET..."
rm -rf "$TARGET"/*
cp -r "$APP_DIR"/* "$TARGET"/

# Create version file for tracking
echo "Deployment time: $(date)" > "$TARGET/version.txt"
echo "Git commit: $(git rev-parse HEAD)" >> "$TARGET/version.txt"

# Switch the symlink to point to the new environment
echo "Switching production link to new environment..."
ln -sfn "$TARGET" "$PROD_LINK"

echo "Deployment completed successfully!"