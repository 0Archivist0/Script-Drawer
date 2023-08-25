#!/bin/bash
# Author: Kris Tomplait
# This was made for a friend who uses ubuntu...
# its to autmoate the installation of the alsa driver.... lets hope it don't fuck up his computer
# use at your own risk 


# Function to check if a package is installed
is_package_installed() {
    dpkg -l | grep -q "^ii  $1"
}

# Check if ALSA driver is installed
if ! is_package_installed alsa-base; then
    echo "ALSA driver not installed. Checking for download..."
    
    # Check if ALSA driver package is downloaded
    if [ ! -f /var/cache/apt/archives/alsa-base*.deb ]; then
        echo "ALSA driver package not downloaded. Downloading and installing..."
        sudo apt-get update
        sudo apt-get install -y alsa-base
    else
        echo "ALSA driver package downloaded. Installing..."
        sudo dpkg -i /var/cache/apt/archives/alsa-base*.deb
        sudo apt-get install -f -y
    fi
else
    echo "ALSA driver is already installed."
fi

# Check and install GCC or CC compiler
if ! is_package_installed gcc || ! is_package_installed cc; then
    echo "GCC or CC compiler not installed. Installing..."
    sudo apt-get install -y gcc
else
    echo "GCC or CC compiler is already installed."
fi

# Clean exit
echo "Script execution completed."
exit 0
