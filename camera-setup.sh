#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script needs to be run as root."
    exit 1
fi

# Step 1: Check and install required libraries and dependencies
REQUIRED_PACKAGES=(
    libcamera-utils
    v4l-utils
)

echo "Checking and installing required libraries and dependencies..."

for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! command_exists "$package"; then
        echo "Installing $package..."
        if ! apt-get install -y "$package"; then
            echo "Failed to install $package. Exiting..."
            exit 1
        fi
    else
        echo "$package is already installed. Updating..."
        if ! apt-get update && apt-get upgrade -y "$package"; then
            echo "Failed to update $package. Exiting..."
            exit 1
        fi
    fi
done

# Step 2: Check and install necessary IPA
IPA_PATH="/usr/lib/x86_64-linux-gnu/libcamera/ipa.so"

if [ ! -f "$IPA_PATH" ]; then
    echo "No IPA found at $IPA_PATH. Reinstalling libcamera..."
    if ! apt-get install --reinstall libcamera -y; then
        echo "Failed to reinstall libcamera. Exiting..."
        exit 1
    fi
fi

# Step 3: Check V4L2 H264 support
echo "Checking V4L2 H264 support..."

if ! v4l2-ctl --list-formats | grep -q "H264"; then
    echo "Unsupported V4L2 pixel format H264. Updating video-related packages..."
    if ! apt-get update && apt-get upgrade -y; then
        echo "Failed to update video-related packages. Exiting..."
        exit 1
    fi
fi

# Step 4: Check camera permissions
echo "Checking camera permissions..."

if [ ! -w "/dev/video0" ]; then
    echo "Insufficient permissions to access the camera. Updating permissions..."
    if ! chmod 666 /dev/video0; then
        echo "Failed to update camera permissions. Exiting..."
        exit 1
    fi
fi

# Output available cameras
echo "Available cameras:"
cam -l
