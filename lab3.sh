#!/bin/bash
# This script transfers and runs the configure-host.sh script on two servers and updates the local /etc/hosts file

# Transfer configure-host.sh to server1-mgmt
scp configure-host.sh abhay@server1-mgmt:/root

# Run configure-host.sh on server1-mgmt
ssh abhay@server1-mgmt -- /root/configure-host.sh -name loghost -ip 192.168.16.3 -hostentry webhost 192.168.16.4

# Transfer configure-host.sh to server2-mgmt
scp configure-host.sh abhay@server2-mgmt:/root

# Run configure-host.sh on server2-mgmt
ssh abhay@server2-mgmt -- /root/configure-host.sh -name webhost -ip 192.168.16.4 -hostentry loghost 192.168.16.3

# Update local /etc/hosts file
./configure-host.sh -hostentry loghost 192.168.16.3
./configure-host.sh -hostentry webhost 192.168.16.4
