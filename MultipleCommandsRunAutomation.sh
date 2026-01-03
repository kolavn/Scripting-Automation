#!/usr/bin/env bash
# Sets the IP addresses as shell variables
k2v4_ip=${1:-}
bmc_ip=${2:-}

# Prompts user to enter valid values for the IP addresses
if [[ -z "$k2v4_ip" ]]; then
    read -rp "Enter k2v4 IP: " k2v4_ip
fi

if [[ -z "$bmc_ip" ]]; then
    read -rp "Enter BMC IP: " bmc_ip
fi

if [[ -z "$k2v4_ip" || -z "$bmc_ip" ]]; then
    echo "Missing required inputs."
    exit 2
fi