#Assignment 3 
#!/bin/bash

trap '' SIGTERM SIGHUP SIGINT

# Function to log messages if verbose mode is enabled
#using if else statement
log_message() {
    if [ "$VERBOSE" = true ]; then
        logger -t configure-host.sh "$1"
    fi
}

# Function to update hostname
update_hostname() {
    desired_name="$1"
    current_name=$(hostname)
# using if-else statement
   # Check if the desired hostname is different from the current hostname
if [ "$desired_name" != "$current_name" ]; then
    # Set the desired hostname using sudo and hostnamectl command
    sudo hostnamectl set-hostname "$desired_name"  # Set the desired hostname
    # Log a message indicating that the hostname has been updated
    log_message "Hostname updated to $desired_name"
    # Print a message indicating that the hostname has been updated
    echo "Hostname updated to $desired_name"
else
    # Log a message indicating that the hostname is already set to the desired hostname
    log_message "Hostname is already set to $desired_name"
fi

}

# Function to update IP address
update_ip_address() {
    desired_ip="$1"
    current_ip=$(hostname -I | awk '{print $1}')
#using if -else statement
   # Check if the desired IP address is different from the current IP address
if [ "$desired_ip" != "$current_ip" ]; then
    # Update the /etc/hosts file by replacing the old IP address with the new IP address
    sudo sed -i "s/$current_ip/$desired_ip/g" /etc/hosts  # Replace old IP with new IP in /etc/hosts

    # Update the netplan file
    # You may need to modify this command based on your specific netplan configuration
    # For example: sudo sed -i "s/$current_ip/$desired_ip/g" /etc/netplan/01-netcfg.yaml

    # Log a message indicating that the IP address has been successfully updated to the desired value
    log_message "IP address updated to $desired_ip"
    # Print a message to the terminal indicating that the IP address has been updated
    echo "IP address updated to $desired_ip"
else
    # If the desired IP address is the same as the current IP address, log a message stating it's already set
    log_message "IP address is already set to $desired_ip"
fi

}

# Function to update host entry in /etc/hosts
update_host_entry() {
    desired_name="$1"
    desired_ip="$2"
# using if-else statement 
    if grep -q "$desired_name" /etc/hosts; then
        log_message "Host entry already exists for $desired_name with IP $desired_ip"
    else
        echo "$desired_ip    $desired_name" | sudo tee -a /etc/hosts >/dev/null  # Add new host entry to /etc/hosts
        log_message "Host entry added for $desired_name with IP $desired_ip"
        echo "Host entry added for $desired_name with IP $desired_ip"
    fi
}

# Parse command line arguments
#using while loop
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -verbose)
        VERBOSE=true
        ;;
    -name)
        shift
        update_hostname "$1"  # Call function to update hostname with provided argument
        ;;
    -ip)
        shift
        update_ip_address "$1"  # Call function to update IP address with provided argument
        ;;
    -hostentry)
        shift
        update_host_entry "$1" "$2"  # Call function to update host entry with provided arguments
        shift
        ;;
    *)
        echo "Unknown option: $key"
        ;;
    esac
    shift
done

exit 0
