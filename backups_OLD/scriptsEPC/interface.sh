# MME
sudo ifconfig enp5s0f3:m11 172.16.1.102/24 up
sudo ip addr add 192.168.247.102/24 dev enp5s0f3 # M1C
 
# SPGW C
sudo ifconfig enp5s0f1:sxc 172.55.55.101/24 up # SPGW-C SXab interface
sudo ifconfig enp5s0f1:s5c 172.58.58.102/24 up # SGW-C S5S8 interface
sudo ifconfig enp5s0f1:p5c 172.58.58.101/24 up # PGW-C S5S8 interface
sudo ifconfig enp5s0f1:s11 172.16.1.104/24 up  # SGW-C S11 interface
 
#SPGW-U
sudo ifconfig enp5s0f1:sxu 172.55.55.102/24 up   # SPGW-U SXab interface
sudo ip addr add 192.168.248.159/24 dev enp5s0f2 # SPGW-U S1U interface
