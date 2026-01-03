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


# Loop for running each command
# Will display command output each time and ask
# to proceed with the next one
# Loop will end once all commands have been
# executed or when the user chooses to not proceed
# with next command

count=1
for cmd in "${commands[@]}"; do
    echo ""
    echo "[$count] Next command: $cmd"
    read -rp "Proceed? (y/n) " ans

    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        echo "Running command..."

        # Capturing stdout and stderr
        output="$(bash -c "$cmd" 2>&1)"
        rc=$?

        # Print actual command output
        if [[ -n "$output" ]]; then
            echo "----------------------------------------"
            printf '%s\n' "$output"
            echo "----------------------------------------"
        else
            echo "(no output)"
        fi

        # On failure, prompt to continue
        if [[ $rc -ne 0 ]]; then
            read -rp "Continue to next command anyway? (y/n) " answer
            [[ "$answer" == "y" || "$answer" == "Y" ]] || exit "$rc"
        fi
    else
        echo "Aborted by user."
        exit 0
    fi

    ((count++))
done
