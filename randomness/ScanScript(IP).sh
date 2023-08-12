#!/bin/bash
# -------------------------------------------------------
# Author:Kris Tomplait
# Tested on Kali-Linux, but non other..
# it was write by me... so use at your own risk...use at your own Risk
# ---------------------------------------------------------
# This script retrieves, formats, and presents IPv4 network 
# information from the system's interfaces. It allows you to view the 
# information on-screen, save it to a text file, and export it to a CSV file for further analysis or processing.
# --------------------------------------------------------
# Function to get network information
function get_network_info() {
  sudo ip -o -4 addr show
}

# Function to format the output
function format_output() {
  local network_output=$1
  local formatted_output=()

  IFS=$'\n'
  lines=($network_output)

  for line in "${lines[@]}"; do
    local interface=$(echo "$line" | awk '{print $2}')
    local ip=$(echo "$line" | awk '{print $4}')
    local name=$(echo "$line" | awk '{print $6}')

    # Create formatted line
    formatted_line="$interface $ip $name"
    formatted_output+=("$formatted_line")
  done

  printf "%s\n" "${formatted_output[@]}"
}

# Check if the script is running with sudo or as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run the script with sudo or as root."
  exit 1
fi

# Verbose messaging for different stages
echo "Gathering network information..."

# Get network information
network_output=$(get_network_info)

echo "Formatting network information..."

# Format the output
formatted_output=$(format_output "$network_output")

echo "Sorting and filtering network information..."

# Sort the output by interface
sorted_output=$(echo "$formatted_output" | sort)

echo "Displaying network information:"

# Print the formatted output
counter=1
IFS=$'\n'
for line in $sorted_output; do
  echo "$counter.) $line"
  counter=$((counter+1))
done

# Function to save output to a file
function save_to_file() {
  local file_name=$1
  echo "$formatted_output" > "$file_name"
  echo "Network information saved to: $file_name"
}

# Function to export output to CSV
function export_to_csv() {
  local file_name=$1
  echo "Interface,IP,Name" > "$file_name"
  echo "$formatted_output" | awk '{print $1","$2","$3}' >> "$file_name"
  echo "Network information exported to: $file_name"
}

# Example usage of additional functions
save_to_file "network_info.txt"
export_to_csv "network_info.csv"

echo "Script execution completed."
