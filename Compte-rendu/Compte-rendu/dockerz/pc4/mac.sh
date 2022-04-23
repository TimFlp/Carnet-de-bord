#!/bin/sh

ip link set eth0 down
ip link set eth0 address 00:42:38:44:44:44  
ip link set eth0 up
dhclient eth0

