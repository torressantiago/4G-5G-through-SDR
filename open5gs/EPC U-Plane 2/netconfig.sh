#!/bin/bash
sudo ip add add 192.168.0.113/24 dev enp0s8

#[tun3]
sudo ip tuntap add name ogstun3 mode tun
sudo ip add add 10.47.0.1/16 dev ogstun3
sudo ip link set ogstun3 up

sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun3 -j MASQUERADE
