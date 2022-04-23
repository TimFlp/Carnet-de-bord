#!/bin/sh

ip link set eth0 down
ip link set eth0 address 00:42:38:11:11:11  
ip link set eth0 up
dhclient eth0
service ssh start
echo "PasswordAuthentication yes" >> /etc/ssh/ssh_config
echo "Port 22" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
useradd -d /home/pc1-ssh -p password test


