#!/bin/bash
# Author: Kris Tomplait
# this was made by me to automate the download and install of ventoy into a kali linux system
# and as it was made by me, use it at your own risk


# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

# Create a directory for Ventoy installation
install_dir="/opt/ventoy"
mkdir -p "$install_dir" || {
    echo "Failed to create the installation directory. Check permissions."
    exit 1
}

cd "$install_dir" || {
    echo "Failed to change to the installation directory."
    exit 1
}

# Fetch the latest Ventoy release URL from GitHub
latest_release_url=$(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep "browser_download_url" | grep "linux.tar.gz" | cut -d '"' -f 4)

if [ -z "$latest_release_url" ]; then
    echo "Failed to retrieve the latest Ventoy release URL. Check your internet connection or the URL."
    exit 1
fi

# Download the latest Ventoy release
wget -O ventoy.tar.gz "$latest_release_url" || {
    echo "Failed to download Ventoy. Check your internet connection or the URL."
    exit 1
}

# Extract the downloaded archive
tar -xzf ventoy.tar.gz || {
    echo "Failed to extract the Ventoy archive. Check if the archive is valid."
    exit 1
}

# Clean up the downloaded archive
rm ventoy.tar.gz

# Determine the Ventoy version from the URL
ventoy_version=$(basename "$latest_release_url" | cut -d '-' -f 2)

echo "Ventoy $ventoy_version is downloaded to $install_dir. You can now use it to create bootable USB drives."
