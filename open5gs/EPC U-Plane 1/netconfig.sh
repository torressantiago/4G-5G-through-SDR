#!/bin/bash
sudo ip add add 192.168.0.112/24 dev enp0s8

#[tun1]
sudo ip tuntap add name ogstun mode tun
sudo ip add add 10.45.0.1/16 dev ogstun
sudo ip link set ogstun up

sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE

#[tun2]
sudo ip tuntap add name ogstun2 mode tun
sudo ip add add 10.46.0.1/16 dev ogstun2
sudo ip link set ogstun2 up

sudo iptables -t nat -A POSTROUTING -s 10.46.0.0/16 ! -o ogstun2 -j MASQUERADE
