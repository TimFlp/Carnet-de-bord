#!/bin/sh

ip link set eth0 down
ip link set eth0 address 00:42:38:55:55:55  
ip link set eth0 up
dhclient eth0

