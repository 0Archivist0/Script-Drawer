#!/bin/bash

# Function to display an error message and exit
exit_with_error() {
    echo "Error: $1"
    exit 1
}

# Function to check if a command is available or exit
check_command_or_exit() {
    if ! command -v "$1" >/dev/null 2>&1; then
        exit_with_error "$1 command not found. Please install it and try again."
    fi
}

# Function to install a package if it's not already installed
install_package() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        sudo apt-get install -y "$1" || exit_with_error "Failed to install $1"
    fi
}

# Update the system
sudo apt-get update || exit_with_error "Failed to update the system"

# Check prerequisites
check_command_or_exit "git"
check_command_or_exit "curl"

# Install Git
install_package "git"

# Install Node.js and NPM
if ! dpkg -s "nodejs" >/dev/null 2>&1 || ! dpkg -s "npm" >/dev/null 2>&1; then
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - || exit_with_error "Failed to setup Node.js repository"
    install_package "nodejs"
fi

# Install Yarn
if ! dpkg -s "yarn" >/dev/null 2>&1; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - || exit_with_error "Failed to add Yarn GPG key"
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list || exit_with_error "Failed to add Yarn repository"
    sudo apt-get update || exit_with_error "Failed to update the system"
    install_package "yarn"
fi

# Clone the Botpress repository
if [ ! -d "botpress" ]; then
    git clone https://github.com/botpress/botpress.git || exit_with_error "Failed to clone the Botpress repository"
fi

# Change to the Botpress directory
cd botpress || exit_with_error "Failed to change to the Botpress directory"

# Install dependencies
yarn install || exit_with_error "Failed to install Botpress dependencies"

# Build Botpress
yarn build || exit_with_error "Failed to build Botpress"

# Start Botpress
yarn start || exit_with_error "Failed to start Botpress"

# Successful installation message
echo "Botpress has been successfully installed and started!"

# Exit the script with a success code
exit 0
