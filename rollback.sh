#!/bin/bash

# Rollback Script
DEPLOY_DIR="$HOME/devops-demo-env"
BLUE_DIR="$DEPLOY_DIR/production-blue"
GREEN_DIR="$DEPLOY_DIR/production-green"
PROD_LINK="$DEPLOY_DIR/production"

# Determine current environment
if [ -L "$PROD_LINK" ]; then
    CURRENT=$(readlink "$PROD_LINK")
    if [ "$CURRENT" == "$BLUE_DIR" ]; then
        TARGET="$GREEN_DIR"
        echo "Current environment is BLUE, rolling back to GREEN"
    else
        TARGET="$BLUE_DIR"
        echo "Current environment is GREEN, rolling back to BLUE"
    fi
    
    # Check if target environment exists
    if [ -d "$TARGET" ] && [ -f "$TARGET/version.txt" ]; then
        echo "Rolling back to previous environment..."
        ln -sfn "$TARGET" "$PROD_LINK"
        echo "Rollback completed. Previous version info:"
        cat "$TARGET/version.txt"
    else
        echo "ERROR: No previous environment to roll back to!"
        exit 1
    fi
else
    echo "ERROR: No current environment set up!"
    exit 1
fi